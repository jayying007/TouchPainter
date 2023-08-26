//
//  Mark.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import <UIKit/UIKit.h>
#import "MarkVisitor.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Mark <NSObject, NSCopying, NSCoding>

@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGPoint location;

/// 子节点的个数
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) id<Mark> lastChild;

- (void)addMark:(id<Mark>)mark;
- (void)removeMark:(id<Mark>)mark;
- (id<Mark>)childMarkAtIndex:(int)index;

- (void)drawWithContext:(CGContextRef)context;

- (id)copy;

- (NSEnumerator *)enumerator;

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor;

@end

NS_ASSUME_NONNULL_END
