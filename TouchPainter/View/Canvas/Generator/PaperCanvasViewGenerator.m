//
//  PaperCanvasViewGenerator.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "PaperCanvasViewGenerator.h"
#import "PaperCanvasView.h"

@implementation PaperCanvasViewGenerator

- (CanvasView *)canvasViewWithFrame:(CGRect)frame {
    return [[PaperCanvasView alloc] initWithFrame:frame];
}

@end
