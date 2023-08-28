//
//  ThumbnailViewController.m
//  TouchPainter
//
//  Created by janezhuang on 2023/8/24.
//

#import "ThumbnailViewController.h"
#import "CoordinatingController.h"
#import "ScribbleManager.h"
#import "UIView+Frame.h"

@interface ThumbnailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) NSMutableDictionary *thumbnailDict;

@end

@implementation ThumbnailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _thumbnailDict = [[NSMutableDictionary alloc] init];
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

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width / 2 - 48, self.view.width / 2 - 48);
    layout.sectionInset = UIEdgeInsetsMake(16, 32, 16, 32);
    layout.minimumLineSpacing = 32;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
}

#pragma mark - UI Event

- (void)onDone {
    NSDictionary *info = @{ @"tag" : @(kButtonTagDone) };
    [[CoordinatingController sharedInstance] requestViewChangeWithInfo:info];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ScribbleManager sharedInstance] numberOfScribbles];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageAtIndexPath:indexPath]];
    imageView.layer.borderColor = UIColor.blackColor.CGColor;
    imageView.layer.borderWidth = 1;
    imageView.clipsToBounds = YES;
    imageView.frame = cell.contentView.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Scribble *scribble = [[ScribbleManager sharedInstance] scribbleAtIndex:(int)indexPath.item + 1];

    [_delegate thumbnailViewController:self didSelectScribble:scribble];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
    id key = @(indexPath.item);
    if ([_thumbnailDict objectForKey:key] == nil) {
        UIImage *image = [[ScribbleManager sharedInstance] thumbnailAtIndex:(int)indexPath.item + 1];
        [_thumbnailDict setObject:image forKey:key];
    }

    return [_thumbnailDict objectForKey:key];
}

@end
