//
//  MMUIAlertController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/28.
//

#import "MMUIAlertController.h"

@interface MMUIAlertController ()

@end

@implementation MMUIAlertController

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message fromViewController:(UIViewController *)viewController {
    // 创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 创建UIAlertAction
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    // 在视图控制器中显示UIAlertController
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
