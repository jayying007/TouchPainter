//
//  ThumbnailViewController.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ThumbnailViewController;
@class Scribble;

@protocol ThumbnailViewControllerDelegate

- (void)thumbnailViewController:(ThumbnailViewController *)controller didSelectScribble:(Scribble *)scribble;

@end

@interface ThumbnailViewController : UIViewController

@property (nonatomic, weak) id<ThumbnailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
