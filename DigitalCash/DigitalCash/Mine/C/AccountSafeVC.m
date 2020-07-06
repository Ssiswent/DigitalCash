//
//  AccountSafeVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import "AccountSafeVC.h"

#import "ForgetVC.h"

#import "CustomTBC.h"

#import "MineLogoutView.h"

@interface AccountSafeVC ()<UIGestureRecognizerDelegate, YPNavigationBarConfigureStyle, MineLogoutViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *changePwdView;
@property (nonatomic, strong)NSNumber *userId;

@property (weak, nonatomic) UIView *coverView;
@property (weak, nonatomic) MineLogoutView *mineLogoutView;

@end

@implementation AccountSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self getUserDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = @"账号安全";
    
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
    
    [self addchangePwdViewGes];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (IBAction)logOffBtnClicked:(id)sender {
    MineLogoutView *mineLogoutView = [[NSBundle mainBundle]loadNibNamed:@"MineLogoutView" owner:nil options:nil].firstObject;
    mineLogoutView.delegate = self;
    mineLogoutView.titleLabel.text = @"确定要注销吗";
    self.mineLogoutView = mineLogoutView;
    [self addCoverView];
}

- (void)addchangePwdViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePwdViewClicked)];
    [_changePwdView addGestureRecognizer:tap];
}

- (void)changePwdViewClicked
{
    ForgetVC *forgetVC = ForgetVC.new;
    forgetVC.forgetOrRegister = @"forget";
    WEAKSELF
    forgetVC.pwdChangedBlock = ^{
        [Toast makeText:weakSelf.view Message:@"重置密码成功" afterHideTime:DELAYTiME];
    };
    [self presentViewController:forgetVC animated:YES completion:nil];
}

#pragma mark - MineLogoutViewDelegate

- (void)mineLogoutViewDidClickCancelBtn:(MineLogoutView *)mineLogoutView
{
    [self removeCoverView];
}

- (void)mineLogoutViewDidClickConfirmBtn:(MineLogoutView *)mineLogoutView
{
    [self logOff];
}

// MARK: Add&RemoveCoverView

- (void)removeCoverView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.mineLogoutView.titleLabel.hidden = YES;
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.mineLogoutView.alpha = 0;
        CGRect frame = self.mineLogoutView.frame;
        frame.size = CGSizeMake(0, 0);
        self.mineLogoutView.frame = frame;
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView
{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _mineLogoutView.alpha = 0;
    _mineLogoutView.center = coverView.center;
    CGRect frame = _mineLogoutView.frame;
    frame.size = CGSizeMake(0, 0);
    _mineLogoutView.frame = frame;
    [coverView addSubview:_mineLogoutView];
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.mineLogoutView.alpha = 1;
        CGRect frame = self.mineLogoutView.frame;
        frame.size = CGSizeMake(340, 181);
        self.mineLogoutView.frame = frame;
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

#pragma mark - API

- (void)logOff
{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager getWithPathUrl:@"/user/personal/deleteByUserId" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        if(weakSelf.accountLogOffBlock)
        {
            weakSelf.accountLogOffBlock();
        }
        [self removeCoverView];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"注销失败" afterHideTime:DELAYTiME];
    }];
}

@end
