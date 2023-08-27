//
//  PaletteViewController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "PaletteViewController.h"
#import "SetStrokeColorCommand.h"
#import "CommandSlider.h"
#import "CoordinatingController.h"
#import "UIView+Frame.h"
#import "SetStrokeSizeCommand.h"

@interface PaletteViewController () <SetStrokeColorCommandDelegate, SetStrokeSizeCommandDelegate>

@property (nonatomic) CommandSlider *redSlider;
@property (nonatomic) CommandSlider *greenSlider;
@property (nonatomic) CommandSlider *blueSlider;

@property (nonatomic) UIView *paletteView;

@property (nonatomic) CommandSlider *strokeSlider;

@property (nonatomic) UIColor *initialColor;
@property (nonatomic) CGFloat initialSize;

@end

@implementation PaletteViewController

- (instancetype)initWithColor:(UIColor *)color size:(CGFloat)size {
    if (self = [super init]) {
        _initialColor = color;
        _initialSize = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;

    [self initUI];

    CGFloat redValue = 0;
    CGFloat greenValue = 0;
    CGFloat blueValue = 0;
    [_initialColor getRed:&redValue green:&greenValue blue:&blueValue alpha:0];
    _redSlider.value = redValue * 255;
    _greenSlider.value = greenValue * 255;
    _blueSlider.value = blueValue * 255;
    _strokeSlider.value = _initialSize;
    [_paletteView setBackgroundColor:_initialColor];

    SetStrokeColorCommand *redColorCommand = [[SetStrokeColorCommand alloc] init];
    redColorCommand.delegate = self;
    _redSlider.command = redColorCommand;

    SetStrokeColorCommand *greenColorCommand = [[SetStrokeColorCommand alloc] init];
    greenColorCommand.delegate = self;
    _greenSlider.command = greenColorCommand;

    SetStrokeColorCommand *blueColorCommand = [[SetStrokeColorCommand alloc] init];
    blueColorCommand.delegate = self;
    _blueSlider.command = blueColorCommand;

    SetStrokeSizeCommand *sizeCommand = [[SetStrokeSizeCommand alloc] init];
    sizeCommand.delegate = self;
    _strokeSlider.command = sizeCommand;
}

- (void)initUI {
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.view.bounds];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    [self.view addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.text = @"Color";
    [stackView addArrangedSubview:colorLabel];
    [stackView setCustomSpacing:16 afterView:colorLabel];

    UIStackView *rgbStackView = [[UIStackView alloc] init];
    rgbStackView.axis = UILayoutConstraintAxisVertical;
    rgbStackView.alignment = UIStackViewAlignmentCenter;
    [stackView addArrangedSubview:rgbStackView];
    [stackView setCustomSpacing:32 afterView:rgbStackView];
    rgbStackView.translatesAutoresizingMaskIntoConstraints = NO;

    CommandSlider *slider;
    UIStackView *redStackView = [self createSlider:&slider text:@"R"];
    [rgbStackView addArrangedSubview:redStackView];
    [rgbStackView setCustomSpacing:8 afterView:redStackView];
    _redSlider = slider;
    _redSlider.minimumValue = 0;
    _redSlider.maximumValue = 255;
    _redSlider.tintColor = UIColor.redColor;

    UIStackView *greenStackView = [self createSlider:&slider text:@"G"];
    [rgbStackView addArrangedSubview:greenStackView];
    [rgbStackView setCustomSpacing:8 afterView:greenStackView];
    _greenSlider = slider;
    _greenSlider.minimumValue = 0;
    _greenSlider.maximumValue = 255;
    _greenSlider.tintColor = UIColor.greenColor;

    UIStackView *blueStackView = [self createSlider:&slider text:@"B"];
    [rgbStackView addArrangedSubview:blueStackView];
    [rgbStackView setCustomSpacing:8 afterView:blueStackView];
    _blueSlider = slider;
    _blueSlider.minimumValue = 0;
    _blueSlider.maximumValue = 255;
    _blueSlider.tintColor = UIColor.blueColor;

    _paletteView = [[UIView alloc] init];
    [rgbStackView addArrangedSubview:_paletteView];

    UILabel *strokeLabel = [[UILabel alloc] init];
    strokeLabel.text = @"Stroke";
    [stackView addArrangedSubview:strokeLabel];
    [stackView setCustomSpacing:16 afterView:strokeLabel];

    UIStackView *strokeStackView = [self createSlider:&slider text:@"size"];
    _strokeSlider = slider;
    _strokeSlider.minimumValue = 1;
    _strokeSlider.maximumValue = 20;
    _strokeSlider.tintColor = UIColor.blackColor;
    [stackView addArrangedSubview:strokeStackView];

    [self.view addConstraint:[stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:88]];
    [self.view addConstraint:[stackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor]];
    [self.view addConstraint:[colorLabel.leftAnchor constraintEqualToAnchor:stackView.leftAnchor constant:16]];
    [self.view addConstraint:[rgbStackView.widthAnchor constraintEqualToAnchor:stackView.widthAnchor constant:-32]];
    [self.view addConstraint:[redStackView.widthAnchor constraintEqualToAnchor:rgbStackView.widthAnchor]];
    [self.view addConstraint:[greenStackView.widthAnchor constraintEqualToAnchor:rgbStackView.widthAnchor]];
    [self.view addConstraint:[blueStackView.widthAnchor constraintEqualToAnchor:rgbStackView.widthAnchor]];
    [self.view addConstraint:[strokeLabel.leftAnchor constraintEqualToAnchor:stackView.leftAnchor constant:16]];
    [self.view addConstraint:[_paletteView.widthAnchor constraintEqualToConstant:320]];
    [self.view addConstraint:[_paletteView.heightAnchor constraintEqualToConstant:160]];
    [self.view addConstraint:[strokeStackView.widthAnchor constraintEqualToAnchor:stackView.widthAnchor constant:-32]];
}

- (UIStackView *)createSlider:(CommandSlider **)slider text:(NSString *)text {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [stackView addArrangedSubview:label];

    CommandSlider *tmpSlider = [[CommandSlider alloc] init];
    [tmpSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [stackView addArrangedSubview:tmpSlider];
    *slider = tmpSlider;

    [stackView addConstraint:[label.rightAnchor constraintEqualToAnchor:tmpSlider.leftAnchor constant:-32]];
    [stackView addConstraint:[tmpSlider.rightAnchor constraintEqualToAnchor:stackView.rightAnchor constant:-64]];

    return stackView;
}

#pragma mark - UI Event

- (void)onDone {
    NSDictionary *info = @{ @"tag" : @(kButtonTagDone) };
    [[CoordinatingController sharedInstance] requestViewChangeWithInfo:info];
}

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

#pragma mark - SetStrokeSizeCommandDelegate

- (void)command:(SetStrokeSizeCommand *)command didRequestSize:(CGFloat *)size {
    *size = [_strokeSlider value];
}

- (void)command:(SetStrokeSizeCommand *)command didFinishSizeUpdateWithSize:(CGFloat)size {
}

@end
