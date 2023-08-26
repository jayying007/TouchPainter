//
//  MarkEnumerator.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarkEnumerator : NSEnumerator

- (instancetype)initWithMark:(id<Mark>)mark;

@end

NS_ASSUME_NONNULL_END
