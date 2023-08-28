//
//  Stroke.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "Stroke.h"
#import "MarkEnumerator.h"

@interface Stroke ()

@property (nonatomic) NSMutableArray<id<Mark>> *children;

@end

@implementation Stroke

@synthesize color = _color;
@synthesize size = _size;

- (instancetype)init {
    if (self = [super init]) {
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setLocation:(CGPoint)location {
}

- (CGPoint)location {
    // 返回第一个子节点的位置
    if (_children.count > 0) {
        return [[_children objectAtIndex:0] location];
    }

    return CGPointZero;
}

- (void)addMark:(id<Mark>)mark {
    [_children addObject:mark];
}

- (void)removeMark:(id<Mark>)mark {
    if ([_children containsObject:mark]) {
        [_children removeObject:mark];
    } else {
        [_children makeObjectsPerformSelector:@selector(removeMark:) withObject:mark];
    }
}

- (id<Mark>)childMarkAtIndex:(int)index {
    if (index >= _children.count) {
        return nil;
    }

    return [_children objectAtIndex:index];
}

- (id<Mark>)lastChild {
    return [_children lastObject];
}

- (NSUInteger)count {
    return [_children count];
}

- (NSEnumerator *)enumerator {
    return [[MarkEnumerator alloc] initWithMark:self];
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    for (id<Mark> mark in _children) {
        [mark acceptMarkVisitor:visitor];
    }
    [visitor visitStroke:self];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    Stroke *stroke = [[[self class] alloc] init];
    stroke.color = self.color;
    stroke.size = self.size;

    for (id<Mark> child in _children) {
        [stroke addMark:[child copy]];
    }

    return stroke;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _color = [coder decodeObjectForKey:@"StrokeColor"];
        _size = [coder decodeFloatForKey:@"StrokeSize"];
        _children = [coder decodeObjectForKey:@"StrokeChildren"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_color forKey:@"StrokeColor"];
    [coder encodeFloat:_size forKey:@"StrokeSize"];
    [coder encodeObject:_children forKey:@"StrokeChildren"];
}

@end
