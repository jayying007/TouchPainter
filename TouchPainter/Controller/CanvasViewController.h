//
//  CanvasViewController.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import <UIKit/UIKit.h>
#import "CanvasViewGenerator.h"
#import "Scribble.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasViewController : UIViewController

/// 加载画布
- (void)loadCanvasViewWithGenerator:(CanvasViewGenerator *)generator;

/// 修改画笔颜色
@property (nonatomic) UIColor *strokeColor;
/// 修改画笔大小
@property (nonatomic) CGFloat strokeSize;

@end

NS_ASSUME_NONNULL_END
