//
//  NSMutableArray+Stack.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)object {
    [self addObject:object];
}

- (id)pop {
    if ([self count] == 0) {
        return nil;
    }

    id object = [self lastObject];
    [self removeLastObject];

    return object;
}

@end
