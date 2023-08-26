//
//  MarkEnumerator.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "MarkEnumerator.h"
#import "NSMutableArray+Stack.h"

@interface MarkEnumerator ()

@property (nonatomic) NSMutableArray *stack;

@end

@implementation MarkEnumerator

- (instancetype)initWithMark:(id<Mark>)mark {
    if (self = [super init]) {
        _stack = [[NSMutableArray alloc] init];
        [self traverseAndBuildStackWithMark:mark];
    }
    return self;
}

- (NSArray *)allObjects {
    return [[_stack reverseObjectEnumerator] allObjects];
}

- (id)nextObject {
    return [_stack pop];
}

#pragma mark - Private

- (void)traverseAndBuildStackWithMark:(id<Mark>)mark {
    if (mark == nil) {
        return;
    }

    [_stack push:mark];

    for (int i = (int)[mark count] - 1; i >= 0; i--) {
        id<Mark> childMark = [mark childMarkAtIndex:i];
        [self traverseAndBuildStackWithMark:mark];
    }
}

@end
