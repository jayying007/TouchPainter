//
//  SetStrokeColorCommand.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "SetStrokeColorCommand.h"
#import "CoordinatingController.h"
#import "CanvasViewController.h"

@implementation SetStrokeColorCommand

- (void)execute {
    CGFloat redValue = 0;
    CGFloat greenValue = 0;
    CGFloat blueValue = 0;

    [_delegate command:self didRequestColorComponentsForRed:&redValue green:&greenValue blue:&blueValue];

    UIColor *color = [UIColor colorWithRed:redValue / 255 green:greenValue / 255 blue:blueValue / 255 alpha:1];

    CoordinatingController *coordinator = [CoordinatingController sharedInstance];
    CanvasViewController *controller = [coordinator canvasViewController];
    [controller setStrokeColor:color];

    [_delegate command:self didFinishColorUpdateWithColor:color];
}

@end
