//
//  MineDynamicVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineDynamicVC.h"


#import "TalkModel.h"
#import "MineUserModel.h"

#import "MineTalkCell.h"
#import "MineTalkSortCell.h"

#import "CustomTBC.h"

#import "UIImage+Alpha.h"

@interface MineDynamicVC ()<UITableViewDataSource, UITableViewDelegate, YPNavigationBarConfigureStyle, UIGestureRecognizerDelegate>

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
    [self getUserDefault];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    [self getDynamics];
    [self getUser];
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
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderBy":@"publishTime",@"userId":@155};
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
    NSDictionary *dic = @{@"_orderByDesc":@"publishTime",@"userId":@155};
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

- (void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        weakSelf.focusCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.followCount.intValue];
        weakSelf.fansCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.fansCount.intValue];
        [weakSelf.avatarImgView sd_setImageWithURL:[NSURL URLWithString:mineUser.head]
                                  placeholderImage:[UIImage imageNamed:@"avatar_white"]];
        weakSelf.nameLabel.text = mineUser.nickName;
        weakSelf.signatureLabel.text = mineUser.signature;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

@end
