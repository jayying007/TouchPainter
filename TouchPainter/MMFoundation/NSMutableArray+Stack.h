//
//  NSMutableArray+Stack.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Stack)

- (void)push:(id)object;
- (id)pop;

@end

NS_ASSUME_NONNULL_END
