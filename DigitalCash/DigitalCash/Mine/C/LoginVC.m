//
//  LoginVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/2.
//

#import "LoginVC.h"

#import "MineUserModel.h"

#import "ForgetVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;

@property (nonatomic, assign)BOOL hasAgreed;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)initialSetUp
{
    _loginViewTop.constant = kScaleFrom_iPhone8_Height(150);
    _accountViewTop.constant = kScaleFrom_iPhone8_Height(49);
    _pwdViewTop.constant = kScaleFrom_iPhone8_Height(22);
    _loginBtnTop.constant = kScaleFrom_iPhone8_Height(25);
    
    _loginView.layer.cornerRadius = 10;
    _loginView.layer.masksToBounds = YES;
    
    [self.accountTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChange {
    if(self.accountTextF.text.length == 11 && self.pwdTextF.text.length != 0)
    {
        _loginBtn.enabled = YES;
    }
    else
    {
        _loginBtn.enabled = NO;
    }
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreeBtnClicked:(id)sender {
    _hasAgreed = !_hasAgreed;
    if(_hasAgreed)
    {
        [_agreeBtn setImage:[UIImage imageNamed:@"ic_agree"] forState:UIControlStateNormal];
    }
    else
    {
        [_agreeBtn setImage:[UIImage imageNamed:@"ic_yinsi_def"] forState:UIControlStateNormal];
    }
}

- (IBAction)loginBtnClicked:(id)sender {
    [self loginWithPwd];
}

- (IBAction)forgetBtnClicked:(id)sender {
    ForgetVC *forgetVC = ForgetVC.new;
    forgetVC.forgetOrRegister = @"forget";
    WEAKSELF
    forgetVC.pwdChangedBlock = ^{
        [Toast makeText:weakSelf.view Message:@"重置密码成功" afterHideTime:DELAYTiME];
    };
    [self presentViewController:forgetVC animated:YES completion:nil];
}

- (IBAction)rigisterBtnClicked:(id)sender {
    ForgetVC *forgetVC = ForgetVC.new;
    forgetVC.forgetOrRegister = @"Register";
    WEAKSELF
    forgetVC.registerSucceedBlock = ^{
        weakSelf.loginVCDidGetUserBlock();
    };
    [self presentViewController:forgetVC animated:YES completion:nil];
}

#pragma mark - API

- (void)loginWithPwd
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":_accountTextF.text,@"password":_pwdTextF.text,@"type":@(1),@"project":ProjectCategory};
    [ENDNetWorkManager getWithPathUrl:@"/system/login" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:result[@"data"] error:&error];
        mineUser.userId = user.userId;
        mineUser.nickName = user.nickName;
        mineUser.followCount = user.followCount;
        mineUser.fansCount = user.fansCount;
        mineUser.head = user.head;
        mineUser.signature = user.signature;
        mineUser.talkCount = user.talkCount;
        
        //获取用户偏好
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //记录userId
        [userDefault setObject:mineUser.userId forKey:@"userId"];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        [self dismissToRootViewController];
        if(weakSelf.loginVCDidGetUserBlock)
        {
            weakSelf.loginVCDidGetUserBlock();
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"登录失败" afterHideTime:DELAYTiME];
    }];
}

@end
