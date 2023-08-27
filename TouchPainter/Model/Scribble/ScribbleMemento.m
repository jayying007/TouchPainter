//
//  ScribbleMemento.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "ScribbleMemento.h"
#import "Mark.h"
#import "Stroke.h"

@interface ScribbleMemento ()

@end

@implementation ScribbleMemento

- (instancetype)initWithMark:(id<Mark>)mark {
    self = [super init];
    if (self) {
        _mark = mark;
    }
    return self;
}

+ (ScribbleMemento *)mementoWithData:(NSData *)data {
    Stroke *restoredMark = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    ScribbleMemento *memento = [[ScribbleMemento alloc] initWithMark:restoredMark];

    return memento;
}

- (NSData *)data {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_mark requiringSecureCoding:NO error:nil];
    return data;
}

@end
