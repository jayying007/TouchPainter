//
//  SetStrokeSizeCommand.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/27.
//

#import "SetStrokeSizeCommand.h"
#import "CoordinatingController.h"

@implementation SetStrokeSizeCommand

- (void)execute {
    CGFloat sizeValue = 0;

    [_delegate command:self didRequestSize:&sizeValue];

    CoordinatingController *coordinator = [CoordinatingController sharedInstance];
    CanvasViewController *controller = [coordinator canvasViewController];
    [controller setStrokeSize:sizeValue];

    [_delegate command:self didFinishSizeUpdateWithSize:sizeValue];
}

@end
