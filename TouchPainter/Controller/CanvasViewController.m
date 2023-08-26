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

@interface CanvasViewController ()

@property (nonatomic) CanvasView *canvasView;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat strokeSize;

@property (nonatomic) Scribble *scribble;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CanvasViewGenerator *generator = [[CanvasViewGenerator alloc] init];
    [self loadCanvasViewWithGenerator:generator];

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

        // 取得用于绘图的NSInvocation，并为绘图命令设置新的参数
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&newStroke atIndex:2];

        // 取得用于撤销绘图的NSInvocation，并为撤销绘图命令设置新的参数
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&newStroke atIndex:2];

        // 执行带有撤销命令的绘图命令
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
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

        // 取得用于绘图的NSInvocation，并为绘图命令设置新的参数
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&singleDot atIndex:2];

        // 取得用于撤销绘图的NSInvocation，并为撤销绘图命令设置新的参数
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&singleDot atIndex:2];

        // 执行带有撤销命令的绘图命令
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
    }

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

- (void)executeInvocation:(NSInvocation *)invocation withUndoInvocation:(NSInvocation *)undoInvocation {
    [[self.undoManager prepareWithInvocationTarget:self] unexecuteInvocation:undoInvocation withRndoInvocation:invocation];

    [invocation invoke];
}

- (void)unexecuteInvocation:(NSInvocation *)invocation withRndoInvocation:(NSInvocation *)redoInvocation {
    [[self.undoManager prepareWithInvocationTarget:self] executeInvocation:redoInvocation withUndoInvocation:invocation];

    [invocation invoke];
}

@end
