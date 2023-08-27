//
//  Vertex.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "Vertex.h"

@implementation Vertex

- (instancetype)initWithLocation:(CGPoint)location {
    if (self = [super init]) {
        _location = location;
    }
    return self;
}

- (void)drawWithContext:(CGContextRef)context {
    CGFloat x = self.location.x;
    CGFloat y = self.location.y;

    CGContextAddLineToPoint(context, x, y);
}

#pragma mark - Mark

- (void)setColor:(UIColor *)color {
}

- (UIColor *)color {
    return nil;
}

- (void)setSize:(CGFloat)size {
}

- (CGFloat)size {
    return 0;
}

- (void)addMark:(id<Mark>)mark {
}

- (void)removeMark:(id<Mark>)mark {
}

- (id<Mark>)childMarkAtIndex:(int)index {
    return nil;
}

- (id<Mark>)lastChild {
    return nil;
}

- (NSUInteger)count {
    return 0;
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    [visitor visitVertext:self];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    Vertex *vertex = [(Vertex *)[[self class] alloc] initWithLocation:_location];

    return vertex;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _location = [[coder decodeObjectForKey:@"VertexLocation"] CGPointValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSValue valueWithCGPoint:_location] forKey:@"VertexLocation"];
}

@end
