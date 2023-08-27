//
//  SetStrokeSizeCommand.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/27.
//

#import "Command.h"

NS_ASSUME_NONNULL_BEGIN

@class SetStrokeSizeCommand;

@protocol SetStrokeSizeCommandDelegate

- (void)command:(SetStrokeSizeCommand *)command didRequestSize:(CGFloat *)size;

- (void)command:(SetStrokeSizeCommand *)command didFinishSizeUpdateWithSize:(CGFloat)size;

@end

@interface SetStrokeSizeCommand : Command

@property (nonatomic, weak) id<SetStrokeSizeCommandDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
