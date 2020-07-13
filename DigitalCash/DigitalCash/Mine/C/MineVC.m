//
//  MineVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "MineVC.h"

#import "MineUserModel.h"
#import "UserModel.h"
#import "CheckInModel.h"

#import "LoginVC.h"
#import "MineDynamicVC.h"
#import "MineFocusAndFansVC.h"
#import "CheckInVC.h"
#import "AccountSafeVC.h"
#import "FeedbackVC.h"
#import "AboutVC.h"

#import "CustomTBC.h"

#import "MineLogoutView.h"

#import "MineMessagesVC.h"


@interface MineVC ()<YPNavigationBarConfigureStyle, MineLogoutViewDelegate, FeedbackVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet UIView *fansView;
@property (weak, nonatomic) IBOutlet UIView *dynamicsView;
@property (weak, nonatomic) IBOutlet UILabel *focusCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicsCountLabel;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLabelTop;

@property (nonatomic, strong)NSNumber *userId;

@property (nonatomic, assign)BOOL hasUserId;

@property (strong , nonatomic) NSArray *checkInList;
@property (strong , nonatomic) NSMutableArray <NSDate *> *datesArray;
@property (nonatomic, assign) BOOL hasCheckedIn;
@property (copy,nonatomic) NSString *dateStr;

@property (weak, nonatomic) UIView *coverView;
@property (weak, nonatomic) MineLogoutView *mineLogoutView;

@end

@implementation MineVC

- (NSMutableArray<NSDate *> *)datesArray
{
    if(_datesArray == nil)
    {
        _datesArray = NSMutableArray.new;
    }
    return _datesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
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
    
    if(kIsIPhoneX_Series)
    {
        _moreLabelTop.constant = 200;
    }
    
    [self setAttributedStr:_moreLabel];
    [self setAttributedStr:_accountLabel];
    [self setAttributedStr:_helpLabel];
    [self setAttributedStr:_aboutLabel];
    [self setAttributedStr:_logoutLabel];

    [self addGestures];
}

- (void)setAttributedStr:(UILabel *)label
{
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    // 改变文字间距
    [attributedText setAttributes:@{NSKernAttributeName:@3} range:NSMakeRange(0, 4)];
    label.attributedText = attributedText;
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    if(userId != nil)
    {
        _userId = userId;
        _hasUserId = YES;
        [self getUser];
        [self getSignList];
        
        _logoutView.hidden = NO;
    }
    else
    {
        [self clearUser];
    }
}

- (void)clearUser
{
    _hasUserId = NO;
    
    self.focusCountLabel.text = @"0";
    self.fansCountLabel.text = @"0";
    self.dynamicsCountLabel.text = @"0";
    self.avatarImgView.image = [UIImage imageNamed:@"avatar_white"];
    self.nameLabel.text = @"您还没有登录哦~";
    self.signatureLabel.text = @"请点击头像登录";
    
    _logoutView.hidden = YES;
}

- (IBAction)alertBtnClicked:(id)sender {
    if(_hasUserId)
    {
        MineMessagesVC *messagesVC = MineMessagesVC.new;
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        //        loginVC.delegate = self;
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (IBAction)checkInBtnClicked:(id)sender {
    if(_hasUserId)
    {
        CheckInVC *checkInVC = CheckInVC.new;
        checkInVC.datesArray = _datesArray;
        checkInVC.checkInList = _checkInList;
        checkInVC.hasCheckedIn = _hasCheckedIn;
        checkInVC.dateStr = _dateStr;
        [self.navigationController pushViewController:checkInVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        //        loginVC.delegate = self;
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addGestures
{
    [self addClickAccountViewGes];
    [self addClickAvatartViewGes];
    [self addClickFocusViewGes];
    [self addClickFansViewGes];
    [self addClickDynamicsViewGes];
    [self addClickLogoutViewGes];
    [self addClickHelpViewGes];
    [self addClickAboutViewGes];
}

- (void)addClickAvatartViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatartViewClicked)];
    [_avatarView addGestureRecognizer:tap];
}

- (void)addClickDynamicsViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatartViewClicked)];
    [_dynamicsView addGestureRecognizer:tap];
}

- (void)avatartViewClicked
{
    if(_hasUserId)
    {
        MineDynamicVC *mineDynamicVC = MineDynamicVC.new;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        if(mineUser.userId != nil)
        {
            mineDynamicVC.user = mineUser;
            mineDynamicVC.talksCount = mineUser.talkCount;
            mineDynamicVC.isMineDynamic = YES;
            [self.navigationController pushViewController:mineDynamicVC animated:YES];
        }
        else
        {
            [self getUser];
        }
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        //        loginVC.delegate = self;
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickAccountViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountViewClicked)];
    [_accountView addGestureRecognizer:tap];
}

