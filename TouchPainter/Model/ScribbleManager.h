//
//  ScribbleManager.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Scribble;

@interface ScribbleManager : NSObject

- (void)saveScribble:(Scribble *)scribble thumbnail:(UIImage *)image;

- (NSInteger)numberOfScribbles;

- (Scribble *)scribbleAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
