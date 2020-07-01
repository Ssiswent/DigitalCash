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

@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
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
