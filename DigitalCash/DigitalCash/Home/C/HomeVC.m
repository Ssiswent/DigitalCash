//
//  HomeVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "HomeVC.h"

#import "TalkModel.h"
#import "HomeQuotesModel.h"

#import "FourBtnCell.h"
#import "CashCell.h"
#import "QuotesCell.h"
#import "NewsCell.h"

#import "TableHeaderView.h"
#import "CashHeaderView.h"
#import "QuotesHeaderView.h"
#import "NewsHeaderView.h"


@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate,YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *cashImgsArray;
@property (nonatomic, strong) NSArray *quotesArray;
@property (strong , nonatomic) NSArray *newsArray;

@end

@implementation HomeVC

- (NSArray *)cashImgsArray
{
    if(_cashImgsArray == nil)
    {
        NSArray *temp = [NSArray arrayWithObjects:@"pic_first_home", @"pic_second_home", @"pic_third_home", nil];
        _cashImgsArray = temp;
    }
    return _cashImgsArray;
}

- (NSArray *)quotesArray
{
    if(_quotesArray == nil)
    {
        HomeQuotesModel *quotesModel0 = HomeQuotesModel.new;
        quotesModel0.leftImgStr = @"ic_BTC";
        quotesModel0.nameStr = @"BTC";
        
        HomeQuotesModel *quotesModel1 = HomeQuotesModel.new;
        quotesModel1.leftImgStr = @"ic_ETH";
        quotesModel1.nameStr = @"ETH";
        
        HomeQuotesModel *quotesModel2 = HomeQuotesModel.new;
        quotesModel2.leftImgStr = @"ic_EOS";
        quotesModel2.nameStr = @"EOS";
        
        HomeQuotesModel *quotesModel3 = HomeQuotesModel.new;
        quotesModel3.leftImgStr = @"ic_TRX";
        quotesModel3.nameStr = @"TRX";
        
        HomeQuotesModel *quotesModel4 = HomeQuotesModel.new;
        quotesModel4.leftImgStr = @"ic_ZSC";
        quotesModel4.nameStr = @"ZSC";
        
        HomeQuotesModel *quotesModel5 = HomeQuotesModel.new;
        quotesModel5.leftImgStr = @"ic_GTC";
        quotesModel5.nameStr = @"GTC";
        
        NSMutableArray *temp = NSMutableArray.new;
        [temp addObject:quotesModel0];
        [temp addObject:quotesModel1];
        [temp addObject:quotesModel2];
        [temp addObject:quotesModel3];
        [temp addObject:quotesModel4];
        [temp addObject:quotesModel5];
        
        _quotesArray = temp;
    }
    return _quotesArray;
}

NSString *FourBtnCellID = @"FourBtnCell";
NSString *CashCellID = @"CashCell";
NSString *QuotesCellID = @"QuotesCell";
NSString *NewsCellID = @"NewsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTalks];
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

- (void)initialSetUp
{
    [self setSearchBar];
    
    TableHeaderView *headerView = [[TableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    [_tableView setTableHeaderView:headerView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FourBtnCell class]) bundle:nil] forCellReuseIdentifier:FourBtnCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CashCell class]) bundle:nil] forCellReuseIdentifier:CashCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuotesCell class]) bundle:nil] forCellReuseIdentifier:QuotesCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCellID];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger numbers[4] = {1,3,6,self.newsArray.count};
    return numbers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourBtnCell *fourBtnCell = [tableView dequeueReusableCellWithIdentifier:FourBtnCellID];
    CashCell *cashCell = [tableView dequeueReusableCellWithIdentifier:CashCellID];
    QuotesCell *quotesCell = [tableView dequeueReusableCellWithIdentifier:QuotesCellID];
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCellID];
    
    switch (indexPath.section) {
        case 0:
            return fourBtnCell;
            break;
        case 1:
            cashCell.numberImgView.image = [UIImage imageNamed:self.cashImgsArray[indexPath.row]];
            return cashCell;
            break;
        case 2:
            quotesCell.quotesModel = self.quotesArray[indexPath.row];
            quotesCell.index = indexPath.row;
            return quotesCell;
            break;
        default:
            newsCell.talkModel = self.newsArray[indexPath.row];
            newsCell.index = indexPath.row;
            return newsCell;
            break;
    }
}

#pragma mark - yp_navigtionBarConfiguration
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CashHeaderView *cashHeaderView = [CashHeaderView cashHeaderView];
    QuotesHeaderView *quotesHeaderView = [QuotesHeaderView quotesHeaderView];
    NewsHeaderView *newsHeaderView = [NewsHeaderView newsHeaderView];
    switch (section) {
        case 1:
            return cashHeaderView;
            break;
        case 2:
            return quotesHeaderView;
            break;
        case 3:
            return newsHeaderView;
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 36;
            break;
        case 2:
            return 36;
            break;
        case 3:
            return 36;
            break;
        default:
            return 0.001;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - API

- (void)getTalks{
    WEAKSELF
    NSDictionary *dic = @{@"project":@"bitte"};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getTalkListByProject" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.newsArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求行业风暴失败" afterHideTime:DELAYTiME];
    }];
}

@end