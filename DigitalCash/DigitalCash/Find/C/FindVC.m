//
//  FindVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindVC.h"

#import "FindRecommendVC.h"
#import "FindFocusVC.h"

#import <JXCategoryTitleView.h>

@interface FindVC ()<YPNavigationBarConfigureStyle>

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self setSearchBar];
}

- (void)setNavBar
{
    self.titles = @[@"推荐", @"关注"];
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.cellSpacing = 10;
    
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:16.667 weight:bold];
    self.myCategoryView.titleColor = [UIColor colorWithHexString:@"#606060"];
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#272727"];
    self.myCategoryView.titleColorGradientEnabled = YES;
    self.myCategoryView.titleLabelZoomEnabled = YES;
    self.myCategoryView.selectedAnimationEnabled = YES;
    self.myCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
}

- (void)setSearchBar
{
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
    } else {
        // Fallback on earlier versions
    }
//    _searchBar.searchTextField.textColor = [UIColor colorWithHexString:@"#2A39FB"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    
    [self.view bringSubviewToFront:_searchBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if(kIsIPhoneX_Series)
    {
        self.myCategoryView.frame = CGRectMake(7, 64, kScaleFrom_iPhone8_Width(100), 24);
    }
    else
    {
        self.myCategoryView.frame = CGRectMake(7, 40, kScaleFrom_iPhone8_Width(100), 24);
    }
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 0;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return  2;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0)
    {
        FindRecommendVC *findRecommendVC = [FindRecommendVC new];
        return findRecommendVC;
    }
    else
    {
        FindFocusVC *findFocusVC = [FindFocusVC new];
        return findFocusVC;
    }
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

@end
