//
//  MMUIAlertController.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/28.
//

#import <UIKit/UIKit.h>

@interface MMUIAlertController : UIAlertController

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message fromViewController:(UIViewController *)viewController;

@end
