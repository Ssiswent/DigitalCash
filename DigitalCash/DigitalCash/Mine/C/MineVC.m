//
//  MineVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "MineVC.h"

#import "LoginVC.h"

@interface MineVC ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *logoutView;

@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)initialSetup
{
    _avatarView.layer.cornerRadius = 27.5;
    _avatarView.layer.borderColor = UIColor.whiteColor.CGColor;
    _avatarView.layer.borderWidth = 1;
    _avatarView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 27;
    _avatarImgView.layer.masksToBounds = YES;
    
    _countViewTop.constant = kScaleFrom_iPhone8_Height(65.5);
    _bgImgViewHeight.constant = kScaleFrom_iPhone8_Height(168.5);
    _contentViewTop.constant = kScaleFrom_iPhone8_Height(45);
    
    _stackView.spacing = kScaleFrom_iPhone8_Height(28.5);

    [self addGestures];
}

- (void)addGestures
{
    [self addClickAccountViewGes];
}

- (void)addClickAccountViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountViewClicked)];
    [_accountView addGestureRecognizer:tap];
}

- (void)accountViewClicked
{
    //    if(_hasUserId)
    //    {
    //        MineDynamicVC *pageVC = MineDynamicVC.new;
    //        [self.navigationController pushViewController:pageVC animated:YES];
    //    }
    //    else
    //    {
    LoginVC *loginVC = [LoginVC new];
    //        loginVC.delegate = self;
    WEAKSELF
    loginVC.loginVCDidGetUserBlock = ^{
        [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
    };
    [self presentViewController:loginVC animated:YES completion:nil];
    [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    //    }
}

@end
