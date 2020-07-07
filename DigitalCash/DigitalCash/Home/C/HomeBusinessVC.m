//
//  HomeBusinessVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import "HomeBusinessVC.h"

#import "TalkModel.h"

#import "NewsCell.h"

#import "CustomTBC.h"

@interface HomeBusinessVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic) NSArray *newsArray;

@end

@implementation HomeBusinessVC

NSString *NewsCellID1 = @"NewsCell1";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTalks];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = @"行业风暴";
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCellID1];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCellID1];
    newsCell.talkModel = self.newsArray[indexPath.row];
    newsCell.index = indexPath.row;
    return newsCell;
}

#pragma mark - API

- (void)getTalks{
    WEAKSELF
    NSDictionary *dic = @{@"project":ProjectCategory};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getTalkListByProject" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.newsArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求行业风暴失败" afterHideTime:DELAYTiME];
    }];
}

@end
