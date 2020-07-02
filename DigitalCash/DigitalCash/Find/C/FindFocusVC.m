//
//  FindFocusVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FindFocusVC.h"

#import "TalkModel.h"

#import "FindTalkCell.h"
#import "FindRecommendFocusCell.h"

@interface FindFocusVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSArray *talksArray;

@property (assign, nonatomic) NSInteger numberOfSections;

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
    [self getTalks];
}

-(UIView *)listView{
    return self.view;
}

- (void)initialSetUp
{
    [self setSearchBar];
    [self setBottomView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindTalkCell class]) bundle:nil] forCellReuseIdentifier:FindFocusTalkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRecommendFocusCell class]) bundle:nil] forCellReuseIdentifier:FindRecommendFocusCellID];
    
    _numberOfSections = 2;
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
    talkCell.talkModel = self.talksArray[indexPath.row];
    
    FindRecommendFocusCell *focusCell = [tableView dequeueReusableCellWithIdentifier:FindRecommendFocusCellID];
    WEAKSELF
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
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:weakSelf.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求关注说说失败" afterHideTime:DELAYTiME];
    }];
}

@end
