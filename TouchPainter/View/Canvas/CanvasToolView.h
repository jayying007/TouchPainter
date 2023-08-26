//
//  CanvasToolView.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CanvasToolViewDelegate

- (void)onDelete;
- (void)onSave;
- (void)onOpen;
- (void)onPalette;
- (void)onUndo;
- (void)onRedo;

@end

@interface CanvasToolView : UIView

@property (nonatomic, weak) id<CanvasToolViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
