//
//  NSFileManager+Path.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import "NSFileManager+Path.h"

@implementation NSFileManager (Path)

+ (NSString *)documentPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [[urls firstObject] path];
}

@end
