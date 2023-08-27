//
//  SetStrokeColorCommand.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "Command.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SetStrokeColorCommand;

@protocol SetStrokeColorCommandDelegate

- (void)command:(SetStrokeColorCommand *)command didRequestColorComponentsForRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue;

- (void)command:(SetStrokeColorCommand *)command didFinishColorUpdateWithColor:(UIColor *)color;

@end

@interface SetStrokeColorCommand : Command

@property (nonatomic, weak) id<SetStrokeColorCommandDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
