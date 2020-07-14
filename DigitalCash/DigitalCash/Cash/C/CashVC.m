//
//  CashVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "CashVC.h"

#import "CustomTBC.h"

@interface CashVC ()<YPNavigationBarConfigureStyle, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBottomView];
    [self.view bringSubviewToFront:_bottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
}

- (void)setBottomView
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:62/255.0 green:27/255.0 blue:114/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 37;
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

@end
