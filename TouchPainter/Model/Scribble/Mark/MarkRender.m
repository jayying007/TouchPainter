//
//  MarkRender.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "MarkRender.h"

@interface MarkRender ()

@property (nonatomic) CGContextRef context;
@property (nonatomic) BOOL shouldMoveContextToDot;

@end

@implementation MarkRender

- (instancetype)initWithCGContext:(CGContextRef)context {
    if (self = [super init]) {
        _context = context;
        _shouldMoveContextToDot = YES;
    }
    return self;
}

- (void)visitMark:(id<Mark>)mark {
}

- (void)visitDot:(Dot *)dot {
    CGFloat x = dot.location.x;
    CGFloat y = dot.location.y;
    CGFloat frameSize = dot.size;
    CGRect frame = CGRectMake(x - frameSize / 2, y - frameSize / 2, frameSize, frameSize);

    CGContextSetFillColorWithColor(_context, dot.color.CGColor);
    CGContextFillEllipseInRect(_context, frame);
}

- (void)visitVertext:(Vertex *)vertex {
    CGFloat x = vertex.location.x;
    CGFloat y = vertex.location.y;

    if (_shouldMoveContextToDot) {
        CGContextMoveToPoint(_context, x, y);
        _shouldMoveContextToDot = NO;
    } else {
        CGContextAddLineToPoint(_context, x, y);
    }
}

- (void)visitStroke:(Stroke *)stroke {
    CGContextSetStrokeColorWithColor(_context, [stroke.color CGColor]);
    CGContextSetLineWidth(_context, stroke.size);
    CGContextSetLineCap(_context, kCGLineCapRound);
    CGContextStrokePath(_context);
    _shouldMoveContextToDot = YES;
}

@end
