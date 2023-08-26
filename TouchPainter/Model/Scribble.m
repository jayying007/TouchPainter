//
//  Scribble.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "Scribble.h"
#import "Stroke.h"

@interface Scribble ()

@property (nonatomic) id<Mark> mark;
@property (nonatomic) id<Mark> incrementalMark;

@end

@implementation Scribble

- (instancetype)init {
    if (self = [super init]) {
        _mark = [[Stroke alloc] init];
    }
    return self;
}

- (instancetype)initWithMemento:(ScribbleMemento *)memento {
    if (self = [super init]) {
        if ([memento hasCompleteSnapshot]) {
            [self setMark:[memento mark]];
        } else {
            _mark = [[Stroke alloc] init];
            [self attachStateFromMemento:memento];
        }
    }
    return self;
}

#pragma mark - Public

- (void)addMark:(id<Mark>)mark shouldAddToPreviousMark:(BOOL)shouldAddToPreviousMark {
    [self willChangeValueForKey:@"mark"];

    if (shouldAddToPreviousMark) {
        [[_mark lastChild] addMark:mark];
    } else {
        [_mark addMark:mark];
        _incrementalMark = mark;
    }

    [self didChangeValueForKey:@"mark"];
}

- (void)removeMark:(id<Mark>)mark {
    if (mark == _mark) {
        return;
    }

    [self willChangeValueForKey:@"mark"];

    [_mark removeMark:mark];

    if (mark == _incrementalMark) {
        _incrementalMark = nil;
    }

    [self didChangeValueForKey:@"mark"];
}

- (void)attachStateFromMemento:(ScribbleMemento *)memento {
    [self addMark:[memento mark] shouldAddToPreviousMark:NO];
}

- (ScribbleMemento *)scribbleMenentoWithCompleteSnapshot:(BOOL)hasCompleteSnapshot {
    id<Mark> mementoMark = _incrementalMark;

    if (hasCompleteSnapshot) {
        mementoMark = _mark;
    } else if (mementoMark == nil) {
        return nil;
    }

    ScribbleMemento *memento = [[ScribbleMemento alloc] initWithMark:mementoMark];
    [memento setHasCompleteSnapshot:hasCompleteSnapshot];

    return memento;
}

- (ScribbleMemento *)scribbleMemento {
    return [self scribbleMenentoWithCompleteSnapshot:YES];
}

+ (Scribble *)scribbleWithMemento:(ScribbleMemento *)memento {
    Scribble *scribble = [[Scribble alloc] initWithMemento:memento];
    return scribble;
}

@end
