//
//  FindVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindVC.h"

#import "FindRecommendVC.h"
#import "FindFocusVC.h"

#import "PublishVC.h"

#import <JXCategoryTitleView.h>

@interface FindVC ()<YPNavigationBarConfigureStyle>

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishBtnBottom;

@property (nonatomic, assign) CGFloat publishBtnBottomConstant;

@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)initialSetUp
{
    [self setNavBar];
    [self setSearchBar];
    [self.view bringSubviewToFront:_publishBtn];
    
    _publishBtnBottomConstant = 60;
    
    //8(SE2)
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        _publishBtnBottomConstant = 60;
    }
    //11 Pro
    else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
    {
        _publishBtnBottomConstant = 100;
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        _publishBtnBottomConstant = 80;
    }
    //11 Pro Max
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
    {
        _publishBtnBottomConstant = 120;
    }
    _publishBtnBottom.constant = _publishBtnBottomConstant;
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

- (void)setSearchBar
{
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
    } else {
        // Fallback on earlier versions
    }
//    _searchBar.searchTextField.textColor = [UIColor colorWithHexString:@"#2A39FB"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    
    [self.view bringSubviewToFront:_searchBar];
}

- (IBAction)publishBtnClicked:(id)sender {
    PublishVC *publishVC = [PublishVC new];
    YPNavigationController *navC = [[YPNavigationController alloc]initWithRootViewController:publishVC];
    //    PublishVC.delegate = self;
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)hidePublishBtn
{
    CGRect hideFrame = _publishBtn.frame;
    hideFrame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        WEAKSELF
        weakSelf.publishBtn.frame = hideFrame;
    }];
}

- (void)showPublishBtn
{
    CGRect showFrame = _publishBtn.frame;
    CGFloat showY = SCREEN_HEIGHT - (_publishBtnBottomConstant + 60);
    showFrame.origin.y = showY;
    [UIView animateWithDuration:0.5 animations:^{
        WEAKSELF
        weakSelf.publishBtn.frame = showFrame;
    }];
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
    
    WEAKSELF
    if (index == 0)
    {
        FindRecommendVC *findRecommendVC = [FindRecommendVC new];
        findRecommendVC.hideBlock = ^{
            [weakSelf hidePublishBtn];
        };
        findRecommendVC.showBlock = ^{
            [weakSelf showPublishBtn];
        };
        return findRecommendVC;
    }
    else
    {
        FindFocusVC *findFocusVC = [FindFocusVC new];
        findFocusVC.hideBlock = ^{
            [weakSelf hidePublishBtn];
        };
        findFocusVC.showBlock = ^{
            [weakSelf showPublishBtn];
        };
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
