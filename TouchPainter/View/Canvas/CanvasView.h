//
//  CanvasView.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import <UIKit/UIKit.h>
#import "Mark.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView

@property (nonatomic) id<Mark> mark;

- (UIImage *)getImage;

@end

NS_ASSUME_NONNULL_END
