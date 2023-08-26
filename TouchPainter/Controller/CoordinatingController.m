//
//  CoordinatingController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "CoordinatingController.h"

@interface CoordinatingController ()

@property (nonatomic) UIViewController *activeController;
@property (nonatomic) CanvasViewController *canvasViewController;

@end

@implementation CoordinatingController

- (void)requestViewChangeByObject:(id)object {
    if ([object isKindOfClass:[UIBarButtonItem class]]) {
        switch ([(UIBarButtonItem *)object tag]) {
            case kButtonTagOpenPaletteView: {
                PaletteViewController *controller = [[PaletteViewController alloc] init];
                [_canvasViewController presentViewController:controller animated:YES completion:nil];
                _activeController = controller;
            } break;

            case kButtonTagOpenThumbnailView: {
                ThumbnailViewController *controller = [[ThumbnailViewController alloc] init];
                [_canvasViewController presentViewController:controller animated:YES completion:nil];
                _activeController = controller;
            } break;

            default: {
                [_canvasViewController dismissViewControllerAnimated:YES completion:nil];
                _activeController = _canvasViewController;
            } break;
        }
    } else {
        [_canvasViewController dismissViewControllerAnimated:YES completion:nil];
        _activeController = _canvasViewController;
    }
}

@end
