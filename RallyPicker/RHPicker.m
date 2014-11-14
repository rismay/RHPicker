//
//  CustomUIPicker.m
//  RallyPicker
//
//  Created by Cristian Monterroza on 11/10/14.
//  Copyright (c) 2014 wrkstrm. All rights reserved.
//

#import "RHPicker.h"
#import "RHCollectionViewCell.h"

@interface RHPicker () <UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, readwrite) CGFloat itemHeight;
@property(nonatomic) NSRange selectedRange;
@property(nonatomic) CGAffineTransform identityTransform;

@end

@implementation RHPicker

static NSString * const reuseIdentifier = @"Cell";
#pragma mark - Initialization

- (instancetype)initWithParentView:(UIView *)view
                         withItems:(NSArray *)items
                     selectedColor:(UIColor *)selectedColor
                      defaultColor:(UIColor *)defaultColor {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = CGFLOAT_MAX;
    flowLayout.minimumLineSpacing = 0.0f;
    if ((self = [super initWithCollectionViewLayout:flowLayout])) {
        _pickerItems = items;
        _selectedColor = selectedColor;
        _defaultColor = defaultColor;
        _itemHeight = 30;
        _selectedRange = NSMakeRange(self.collectionView.center.y - _itemHeight / 2, _itemHeight);
        _identityTransform = self.collectionView.transform;
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.frame = self.view.frame = view.frame;
        self.collectionView.bounds = self.view.bounds = view.bounds;
        self.collectionView.clipsToBounds = YES;
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.collectionView.bounces = self.collectionView.alwaysBounceVertical = YES;
        [view addSubview:self.view];
        
        NSIndexPath *firstCell = [NSIndexPath indexPathForRow:self.pickerItems.count / 2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:firstCell
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
        RHCollectionViewCell *cell = (RHCollectionViewCell *)[self.collectionView
                                                              cellForItemAtIndexPath:firstCell];
        [cell setColorToSelected:YES];
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.width, (self.height - self.itemHeight) /2.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.width, (self.height - self.itemHeight) /2.0f);
}

- (UIView *)superview {
    return self.collectionView.superview;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (RHCollectionViewCell *cell in self.collectionView.visibleCells) {
        CGFloat locationInSuperView = cell.center.y - self.collectionView.contentOffset.y;
        //Color :)
        BOOL selected = NSLocationInRange(locationInSuperView, self.selectedRange);
        [cell setColorToSelected:selected];
        //Scale :]
        CGFloat ratio = 1 - fabs(locationInSuperView - self.view.center.y) /
        (CGRectGetHeight(self.view.frame) / 2) * 1.25;
        cell.alpha = ratio;
        [cell scaleToRatio:ratio];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        RHCollectionViewCell *cell = (RHCollectionViewCell *)[self.collectionView
                                                              cellForItemAtIndexPath:indexPath];
        CGFloat locationInSuperView = cell.center.y - targetContentOffset->y;
        BOOL selected = NSLocationInRange(locationInSuperView, self.selectedRange);
        if (selected) {
            [self.collectionView selectItemAtIndexPath:indexPath
                                              animated:YES
                                        scrollPosition:UICollectionViewScrollPositionCenteredVertically];
            self.currentIndex = indexPath.row;
            return;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(picker:didSelectItem:)]) {
        [self.delegate picker:self didSelectItem:self.pickerItems[indexPath.row]];
    }
}

- (NSArray *)pickerItems {
    return WSM_LAZY(_pickerItems, @[@""]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame), self.itemHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.collectionView registerClass:[RHCollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.transform = CGAffineTransformScale(self.identityTransform, 0.001f, 0.001f);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.collectionView.transform = CGAffineTransformScale(self.identityTransform, 1.0f, 1.0f);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.pickerItems.count;
}

- (NSString *)objectInPickerItemsAtIndex:(NSUInteger)index {
    return self.pickerItems[index];
}

- (CGFloat)width {
    return CGRectGetWidth(self.view.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.view.frame);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                           forIndexPath:indexPath];
    WSM_LAZY(cell, [[RHCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height / 5)]);
    NSString *item = [self objectInPickerItemsAtIndex:indexPath.row];
    [cell prepareForItem:item
                fontSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize
           selectedColor:self.selectedColor
            defaultColor:self.defaultColor];
    return cell;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:YES];
    if ([self.delegate respondsToSelector:@selector(picker:didSelectItem:)]) {
        [self.delegate picker:self didSelectItem:[self objectInPickerItemsAtIndex:indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
