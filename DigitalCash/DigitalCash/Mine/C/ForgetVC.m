//
//  ForgetVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/2.
//

#import "ForgetVC.h"

#import "UIImage+Image.h"

#import "MineCodeView.h"

#import "MineUserModel.h"

#import <ZXCountDownView.h>

//#import <AFNetworking.h>

@interface ForgetVC ()<MineCodeViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rePwdViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changePwdBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet ZXCountDownBtn *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *rePwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) UIView *coverView;
@property (weak, nonatomic) MineCodeView *mineCodeView;
@property (copy, nonatomic) NSString *picCode;

@end

@implementation ForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)initialSetUp
{
    if([_forgetOrRegister isEqualToString:@"forget"])
    {
        [_changePwdBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        _topLabel.text = @"修改密码";
        _pwdTextF.placeholder = @"请输入新密码";
        _rePwdTextF.placeholder = @"请再次输入新密码";
    }
    else if([_forgetOrRegister isEqualToString:@"Register"])
    {
        [_changePwdBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
        _topLabel.text = @"注册账号";
        _pwdTextF.placeholder = @"请输入密码";
        _rePwdTextF.placeholder = @"请再次输入密码";
    }
    
    _loginViewTop.constant = kScaleFrom_iPhone8_Height(150);
    _accountViewTop.constant = kScaleFrom_iPhone8_Height(49);
    _codeViewTop.constant = kScaleFrom_iPhone8_Height(15);
    _rePwdViewTop.constant = kScaleFrom_iPhone8_Height(22);
    _pwdViewTop.constant = kScaleFrom_iPhone8_Height(22);
    _changePwdBtnTop.constant = kScaleFrom_iPhone8_Height(25);
    
    _loginView.layer.cornerRadius = 10;
    _loginView.layer.masksToBounds = YES;
    
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#F85B3A"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgDisabledColor = [UIColor colorWithHexString:@"#AAAAAA"];
    UIImage *btnBgDisabledImg = [UIImage imageWithColor:btnBgDisabledColor];
    [self.codeBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [self.codeBtn setBackgroundImage:btnBgDisabledImg forState:UIControlStateDisabled];
    self.codeBtn.layer.cornerRadius = 13.5;
    self.codeBtn.layer.masksToBounds = YES;
    
    [self.codeBtn setCountDown:60 mark:@"codeBtn" resTextFormat:^NSString * _Nullable(long remainSec) {
        [self codeBtnCountViewStatus];
        //显示剩余几分几秒
        return [NSString stringWithFormat:@"%lds",remainSec];
    }];
    
    [self.accountTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.rePwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

//查看计时器的状态
- (void)codeBtnCountViewStatus {
    //判断计时器是否是开启状态,是就执行以下操作
    if (self.codeBtn.countViewStatus == ZXCountViewStatusRunning) {
        _codeBtn.enabled = NO;
    }
    else
    {
        if(self.accountTextF.text.length == 11)
        {
            _codeBtn.enabled = YES;
        }
    }
}

- (void)textChange {
    if(self.accountTextF.text.length == 11 && self.codeBtn.countViewStatus != ZXCountViewStatusRunning)
    {
        _codeBtn.enabled = YES;
    }
    else
    {
        _codeBtn.enabled = NO;
    }
    
    if(self.accountTextF.text.length == 11 && self.pwdTextF.text.length != 0 && self.rePwdTextF.text.length != 0 && self.codeTextF.text.length != 0)
    {
        _changePwdBtn.enabled = YES;
    }
    else
    {
        _changePwdBtn.enabled = NO;
    }
}

- (IBAction)codeBtnClicked:(id)sender {
    MineCodeView *mineCodeView = [[NSBundle mainBundle]loadNibNamed:@"MineCodeView" owner:nil options:nil].firstObject;
    mineCodeView.delegate = self;
    self.mineCodeView = mineCodeView;
    [self addCoverView];
    [self getPicCode];
}

- (IBAction)changePwdBtnClicked:(id)sender {
    if([_forgetOrRegister isEqualToString:@"forget"])
    {
        [self changePwd];
    }
    else if([_forgetOrRegister isEqualToString:@"Register"])
    {
        [self registerAccount];
    }
}

- (void)removeCoverView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.mineCodeView.alpha = 0;
        CGRect frame = self.mineCodeView.frame;
        frame.size = CGSizeMake(0, 0);
        self.mineCodeView.frame = frame;
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView
{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _mineCodeView.alpha = 0;
    _mineCodeView.center = coverView.center;
    CGRect frame = _mineCodeView.frame;
    frame.size = CGSizeMake(0, 0);
    _mineCodeView.frame = frame;
    [coverView addSubview:_mineCodeView];
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.mineCodeView.alpha = 1;
        CGRect frame = self.mineCodeView.frame;
        frame.size = CGSizeMake(340, 181);
        self.mineCodeView.frame = frame;
    }];
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissToRootViewController  {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MineCodeViewDelegate

- (void)MineCodeViewDidClickCancelBtn:(MineCodeView *)mineCodeView
{
    [self removeCoverView];
}

- (void)MineCodeViewDidClickConfirmBtn:(MineCodeView *)mineCodeView inputCode:(NSString *)inputCode
{
    self.picCode = inputCode;
    if([_forgetOrRegister isEqualToString:@"forget"])
    {
        [self sendChangeCode];
    }
    else if([_forgetOrRegister isEqualToString:@"Register"])
    {
        [self sendRegisterCode];
    }
}

- (void)MineCodeViewDidClickChangeBtn:(MineCodeView *)mineCodeView
{
    [self getPicCode];
}

- (void)MineCodeViewDidClickCodeImgView:(MineCodeView *)mineCodeView
{
    [self getPicCode];
}

#pragma mark - API

- (void)getPicCode
{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/system/sendVerify" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSString *dataStr = result[@"data"];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imgData];
        weakSelf.mineCodeView.codeImgView.image = image;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"获取图形验证码失败" afterHideTime:DELAYTiME];
    }];
}

- (void)sendRegisterCode
{
    WEAKSELF
    if([self.picCode isEqualToString:@""])
    {
        self.picCode = @" ";
    }
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"type":@(1),@"project":ProjectCategory,@"code":self.picCode};
    [ENDNetWorkManager postWithPathUrl:@"/system/sendCode" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [self removeCoverView];
        [self.codeBtn startCountDown];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.coverView Message:@"发送验证码失败" afterHideTime:DELAYTiME];
    }];
}

