//
//  ScribbleManager.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "ScribbleManager.h"
#import "ScribbleMemento.h"
#import "Scribble.h"
#import "NSFileManager+Path.h"

@implementation ScribbleManager

- (void)saveScribble:(Scribble *)scribble thumbnail:(UIImage *)image {
    NSInteger newIndex = [self numberOfScribbles] + 1;

    NSString *scribbleDataName = [NSString stringWithFormat:@"data_%d", newIndex];
    NSString *scribbleThumbnailName = [NSString stringWithFormat:@"thumbnail_%d.png", newIndex];

    // 从涂鸦获得备忘录，然后保存到文件系统
    ScribbleMemento *scribbleMemento = [scribble scribbleMemento];
    NSData *mementoData = [scribbleMemento data];
    NSString *mementoPath = [[self scribbleDataPath] stringByAppendingPathComponent:scribbleDataName];
    [mementoData writeToFile:mementoPath atomically:YES];

    // 把缩略图保存到文件系统
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *imagePath = [[self scribbleThumbnailPath] stringByAppendingPathComponent:scribbleThumbnailName];
    [imageData writeToFile:imagePath atomically:YES];
}

- (NSString *)scribbleDataPath {
    NSString *docPath = [NSFileManager documentPath];
    return [docPath stringByAppendingPathComponent:@"scribble"];
}

- (NSString *)scribbleThumbnailPath {
    NSString *docPath = [NSFileManager documentPath];
    return [docPath stringByAppendingPathComponent:@"scribble"];
}

- (Scribble *)scribbleAtIndex:(NSInteger)index {
    NSString *scribbleMementoPath;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *scribbleMementoData = [fileManager contentsAtPath:scribbleMementoPath];

    ScribbleMemento *scribbleMemento = [ScribbleMemento mementoWithData:scribbleMementoData];
    Scribble *scribble = [Scribble scribbleWithMemento:scribbleMemento];

    return scribble;
}

@end
