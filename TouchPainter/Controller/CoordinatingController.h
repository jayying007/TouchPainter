//
//  CoordinatingController.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>
#import "CanvasViewController.h"
#import "PaletteViewController.h"
#import "ThumbnailViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    kButtonTagDone,
    kButtonTagOpenPaletteView,
    kButtonTagOpenThumbnailView,
} ButtonTag;

@interface CoordinatingController : NSObject

+ (instancetype)sharedInstance;

- (UIViewController *)activeViewController;
- (CanvasViewController *)canvasViewController;

- (void)requestViewChangeByObject:(id)object;

@end

NS_ASSUME_NONNULL_END
