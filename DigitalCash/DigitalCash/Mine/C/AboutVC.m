//
//  AboutVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import "AboutVC.h"

#import "CustomTBC.h"

#import "UpToDateView.h"
#import "UpToDateCoverView.h"

@interface AboutVC ()<UIGestureRecognizerDelegate, YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *checkUpdateView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) UpToDateCoverView *coverView;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = @"关于我们";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self addcheckUpdateViewGes];
    
    _topView.layer.cornerRadius = CGRectGetWidth(_topView.frame) * 29 / 107.5;
    _topView.layer.masksToBounds = YES;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addcheckUpdateViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkUpdateViewClicked)];
    [_checkUpdateView addGestureRecognizer:tap];
}

- (void)checkUpdateViewClicked
{
    [self addCoverView1];
    _versionLabel.text = @"当前已是最新 V0.2";
    _versionLabel.textColor = [UIColor colorWithHexString:@"#FF5959"];
}

- (void)removeCoverView1
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.coverView.upToDateView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView1
{
    UpToDateCoverView *coverView = [[UpToDateCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    coverView.upToDateView.alpha = 0;
    
    WEAKSELF
    coverView.clickedConfirmBtnBlock1 = ^{
        [weakSelf removeCoverView1];
    };
    
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];

    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.coverView.upToDateView.alpha = 1;
    }];
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarBackgroundStyleTranslucent | YPNavigationBarBackgroundStyleImage | YPNavigationBarStyleBlack;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIImage *)yp_navigationBackgroundImageWithIdentifier:(NSString *__autoreleasing *)identifier
{
    UIImage *image = [UIImage imageNamed:@"bg_nav"];
    return image;
}

@end
