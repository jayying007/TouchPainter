//
//  Dot.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "Dot.h"

@implementation Dot

@synthesize color = _color;
@synthesize size = _size;

- (void)drawWithContext:(CGContextRef)context {
    CGFloat x = self.location.x;
    CGFloat y = self.location.y;
    CGFloat frameSize = self.size;
    CGRect frame = CGRectMake(x - frameSize / 2, y - frameSize / 2, frameSize, frameSize);

    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    CGContextFillEllipseInRect(context, frame);
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    [visitor visitDot:self];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    Dot *dot = [(Dot *)[[self class] alloc] initWithLocation:self.location];
    dot.color = self.color;
    dot.size = self.size;

    return dot;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _color = [coder decodeObjectForKey:@"DotColor"];
        _size = [coder decodeFloatForKey:@"DotSize"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_color forKey:@"DotColor"];
    [coder encodeFloat:_size forKey:@"DotSize"];
}

@end
