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

- (void)loadCanvasViewWithGenerator:(CanvasViewGenerator *)generator;
- (void)loadCanvasViewWithScribble:(Scribble *)scribble;

@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat strokeSize;

@end

NS_ASSUME_NONNULL_END
