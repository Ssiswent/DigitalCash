//
//  TableHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "TableHeaderView.h"

#import "TableHeaderCollectionCell.h"

#import <TYCyclePagerView.h>
#import <TYPageControl.h>

@interface TableHeaderView()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (weak, nonatomic) TYCyclePagerView *homePagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) NSArray *bannerImgsArray;

@end

@implementation TableHeaderView

- (NSArray *)bannerImgsArray
{
    if(_bannerImgsArray == nil)
    {
        NSArray *temp = [NSArray arrayWithObjects:@"banner1", @"banner2", @"banner1", nil];
        _bannerImgsArray = temp;
    }
    return _bannerImgsArray;
}

NSString *TableHeaderCollectionCellID = @"TableHeaderCollectionCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPagerView];
        [self addPageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _homePagerView.frame =  self.bounds;
    _pageControl.frame = CGRectMake(295, CGRectGetHeight(_homePagerView.frame) - 10.5, 46, 4);
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:NSStringFromClass([TableHeaderCollectionCell class])bundle:nil] forCellWithReuseIdentifier:TableHeaderCollectionCellID];
    [self addSubview:pagerView];
    _homePagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 4);
    pageControl.pageIndicatorSize = CGSizeMake(12, 4);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
    [_homePagerView addSubview:pageControl];
    _pageControl = pageControl;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    _pageControl.numberOfPages = self.bannerImgsArray.count;
    return self.bannerImgsArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TableHeaderCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:TableHeaderCollectionCellID forIndex:index];
    cell.bannerImgView.image = [UIImage imageNamed:self.bannerImgsArray[index]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(345, 125);
    layout.itemSpacing = 50;
    layout.layoutType = normal;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
}

@end
