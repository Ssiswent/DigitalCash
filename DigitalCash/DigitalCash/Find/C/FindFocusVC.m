//
//  FindFocusVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindFocusVC.h"

#import "TalkModel.h"
#import "CommentModel.h"
#import "UserModel.h"

#import "FindTalkCell.h"
#import "FindRecommendFocusCell.h"

#import "TalkDetailVC.h"
#import "LoginVC.h"
#import "MineDynamicVC.h"

#import "CustomTBC.h"

@interface FindFocusVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSArray *talksArray;

@property (assign, nonatomic) NSInteger numberOfSections;

@property (strong , nonatomic) NSArray *allCommentsArray;

@property (strong, nonatomic) NSNumber *userId;
@property (nonatomic, assign) BOOL isFocus;
@property (strong, nonatomic) NSNumber *followerId;
@property (assign, nonatomic) NSInteger focusIndex;

@property (strong, nonatomic) UserModel *dynamicUser;

@end

@implementation FindFocusVC

NSString *FindFocusTalkCellID = @"FindFocusTalkCell";
NSString *FindRecommendFocusCellID = @"FindRecommendFocusCell";

- (void)viewDidLoad {
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
    [self getTalks];
    [self getComments];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}


-(UIView *)listView{
    return self.view;
}

- (void)initialSetUp
{
    [self setBottomView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindTalkCell class]) bundle:nil] forCellReuseIdentifier:FindFocusTalkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRecommendFocusCell class]) bundle:nil] forCellReuseIdentifier:FindRecommendFocusCellID];
    
    _numberOfSections = 2;
}

- (void)setBottomView
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:62/255.0 green:27/255.0 blue:114/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 37;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_numberOfSections == 2)
    {
        NSInteger numbers[2] = {1,self.talksArray.count};
        return numbers[section];
    }
    else
    {
        return self.talksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindTalkCell *talkCell = [tableView dequeueReusableCellWithIdentifier:FindFocusTalkCellID];
    talkCell.userId = _userId;
    
    WEAKSELF
    if(self.talksArray.count > 0)
    {
        TalkModel *talkModel = self.talksArray[indexPath.row];
        talkCell.talkModel = talkModel;
        
        //关注
        UserModel *follower = talkModel.user;
        
        
        talkCell.focusBtnClickedBlock = ^(BOOL isFocus) {
            
            if(weakSelf.userId != nil)
            {
                weakSelf.followerId = follower.userId;
                weakSelf.focusIndex = indexPath.row;
                weakSelf.isFocus = isFocus;
                [weakSelf focusUser];
            }
            else
            {
                LoginVC *loginVC = [LoginVC new];
                loginVC.loginVCDidGetUserBlock = ^{
                    [self getUserDefault];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:weakSelf.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationNone];
                    [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
                };
                [self presentViewController:loginVC animated:YES completion:nil];
                [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
            }
        };
        
        talkCell.avatarViewClickedBlock = ^{
            weakSelf.dynamicUser = follower;
            [weakSelf getTalksCount];
        };
    }
    
    FindRecommendFocusCell *focusCell = [tableView dequeueReusableCellWithIdentifier:FindRecommendFocusCellID];
//    focusCell.userId = _userId;
    focusCell.closeBlock = ^{
        weakSelf.numberOfSections = 1;
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

    if(_numberOfSections == 2)
    {
        if(indexPath.section == 0)
        {
            return focusCell;
        }
        else
        {
            return talkCell;
        }
    }
    else
    {
        return talkCell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == _numberOfSections - 1)
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
}

#pragma mark - API

- (void)getTalks{
    WEAKSELF
    NSDictionary *dic = @{
        @"pageNumber":@5,
        @"project":ProjectCategory
    };
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.talksArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.tableView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求关注说说失败" afterHideTime:DELAYTiME];
    }];
}

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
        NSInteger focusIndex  = weakSelf.focusIndex;
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:focusIndex inSection:weakSelf.numberOfSections - 1]];
        [weakSelf.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
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
