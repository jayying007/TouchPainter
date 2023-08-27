//
//  CanvasViewController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "CanvasViewController.h"
#import "Scribble.h"
#import "Stroke.h"
#import "Vertex.h"
#import "Dot.h"
#import "CanvasToolView.h"
#import "UIView+Frame.h"
#import "PaletteViewController.h"
#import "CoordinatingController.h"
#import "ScribbleManager.h"

@interface CanvasViewController () <CanvasToolViewDelegate>

@property (nonatomic) CanvasView *canvasView;
@property (nonatomic) CanvasToolView *toolView;

@property (nonatomic) CGPoint startPoint;

@property (nonatomic) Scribble *scribble;

@end

@implementation CanvasViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _strokeColor = UIColor.blackColor;
        _strokeSize = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CanvasViewGenerator *generator = [[CanvasViewGenerator alloc] init];
    [self loadCanvasViewWithGenerator:generator];

    _toolView = [[CanvasToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    _toolView.bottom = self.view.bottom;
    _toolView.delegate = self;
    [self.view addSubview:_toolView];

    Scribble *scribble = [[Scribble alloc] init];
    [self setScribble:scribble];
}

- (void)setScribble:(Scribble *)scribble {
    if (_scribble != scribble) {
        _scribble = scribble;
        [_scribble addObserver:self forKeyPath:@"mark" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - Public

- (void)loadCanvasViewWithGenerator:(CanvasViewGenerator *)generator {
    [_canvasView removeFromSuperview];
    CGRect frame = self.view.bounds;
    _canvasView = [generator canvasViewWithFrame:frame];
    [self.view addSubview:_canvasView];
}

- (void)loadCanvasViewWithScribble:(Scribble *)scribble {
    [self setScribble:scribble];
    [self.undoManager removeAllActions];
}

#pragma mark - UI Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _startPoint = [[touches anyObject] locationInView:_canvasView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint lastPoint = [[touches anyObject] previousLocationInView:_canvasView];

    // 如果这是手指的拖动，就向涂鸦添加一个线条
    if (CGPointEqualToPoint(lastPoint, _startPoint)) {
        id<Mark> newStroke = [[Stroke alloc] init];
        [newStroke setColor:_strokeColor];
        [newStroke setSize:_strokeSize];
        [self addMarkWithUndo:newStroke];
    }

    // 把当前触摸作为顶点添加到临时线条
    CGPoint thisPoint = [[touches anyObject] locationInView:_canvasView];
    Vertex *vertex = [[Vertex alloc] initWithLocation:thisPoint];

    // 由于不需要撤销每一个顶点，所以保留这条语句
    [_scribble addMark:vertex shouldAddToPreviousMark:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint lastPoint = [[touches anyObject] previousLocationInView:_canvasView];
    CGPoint thisPoint = [[touches anyObject] locationInView:_canvasView];

    // 如果触摸从未移动，就向现有Stroke组合中添加一个点，否则把它作为最后一个顶点添加到临时线条
    if (CGPointEqualToPoint(lastPoint, thisPoint)) {
        Dot *singleDot = [[Dot alloc] initWithLocation:thisPoint];
        [singleDot setColor:_strokeColor];
        [singleDot setSize:_strokeSize];
        [self addMarkWithUndo:singleDot];
    }

    // 重置起点
    _startPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 重置起点
    _startPoint = CGPointZero;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([object isKindOfClass:[Scribble class]] && [keyPath isEqualToString:@"mark"]) {
        id<Mark> mark = [change objectForKey:NSKeyValueChangeNewKey];
        [_canvasView setMark:mark];
        [_canvasView setNeedsDisplay];
    }
}

#pragma mark - 撤销 & 恢复

- (void)addMarkWithUndo:(id<Mark>)mark {
    // 取得用于绘图的NSInvocation，并为绘图命令设置新的参数
    NSInvocation *drawInvocation = [self drawScribbleInvocation];
    [drawInvocation setArgument:&mark atIndex:2];

    // 取得用于撤销绘图的NSInvocation，并为撤销绘图命令设置新的参数
    NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
    [undrawInvocation setArgument:&mark atIndex:2];

    // 执行带有撤销命令的绘图命令
    [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
}

- (void)clearScribbleWithUndo {
    NSInvocation *deleteInvocation = [self deleteScribbleInvocation];
    Scribble *scribble = [[Scribble alloc] init];
    [deleteInvocation setArgument:&scribble atIndex:2];

    NSInvocation *restoreInvocation = [self restoreScribbleInvocation];
    [restoreInvocation setArgument:&_scribble atIndex:2];

    [self executeInvocation:deleteInvocation withUndoInvocation:restoreInvocation];
}

- (NSInvocation *)drawScribbleInvocation {
    NSMethodSignature *executeMethodSignature = [_scribble methodSignatureForSelector:@selector(addMark:shouldAddToPreviousMark:)];
    NSInvocation *drawInvocation = [NSInvocation invocationWithMethodSignature:executeMethodSignature];
    [drawInvocation setTarget:_scribble];
    [drawInvocation setSelector:@selector(addMark:shouldAddToPreviousMark:)];
    BOOL attachToPreviousMark = NO;
    [drawInvocation setArgument:&attachToPreviousMark atIndex:3];

    return drawInvocation;
}

- (NSInvocation *)undrawScribbleInvocation {
    NSMethodSignature *unexecuteMethodSignature = [_scribble methodSignatureForSelector:@selector(removeMark:)];
    NSInvocation *undrawInvocation = [NSInvocation invocationWithMethodSignature:unexecuteMethodSignature];
    [undrawInvocation setTarget:_scribble];
    [undrawInvocation setSelector:@selector(removeMark:)];

    return undrawInvocation;
}

- (NSInvocation *)deleteScribbleInvocation {
    NSMethodSignature *executeMethodSignature = [self methodSignatureForSelector:@selector(setScribble:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:executeMethodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(setScribble:)];

    return invocation;
}

- (NSInvocation *)restoreScribbleInvocation {
    NSMethodSignature *unexecuteMethodSignature = [self methodSignatureForSelector:@selector(setScribble:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:unexecuteMethodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(setScribble:)];

    return invocation;
}

- (void)executeInvocation:(NSInvocation *)invocation withUndoInvocation:(NSInvocation *)undoInvocation {
    [invocation retainArguments];

    [[self.undoManager prepareWithInvocationTarget:self] unexecuteInvocation:undoInvocation withRedoInvocation:invocation];

    [invocation invoke];
}

- (void)unexecuteInvocation:(NSInvocation *)invocation withRedoInvocation:(NSInvocation *)redoInvocation {
    [[self.undoManager prepareWithInvocationTarget:self] executeInvocation:redoInvocation withUndoInvocation:invocation];

    [invocation invoke];
}

#pragma mark - CanvasToolViewDelegate

- (void)onDelete {
    [self clearScribbleWithUndo];
}

- (void)onSave {
    [[ScribbleManager sharedInstance] saveScribble:_scribble thumbnail:[_canvasView getImage]];

    // 创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"保存成功"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 创建UIAlertAction
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 在视图控制器中显示UIAlertController
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onOpen {
    NSDictionary *info = @{ @"tag" : @(kButtonTagOpenThumbnailView) };
    [[CoordinatingController sharedInstance] requestViewChangeWithInfo:info];
}

- (void)onPalette {
    NSDictionary *info = @{ @"tag" : @(kButtonTagOpenPaletteView) };
    [[CoordinatingController sharedInstance] requestViewChangeWithInfo:info];
}

- (void)onUndo {
    [self.undoManager undo];
}

- (void)onRedo {
    [self.undoManager redo];
}

@end