- (void)sendChangeCode
{
    WEAKSELF
    if([self.picCode isEqualToString:@""])
    {
        self.picCode = @" ";
    }
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"type":@(3),@"project":ProjectCategory,@"code":self.picCode};
    [ENDNetWorkManager postWithPathUrl:@"/system/sendCode" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [self removeCoverView];
        [self.codeBtn startCountDown];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.coverView Message:@"发送验证码失败" afterHideTime:DELAYTiME];
    }];
}

- (void)changePwd
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"newPassword":self.pwdTextF.text,@"confirmPassword":self.rePwdTextF.text,@"code":self.codeTextF.text,@"project":ProjectCategory};
    [ENDNetWorkManager postWithPathUrl:@"/system/resetPassword" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        if(weakSelf.pwdChangedBlock)
        {
            weakSelf.pwdChangedBlock();
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"重置密码失败" afterHideTime:DELAYTiME];
    }];
}

- (void)registerAccount
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"password":self.pwdTextF.text,@"confirmPassword":self.rePwdTextF.text,@"code":self.codeTextF.text,@"type":@1,@"project":ProjectCategory};
    [ENDNetWorkManager postWithPathUrl:@"/system/register" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        //获取用户偏好
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //记录userId
        [userDefault setObject:mineUser.userId forKey:@"userId"];
        [weakSelf dismissToRootViewController];
        if(weakSelf.registerSucceedBlock)
        {
            weakSelf.registerSucceedBlock();
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"注册失败" afterHideTime:DELAYTiME];
    }];
}

@end
