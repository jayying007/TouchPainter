//
//  CommandSlider.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <UIKit/UIKit.h>
#import "Command.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommandSlider : UISlider

@property (nonatomic) Command *command;

@end

NS_ASSUME_NONNULL_END
