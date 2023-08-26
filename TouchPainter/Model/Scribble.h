//
//  Scribble.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <Foundation/Foundation.h>
#import "Mark.h"
#import "ScribbleMemento.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scribble : NSObject

/// 手指从触摸到松开，生成的所有顶点Vertex都在同一条线Stroke中，即shouldAddToPreviousMark会传YES，下次重新触摸时才传NO。
- (void)addMark:(id<Mark>)mark shouldAddToPreviousMark:(BOOL)shouldAddToPreviousMark;
- (void)removeMark:(id<Mark>)mark;

- (instancetype)initWithMemento:(ScribbleMemento *)memento;
+ (Scribble *)scribbleWithMemento:(ScribbleMemento *)memento;
- (ScribbleMemento *)scribbleMemento;
- (ScribbleMemento *)scribbleMenentoWithCompleteSnapshot:(BOOL)hasCompleteSnapshot;
- (void)attachStateFromMemento:(ScribbleMemento *)memento;

@end

NS_ASSUME_NONNULL_END
