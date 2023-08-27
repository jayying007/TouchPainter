//
//  ScribbleMemento.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScribbleMemento : NSObject

@property (nonatomic) id<Mark> mark;
@property (nonatomic) BOOL hasCompleteSnapshot;

- (instancetype)initWithMark:(id<Mark>)mark;

+ (ScribbleMemento *)mementoWithData:(NSData *)data;
- (NSData *)data;

@end

NS_ASSUME_NONNULL_END
