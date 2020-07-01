//
//  FindRecommendVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindRecommendVC.h"

#import "TalkListModel.h"
#import "TalkModel.h"

#import "FindTalkCell.h"

#import <MJRefresh.h>

@interface FindRecommendVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSMutableArray *talksArray;
@property (nonatomic, strong) TalkListModel *listModel;

@property (assign, nonatomic) NSInteger pageNumber;
@property (nonatomic, assign) BOOL loadMore;


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
    [self setSearchBar];
    [self setBottomView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindTalkCell class]) bundle:nil] forCellReuseIdentifier:FindTalkCellID];
    [self setMJRefresh];
}

-(UIView *)listView{
    return self.view;
}

- (void)setSearchBar
{
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 13.0, *)) {
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
    } else {
        // Fallback on earlier versions
    }
//    _searchBar.searchTextField.textColor = [UIColor colorWithHexString:@"#2A39FB"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.1];
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == _numberOfSections - 1)
//    {
//        NSInteger count = self.allCommentsArray.count;
//        if(count % 2 != 0)
//        {
//            count --;
//        }
//        NSInteger commentsNum1 = indexPath.row % (count / 2) * 2;
//        NSInteger commentsNum2 = commentsNum1 + 1;
//        NSMutableArray *temp = NSMutableArray.new;
//        [temp addObject: self.allCommentsArray[commentsNum1]];
//        [temp addObject: self.allCommentsArray[commentsNum2]];
//
//        CommunityDynamicModel *dynamicModel = self.dynamicsArray[indexPath.row];
//        dynamicModel.commentArray = temp;
//
//        DynamicDetailVC *dynamicDetailVC = DynamicDetailVC.new;
//        dynamicDetailVC.dynamicModel = dynamicModel;
//        dynamicDetailVC.delegate = self;
//        dynamicDetailVC.cellNum = indexPath.row;
//        dynamicDetailVC.rightBarBtnShow = YES;
//        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
//    }
//}

#pragma mark - API

-(void)getTalks{
    WEAKSELF
    NSDictionary *dic = @{
        @"pageNumber":@(_pageNumber),
        @"project":@"bitte"
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

@end
