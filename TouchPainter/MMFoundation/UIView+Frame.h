//
//  UIView+Frame.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)left;
- (void)setLeft:(CGFloat)left;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

- (CGFloat)top;
- (void)setTop:(CGFloat)top;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;
@end

NS_ASSUME_NONNULL_END
