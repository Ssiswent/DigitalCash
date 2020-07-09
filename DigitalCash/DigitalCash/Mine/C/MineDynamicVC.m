//
//  MineDynamicVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineDynamicVC.h"


#import "TalkModel.h"
#import "UserModel.h"

#import "MineTalkCell.h"
#import "MineTalkSortCell.h"

#import "CustomTBC.h"

#import "UIImage+Alpha.h"

#import "MineEditVC.h"

#import "CommentModel.h"

#import "TalkDetailVC.h"

#import "EmptyView.h"

#import "LoginVC.h"

@interface MineDynamicVC ()<UITableViewDataSource, UITableViewDelegate, YPNavigationBarConfigureStyle, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (weak, nonatomic) IBOutlet UIButton *sortNewBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortDefaultBtn;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicsCountLabel;

@property (nonatomic, strong)NSNumber *userId;

@property (strong , nonatomic) NSArray *talksArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;

@property (assign, nonatomic) CGFloat alpha;

@property (assign, nonatomic) CGFloat oriH;
@property (assign, nonatomic) CGFloat oriOffsetY;
@property (assign, nonatomic) CGFloat navH;

@property (weak, nonatomic) UIImage *navImg;

@property (strong , nonatomic) NSArray *allCommentsArray;

@property (nonatomic, assign) BOOL isFocus;

@end

@implementation MineDynamicVC

NSString *MineTalkCellID = @"MineTalkCell";
NSString *MineTalkSortCellID = @"MineTalkSortCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
    [self getComments];
    [self getUserDefault];
    [self getDynamics];
    _sortDefaultBtn.selected = YES;
    
    _focusBtn.selected = NO;
    
    if(_userId != nil)
    {
        [self getFocusUser];
    }
}

