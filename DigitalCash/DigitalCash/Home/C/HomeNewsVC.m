//
//  HomeNewsVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import "HomeNewsVC.h"

#import "HomeNewsModel.h"

#import "HomeFastNewsCell.h"

#import "HomeNewsHeaderView.h"

#import "CustomTBC.h"

@interface HomeNewsVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic) NSArray *fastNewsArray;

@end

@implementation HomeNewsVC

NSString *HomeFastNewsCellID = @"HomeFastNewsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
    [self getTopics];
}

- (void)initialSetUp
{
    self.title = @"快讯热点";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#272727"];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back_black"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeFastNewsCell class]) bundle:nil] forCellReuseIdentifier:HomeFastNewsCellID];
    
    HomeNewsHeaderView *headerView = [HomeNewsHeaderView homeNewsHeaderView];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [_tableView setTableHeaderView:headerView];
    headerView.autoresizingMask = UIViewAutoresizingNone;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fastNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFastNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:HomeFastNewsCellID];
    newsCell.fastNewsModel = self.fastNewsArray[indexPath.row];
    if(indexPath.row == 0)
    {
        newsCell.topLineView.hidden = YES;
    }
    return newsCell;
}

#pragma mark - API

- (void)getTopics{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceAffairs" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.fastNewsArray = [MTLJSONAdapter modelsOfClass:[HomeNewsModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求快讯失败" afterHideTime:DELAYTiME];
    }];
}

@end
