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

+ (instancetype)sharedInstance {
    static ScribbleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ScribbleManager alloc] init];
    });
    return manager;
}

- (void)saveScribble:(Scribble *)scribble thumbnail:(UIImage *)image {
    int newIndex = [self numberOfScribbles] + 1;

    // 从涂鸦获得备忘录，然后保存到文件系统
    ScribbleMemento *scribbleMemento = [scribble scribbleMemento];
    NSData *mementoData = [scribbleMemento data];
    NSString *scribbleDataName = [NSString stringWithFormat:@"data_%d", newIndex];
    NSString *mementoPath = [[self scribblePath] stringByAppendingPathComponent:scribbleDataName];
    [mementoData writeToFile:mementoPath atomically:YES];

    // 把缩略图保存到文件系统
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *scribbleThumbnailName = [NSString stringWithFormat:@"thumbnail_%d.png", newIndex];
    NSString *imagePath = [[self scribblePath] stringByAppendingPathComponent:scribbleThumbnailName];
    [imageData writeToFile:imagePath atomically:YES];
}

- (int)numberOfScribbles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileUrls = [fileManager contentsOfDirectoryAtPath:[self scribblePath] error:&error];
    int filesCount = (int)fileUrls.count;
    return filesCount / 2;
}

- (Scribble *)scribbleAtIndex:(int)index {
    NSString *scribbleDataName = [NSString stringWithFormat:@"data_%d", index];
    NSString *mementoPath = [[self scribblePath] stringByAppendingPathComponent:scribbleDataName];

    NSData *scribbleMementoData = [NSData dataWithContentsOfFile:mementoPath];
    ScribbleMemento *scribbleMemento = [ScribbleMemento mementoWithData:scribbleMementoData];
    Scribble *scribble = [Scribble scribbleWithMemento:scribbleMemento];

    return scribble;
}

- (UIImage *)thumbnailAtIndex:(int)index {
    NSString *scribbleThumbnailName = [NSString stringWithFormat:@"thumbnail_%d.png", index];
    NSString *imagePath = [[self scribblePath] stringByAppendingPathComponent:scribbleThumbnailName];

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    return image;
}

#pragma mark -

- (NSString *)scribblePath {
    NSString *docPath = [NSFileManager documentPath];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"scribble"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

@end