- (void)initialSetup
{
    //屏幕适配
    if(kIsIPhoneX_Series)
    {
        _oriH = 180;
        _oriOffsetY = -236;
        _navH = 88;
    }
    else
    {
        _oriH = 155;
        _oriOffsetY = -211;
        _navH = 64;
    }
    
    _avatarImgView.layer.cornerRadius = 25;
    _avatarImgView.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineTalkCell class]) bundle:nil]forCellReuseIdentifier:MineTalkCellID];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineTalkSortCell class]) bundle:nil]forCellReuseIdentifier:MineTalkSortCellID];
    
    [self setContentInset];
        
    [self setUser];
    
    if([_talksCount isEqualToNumber:@0])
    {
        EmptyView *emptyView = [EmptyView emptyView];
        [self.dynamicTableView removeFromSuperview];
        [self.view addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view).offset(100);
            make.size.mas_equalTo(CGSizeMake(153, 200));
        }];
    }
    
    if(_isMineDynamic)
    {
        _focusBtn.hidden = YES;
        _editBtn.hidden = NO;
    }
    else
    {
        _focusBtn.hidden = NO;
        _editBtn.hidden = YES;
    }
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUser{
    self.focusCountLabel.text = [NSString stringWithFormat:@"%d",_user.followCount.intValue];
    self.fansCountLabel.text = [NSString stringWithFormat:@"%d",_user.fansCount.intValue];
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_user.head]
                              placeholderImage:[UIImage imageNamed:@"avatar_white"]];
    self.nameLabel.text = _user.nickName;
    self.signatureLabel.text = _user.signature;
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (IBAction)focusBtnClicked:(id)sender {
    _isFocus = !_focusBtn.selected;
    if(_userId != nil)
    {
        [self focusUser];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [self getFocusUser];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (IBAction)editBtnClicked:(id)sender {
    MineEditVC *mineEditVC = MineEditVC.new;
    mineEditVC.user = _user;
    [self.navigationController pushViewController:mineEditVC animated:YES];
}

- (IBAction)sortNewBtnClicked:(id)sender {
    _sortDefaultBtn.selected = NO;
    _sortNewBtn.selected = YES;
    [self getNewDynamics];
}

- (IBAction)sortDefaultBtnClicked:(id)sender {
    _sortDefaultBtn.selected = YES;
    _sortNewBtn.selected = NO;
    [self getDynamics];
}

#pragma mark - setNavFade

- (void)setContentInset
{
    if (@available(iOS 11.0, *)) {
        self.dynamicTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dynamicTableView.contentInset = UIEdgeInsetsMake(-_oriOffsetY, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y - _oriOffsetY;
    CGFloat h = _oriH - offset;
    if (h <= _navH) {
        h = _navH;
    }
    self.headerViewHeight.constant = h;
    
    CGFloat alpha = offset * 1 / (_oriH - _navH);
    if (alpha >= 0.99) {
        alpha = 0.99;
    }
    _alpha = alpha;
    
    UIImage *originImage = [UIImage imageNamed:@"bg_nav"];
    UIImage *alphaImg =  [originImage imageByApplyingAlpha:alpha];
    _navImg = alphaImg;
    
    if (alpha <= 1) {
        [self yp_refreshNavigationBarStyle];
    }
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    if(_alpha == 0)
    {
        return YPNavigationBarBackgroundStyleTransparent | YPNavigationBarStyleBlack;
    }
    else
    {
        return YPNavigationBarBackgroundStyleTranslucent | YPNavigationBarBackgroundStyleImage | YPNavigationBarStyleBlack;
    }
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIImage *)yp_navigationBackgroundImageWithIdentifier:(NSString *__autoreleasing *)identifier
{
    return _navImg;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.talksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTalkCell *talkCell = [tableView dequeueReusableCellWithIdentifier:MineTalkCellID];
    talkCell.talkModel = self.talksArray[indexPath.row];
    return talkCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.allCommentsArray.count;
    if(count % 2 != 0)
    {
        count --;
    }
    NSInteger commentsNum1 = indexPath.row % (count / 2) * 2;
    NSInteger commentsNum2 = commentsNum1 + 1;
    NSMutableArray *temp = NSMutableArray.new;
    [temp addObject: self.allCommentsArray[commentsNum1]];
    [temp addObject: self.allCommentsArray[commentsNum2]];
    
    TalkModel *talkModel = self.talksArray[indexPath.row];
    talkModel.commentArray = temp;
    
    TalkDetailVC *talkDetailVC = TalkDetailVC.new;
    talkDetailVC.dynamicModel = talkModel;
    [self.navigationController pushViewController:talkDetailVC animated:YES];
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderBy":@"publishTime",@"userId":_user.userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/getTalkList/155" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.talksArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        weakSelf.dynamicsCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.talksArray.count];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户说说失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getNewDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderByDesc":@"publishTime",@"userId":_user.userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/getTalkList/155" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.talksArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        weakSelf.dynamicsCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.talksArray.count];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户说说失败" afterHideTime:DELAYTiME];
    }];
}

#pragma mark - API

- (void)getComments{
    WEAKSELF
    NSDictionary *dic = @{@"userId":@4161};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getDiscussByUserId" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.allCommentsArray = [MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求评论失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getFocusUser
{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"followerId":_user.userId
    };
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/isFollow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSNumber *data = result[@"data"];
        
        BOOL isFocus = NO;
        if([data isEqualToNumber:@0])
        {
            isFocus = NO;
        }
        else if([data isEqualToNumber:@1])
        {
            isFocus = YES;
        }
        
        weakSelf.focusBtn.selected = isFocus;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"获取关注失败" afterHideTime:DELAYTiME];
    }];
}

- (void)focusUser{
    WEAKSELF
    NSString *isFocus;
    if(weakSelf.isFocus)
    {
        isFocus = @"true";
    }
    else
    {
        isFocus = @"false";
    }
    
    NSDictionary *dic = @{
        @"userId":_userId,
        @"followerId":_user.userId,
        @"isFollow":isFocus
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/follow/follow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [self getFocusUser];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"关注失败" afterHideTime:DELAYTiME];
    }];
}

@end
