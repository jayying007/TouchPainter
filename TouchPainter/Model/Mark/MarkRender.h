//
//  MarkRender.h
//  TouchPainter
//
//  Created by janezhuang on 2023/8/26.
//

#import <UIKit/UIKit.h>
#import "MarkVisitor.h"
#import "Mark.h"
#import "Dot.h"
#import "Vertex.h"
#import "Stroke.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarkRender : NSObject <MarkVisitor>

- (instancetype)initWithCGContext:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
