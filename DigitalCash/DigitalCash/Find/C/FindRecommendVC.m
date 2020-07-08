//
//  FindRecommendVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindRecommendVC.h"

#import "TalkListModel.h"
#import "TalkModel.h"
#import "CommentModel.h"

#import "FindTalkCell.h"

#import "TalkDetailVC.h"

#import <MJRefresh.h>

#import "CustomTBC.h"

@interface FindRecommendVC ()<UITableViewDataSource, UITableViewDelegate, TalkDetailVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSMutableArray *talksArray;
@property (nonatomic, strong) TalkListModel *listModel;

@property (assign, nonatomic) NSInteger pageNumber;
@property (nonatomic, assign) BOOL loadMore;

@property (strong, nonatomic) NSNumber *shieldId;
@property (strong, nonatomic) NSNumber *userId;

@property (strong , nonatomic) NSArray *allCommentsArray;

@end

@implementation FindRecommendVC

- (NSMutableArray *)talksArray
{
    if(_talksArray == nil)
    {
        NSMutableArray *temp = NSMutableArray.new;
        _talksArray = temp;
    }
    return _talksArray;
}

NSString *FindTalkCellID = @"FindTalkCell";

- (void)viewDidLoad {
    [self setBottomView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindTalkCell class]) bundle:nil] forCellReuseIdentifier:FindTalkCellID];
    [self setMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
    [self getComments];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)setMJRefresh
{
    //下拉刷新
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WEAKSELF
        weakSelf.loadMore = NO;
        weakSelf.pageNumber = 1;
        //        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf getTalks];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.mj_header.automaticallyChangeAlpha = NO;
    
    // 上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WEAKSELF
        weakSelf.loadMore = YES;
        weakSelf.pageNumber ++;
        //        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf getTalks];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)setBottomView
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:62/255.0 green:27/255.0 blue:114/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 37;
}

#pragma mark - DynamicDetailVCDelegate

- (void)dynamicDetailVCDidClickShieldBtn:(TalkDetailVC *)dynamicDetailVC shieldNum:(NSInteger)shieldNum
{
    TalkModel *blocTalkModel = self.talksArray[shieldNum];
    _shieldId = blocTalkModel.talkId;
    if(_userId != nil)
    {
        [self blockDynamic];
    }
    [self.talksArray removeObjectAtIndex:shieldNum];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:shieldNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.talksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindTalkCell *talkCell = [tableView dequeueReusableCellWithIdentifier:FindTalkCellID];
    talkCell.talkModel = self.talksArray[indexPath.row];
    return talkCell;
}

#pragma mark - TableViewDelegate

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
    talkDetailVC.delegate = self;
    talkDetailVC.cellNum = indexPath.row;
    talkDetailVC.rightBarBtnShow = YES;
    [self.navigationController pushViewController:talkDetailVC animated:YES];
}

#pragma mark - API

-(void)getTalks{
    WEAKSELF
    NSDictionary *dic = @{
        @"pageNumber":@(_pageNumber),
        @"project":ProjectCategory
    };
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.listModel = [MTLJSONAdapter modelOfClass:[TalkListModel class] fromJSONDictionary:result[@"data"] error:&error];
        if (!weakSelf.loadMore) {
            [weakSelf.talksArray removeAllObjects];
        }
        [weakSelf.talksArray addObjectsFromArray:weakSelf.listModel.talksArray];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (!weakSelf.loadMore) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else
        {
            if (weakSelf.listModel.hasMore)
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        if (weakSelf.loadMore) {
            if (weakSelf.pageNumber >2) {
                weakSelf.pageNumber --;
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [Toast makeText:weakSelf.view Message:@"请求推荐说说失败" afterHideTime:DELAYTiME];
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

- (void)blockDynamic{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"data":_shieldId,
        @"type":@2
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/block" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"屏蔽失败" afterHideTime:DELAYTiME];
    }];
}

@end
