//
//  ClothCanvasViewGenerator.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "ClothCanvasViewGenerator.h"
#import "ClothCanvasView.h"

@implementation ClothCanvasViewGenerator

- (CanvasView *)canvasViewWithFrame:(CGRect)frame {
    return [[ClothCanvasView alloc] initWithFrame:frame];
}

@end
