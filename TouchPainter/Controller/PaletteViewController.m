//
//  PaletteViewController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "PaletteViewController.h"
#import "SetStrokeColorCommand.h"
#import "CommandSlider.h"

@interface PaletteViewController () <SetStrokeColorCommandDelegate>

@property (nonatomic) CommandSlider *redSlider;
@property (nonatomic) CommandSlider *greenSlider;
@property (nonatomic) CommandSlider *blueSlider;

@property (nonatomic) UIView *paletteView;

@end

@implementation PaletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _redSlider = [[CommandSlider alloc] init];
    _greenSlider = [[CommandSlider alloc] init];
    _blueSlider = [[CommandSlider alloc] init];

    [_redSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_greenSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_blueSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UI Event

- (void)onCommandSliderValueChanged:(CommandSlider *)slider {
    [[slider command] execute];
}

#pragma mark - SetStrokeColorCommandDelegate

- (void)command:(SetStrokeColorCommand *)command didRequestColorComponentsForRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue {
    *red = [_redSlider value];
    *green = [_greenSlider value];
    *blue = [_blueSlider value];
}

- (void)command:(SetStrokeColorCommand *)command didFinishColorUpdateWithColor:(UIColor *)color {
    [_paletteView setBackgroundColor:color];
}

@end
