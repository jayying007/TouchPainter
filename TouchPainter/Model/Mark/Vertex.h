//
//  Vertex.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "Mark.h"

NS_ASSUME_NONNULL_BEGIN

@interface Vertex : NSObject <Mark>

@property (nonatomic) CGPoint location;

- (instancetype)initWithLocation:(CGPoint)location;

@end

NS_ASSUME_NONNULL_END
