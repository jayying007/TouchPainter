//
//  CoordinatingController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "CoordinatingController.h"

@interface CoordinatingController ()

@property (nonatomic) UIViewController *activeViewController;
@property (nonatomic) CanvasViewController *canvasViewController;

@end

@implementation CoordinatingController

+ (instancetype)sharedInstance {
    static CoordinatingController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[CoordinatingController alloc] init];
    });
    return controller;
}

- (UIViewController *)activeViewController {
    return _activeViewController;
}

- (CanvasViewController *)canvasViewController {
    if (_canvasViewController == nil) {
        _canvasViewController = [[CanvasViewController alloc] init];
        _activeViewController = _canvasViewController;
    }
    return _canvasViewController;
}

- (void)requestViewChangeWithInfo:(NSDictionary *)info {
    ButtonTag tag = (ButtonTag)[[info objectForKey:@"tag"] intValue];
    switch (tag) {
        case kButtonTagOpenPaletteView: {
            PaletteViewController *controller = [[PaletteViewController alloc] initWithColor:_canvasViewController.strokeColor
                                                                                        size:_canvasViewController.strokeSize];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            [_canvasViewController presentViewController:navController animated:YES completion:nil];
            _activeViewController = controller;
        } break;

        case kButtonTagOpenThumbnailView: {
            ThumbnailViewController *controller = [[ThumbnailViewController alloc] init];
            [_canvasViewController presentViewController:controller animated:YES completion:nil];
            _activeViewController = controller;
        } break;

        default: {
            [_canvasViewController dismissViewControllerAnimated:YES completion:nil];
            _activeViewController = _canvasViewController;
        } break;
    }
}

@end
