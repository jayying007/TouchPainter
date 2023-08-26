//
//  CanvasView.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "CanvasView.h"
#import "MarkRender.h"

@implementation CanvasView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    MarkRender *markRender = [[MarkRender alloc] initWithCGContext:context];
    [_mark acceptMarkVisitor:markRender];
}

@end
