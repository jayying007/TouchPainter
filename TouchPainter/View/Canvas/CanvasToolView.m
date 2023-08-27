//
//  CanvasToolView.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "CanvasToolView.h"
#import "UIView+Frame.h"

@implementation CanvasToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = UIColor.lightGrayColor;

    int margin = 16;
    int itemSize = (self.width - 7 * margin) / 6;
    int x = margin;

    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    x = x + itemSize + margin;

    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [saveButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
    x = x + itemSize + margin;

    UIButton *openButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [openButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(onOpen) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openButton];
    x = x + itemSize + margin;

    UIButton *paletteButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [paletteButton setImage:[UIImage imageNamed:@"palette"] forState:UIControlStateNormal];
    [paletteButton addTarget:self action:@selector(onPalette) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:paletteButton];
    x = x + itemSize + margin;

    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [undoButton setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(onUndo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undoButton];
    x = x + itemSize + margin;

    UIButton *redoButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, itemSize, itemSize)];
    [redoButton setImage:[UIImage imageNamed:@"redo"] forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(onRedo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redoButton];

    self.height = itemSize * 2;
}

#pragma mark - UIEvent

- (void)onDelete {
    [_delegate onDelete];
}

- (void)onSave {
    [_delegate onSave];
}

- (void)onOpen {
    [_delegate onOpen];
}

- (void)onPalette {
    [_delegate onPalette];
}

- (void)onUndo {
    [_delegate onUndo];
}

- (void)onRedo {
    [_delegate onRedo];
}

@end