- (void)accountViewClicked
{
    if(_hasUserId)
    {
        AccountSafeVC *accountSafeVC = AccountSafeVC.new;
        WEAKSELF
        accountSafeVC.accountLogOffBlock = ^{
            //清空userId
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:nil forKey:@"userId"];
            [self clearUser];
            [Toast makeText:weakSelf.view Message:@"注销成功" afterHideTime:DELAYTiME];
        };
        [self.navigationController pushViewController:accountSafeVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickHelpViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpViewClicked)];
    [_helpView addGestureRecognizer:tap];
}

- (void)helpViewClicked
{
    if(_hasUserId)
    {
        FeedbackVC *feedbackVC = FeedbackVC.new;
        feedbackVC.titleStr = @"帮助反馈";
        feedbackVC.tag1Str = @"功能建议";
        feedbackVC.tag2Str = @"bug";
        feedbackVC.delegate = self;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickAboutViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutViewClicked)];
    [_aboutView addGestureRecognizer:tap];
}

- (void)aboutViewClicked
{
    AboutVC *aboutVC = AboutVC.new;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)addClickFocusViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusViewClicked)];
    [_focusView addGestureRecognizer:tap];
}

- (void)focusViewClicked
{
    if(_hasUserId)
    {
        MineFocusAndFansVC *focusAndFansVC = [[MineFocusAndFansVC alloc] init];
        focusAndFansVC.titleStr = @"关注";
        focusAndFansVC.focusOrFans = @"focus";
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        focusAndFansVC.user = user;
        [self.navigationController pushViewController:focusAndFansVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickFansViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fansViewClicked)];
    [_fansView addGestureRecognizer:tap];
}

- (void)fansViewClicked
{
    if(_hasUserId)
    {
        MineFocusAndFansVC *focusAndFansVC = [[MineFocusAndFansVC alloc] init];
        focusAndFansVC.titleStr = @"粉丝";
        focusAndFansVC.focusOrFans = @"Fans";
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        focusAndFansVC.user = user;
        [self.navigationController pushViewController:focusAndFansVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickLogoutViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutViewClicked)];
    [_logoutView addGestureRecognizer:tap];
}

- (void)logoutViewClicked
{
    MineLogoutView *mineLogoutView = [[NSBundle mainBundle]loadNibNamed:@"MineLogoutView" owner:nil options:nil].firstObject;
    mineLogoutView.delegate = self;
    self.mineLogoutView = mineLogoutView;
    [self addCoverView];
}

#pragma mark - MineLogoutViewDelegate

- (void)mineLogoutViewDidClickCancelBtn:(MineLogoutView *)mineLogoutView
{
    [self removeCoverView];
}

- (void)mineLogoutViewDidClickConfirmBtn:(MineLogoutView *)mineLogoutView
{
    //清空userId
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"userId"];
    [self clearUser];
    [self removeCoverView];
}

#pragma mark - FeedbackVCDelegate
- (void)FeedbackVCDidSuccessFeedback:(FeedbackVC *)feedbackVC
{
    [Toast makeText:self.view Message:@"反馈成功" afterHideTime:DELAYTiME];
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
    return YPNavigationBarBackgroundStyleTransparent | YPNavigationBarStyleBlack;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

#pragma mark - API

-(void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
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
        
        weakSelf.focusCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.followCount.intValue];
        weakSelf.fansCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.fansCount.intValue];
        [weakSelf.avatarImgView sd_setImageWithURL:[NSURL URLWithString:mineUser.head]
                                  placeholderImage:[UIImage imageNamed:@"avatar_white"]];
        weakSelf.nameLabel.text = mineUser.nickName;
        weakSelf.signatureLabel.text = mineUser.signature;
        weakSelf.dynamicsCountLabel.text = mineUser.talkCount.stringValue;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getSignList
{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager getWithPathUrl:@"/user/sign/getSignList" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        [weakSelf.datesArray removeAllObjects];
        weakSelf.hasCheckedIn = NO;
        weakSelf.checkInList = [MTLJSONAdapter modelsOfClass:[CheckInModel class] fromJSONArray:result[@"data"] error:&error];
        for (CheckInModel *checkInModel in weakSelf.checkInList) {
            NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970: checkInModel.time / 1000];
            [weakSelf.datesArray addObject:checkInDate];
        }
        CheckInModel *lastModel = weakSelf.checkInList.lastObject;
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970: lastModel.time / 1000];
        if([self isSameDay:lastDate date2:[NSDate date]])
        {
            weakSelf.hasCheckedIn = YES;
            NSNumber *dateNum = lastModel.continueTimes;
            NSInteger dateInt = dateNum.integerValue;
            weakSelf.dateStr = [NSString stringWithFormat:@"已签到%ld天，继续加油!",dateInt];
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求签到记录失败" afterHideTime:DELAYTiME];
    }];
}

// 判断是否是同一天
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

@end
