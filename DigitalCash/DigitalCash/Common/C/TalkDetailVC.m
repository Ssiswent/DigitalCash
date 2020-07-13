//
//  TalkDetailVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "TalkDetailVC.h"

#import "DynamicDetailContentCell.h"
#import "DynamicDetailCommentCell.h"

#import "CustomTBC.h"

#import "TalkModel.h"
#import "CommentModel.h"

#import "DynamicDetailHeaderView.h"

#import "FeedbackVC.h"
#import "LoginVC.h"

#import "MineUserModel.h"
#import "UserModel.h"

#import "LoginVC.h"
#import "MineDynamicVC.h"

@interface TalkDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FeedbackVCDelegate, YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *replyTextF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong)NSNumber *userId;

@property (nonatomic, assign) int commitCount;

@property (nonatomic, assign) BOOL isFocus;
@property (strong, nonatomic) NSNumber *followerId;

@property (strong, nonatomic) UserModel *dynamicUser;

@end

@implementation TalkDetailVC

NSString *DynamicDetailContentCellID = @"DynamicDetailContentCell";
NSString *DynamicDetailCommentCellID = @"DynamicDetailCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
    
    [self getUserDefault];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    
    if(_userId != nil)
    {
        [self getUser];
    }
}

- (void)initialSetup
{
    self.title = @"说说详情";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    UIBarButtonItem *shieldButton = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_shield"] style:UIBarButtonItemStylePlain target:self action:@selector(shieldBtnClick)];
    
    UIBarButtonItem *reportButton = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_report"] style:UIBarButtonItemStylePlain target:self action:@selector(reportBtnClick)];
    
    if(_rightBarBtnShow)
    {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:reportButton, shieldButton, nil]];
        
    }
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailContentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCommentCellID];
    
    _replyView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _replyView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    _replyView.layer.shadowOffset = CGSizeMake(0,0);
    _replyView.layer.shadowOpacity = 1;
    _replyView.layer.shadowRadius = 14;
        
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;

    _sendBtn.layer.cornerRadius = 5;
    _sendBtn.layer.masksToBounds = YES;

    [self addClickViewGes];
    
    _commitCount = 2;
}

- (void)shieldBtnClick{
    if(_userId != nil)
    {
        if([self.delegate respondsToSelector:@selector(dynamicDetailVCDidClickShieldBtn:shieldNum:)])
        {
            [self.delegate dynamicDetailVCDidClickShieldBtn:self shieldNum:_cellNum];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)reportBtnClick{
    if(_userId != nil)
    {
        FeedbackVC *feedbackVC = [[FeedbackVC alloc]init];
        feedbackVC.delegate = self;
        feedbackVC.titleStr = @"举报";
        feedbackVC.tag1Str = @"涉黄";
        feedbackVC.tag2Str = @"垃圾内容";
        feedbackVC.talkId = _dynamicModel.talkId;
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
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
    
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addClickViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClicked)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewClicked
{
    [_replyTextF resignFirstResponder];
    
    [self hideReplyView];
}

- (IBAction)sendBtnClicked:(id)sender {
    if(_userId != nil)
    {
        CommentModel *commentModel = CommentModel.new;
        commentModel.content = _replyTextF.text;
        NSDate *todayDate = [NSDate date];
        NSTimeInterval publishTime = [todayDate timeIntervalSince1970];
        commentModel.publishTime = publishTime * 1000;
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        commentModel.user = user;
        NSMutableArray *commentsArray = NSMutableArray.new;
        for (CommentModel *model in _dynamicModel.commentArray) {
            [commentsArray addObject:model];
        }
        [commentsArray addObject:commentModel];
        _dynamicModel.commentArray = commentsArray;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        _commitCount ++;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self hideReplyView];
        [self postComment];
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

- (void)hideReplyView
{
    [_replyTextF resignFirstResponder];
    
    CGRect hideFrame = _replyView.frame;
    hideFrame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        WEAKSELF
        weakSelf.replyView.frame = hideFrame;
    }];
}

- (void)showReplyView
{
    CGRect showFrame = _replyView.frame;
    CGFloat showY = SCREEN_HEIGHT - 69;
    showFrame.origin.y = showY;
    [UIView animateWithDuration:0.5 animations:^{
        WEAKSELF
        weakSelf.replyView.frame = showFrame;
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

#pragma mark - FeedbackVCDelegate
- (void)FeedbackVCDidSuccessFeedback:(FeedbackVC *)feedbackVC
{
    [Toast makeText:self.view Message:@"举报成功" afterHideTime:DELAYTiME];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return _dynamicModel.commentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DynamicDetailContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailContentCellID];
        
        contentCell.userId = _userId;
        contentCell.dynamicModel = _dynamicModel;
        contentCell.commitCount = _commitCount;
        
        WEAKSELF
        
        //关注
        UserModel *follower = _dynamicModel.user;
        
        contentCell.focusBtnClickedBlock = ^(BOOL isFocus) {
            if(weakSelf.userId != nil)
            {
                weakSelf.followerId = follower.userId;
                weakSelf.isFocus = isFocus;
                [weakSelf focusUser];
            }
            else
            {
                LoginVC *loginVC = [LoginVC new];
                loginVC.loginVCDidGetUserBlock = ^{
                    [self getUserDefault];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
                };
                [self presentViewController:loginVC animated:YES completion:nil];
                [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
            }
        };
        
        contentCell.avatarViewClickedBlock = ^{
            weakSelf.dynamicUser = follower;
            [weakSelf getTalksCount];
        };
        
        
        contentCell.commitBtnClickedBlock = ^{
            [weakSelf showReplyView];
            [weakSelf.replyTextF becomeFirstResponder];
        };
        return contentCell;
    }
    else
    {
        NSInteger commentNum = indexPath.row % 2;
        DynamicDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailCommentCellID];
        if(indexPath.row <= 1)
        {
            commentCell.commentModel = _dynamicModel.commentArray[commentNum];
        }
        else
        {
            commentCell.commentModel = _dynamicModel.commentArray[indexPath.row];
        }
        return commentCell;
    }
}

#pragma mark - TableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    //下滑
    if (translation.y>0)
    {
        [self showReplyView];
    }
    //上滑
    else if(translation.y<0)
    {
        [self hideReplyView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        DynamicDetailHeaderView *detailHeaderView = [DynamicDetailHeaderView dynamicDetailHeaderView];
        return detailHeaderView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.001;
    }
    else
    {
        return 44;
    }
}

// MARK: API

- (void)postComment{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"talkId":_dynamicModel.talkId,
        @"content":_replyTextF.text
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/commentTalk" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [Toast makeText:weakSelf.view Message:@"评论成功" afterHideTime:DELAYTiME];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"评论失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:result[@"data"] error:&error];
        mineUser.nickName = user.nickName;
        mineUser.head = user.head;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
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
        @"followerId":_followerId,
        @"isFollow":isFocus
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/follow/follow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"关注失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getTalksCount{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_dynamicUser.userId
    };
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getTalkCount" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        MineDynamicVC *userDynamicVC = MineDynamicVC.new;
        userDynamicVC.user = weakSelf.dynamicUser;
        userDynamicVC.talksCount = result[@"data"];
        [self.navigationController pushViewController:userDynamicVC animated:YES];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"获取说说数失败" afterHideTime:DELAYTiME];
    }];
}

@end
