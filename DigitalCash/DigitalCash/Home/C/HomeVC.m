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

#import "HomeCashVC.h"
#import "HomeCalendarVC.h"
#import "HomeBusinessVC.h"
#import "HomeNewsVC.h"

#import "CustomTBC.h"

#import "NetWork.h"

#import "CashModel.h"

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) NSArray *cashImgsArray;
@property (nonatomic, strong) NSArray *quotesArray;
@property (strong , nonatomic) NSArray *newsArray;

@property (nonatomic, strong) NSArray *cashArray;

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
    [self getCashData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
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
    NSInteger cashCount = self.cashArray.count;
    if(cashCount >= 3)
    {
        cashCount = 3;
    }
    NSInteger numbers[4] = {1,cashCount,6,self.newsArray.count};
    return numbers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourBtnCell *fourBtnCell = [tableView dequeueReusableCellWithIdentifier:FourBtnCellID];
    fourBtnCell.cashViewClickedBlock = ^{
        HomeCashVC *cashVC = HomeCashVC.new;
        [self.navigationController pushViewController:cashVC animated:YES];
    };
    fourBtnCell.calendarViewClickedBlock = ^{
        HomeCalendarVC *calendarVC = HomeCalendarVC.new;
        [self.navigationController pushViewController:calendarVC animated:YES];
    };
    fourBtnCell.businessViewClickedBlock = ^{
        HomeBusinessVC *businessVC = HomeBusinessVC.new;
        [self.navigationController pushViewController:businessVC animated:YES];
    };
    fourBtnCell.newsViewClickedBlock = ^{
        HomeNewsVC *newsVC = HomeNewsVC.new;
        [self.navigationController pushViewController:newsVC animated:YES];
    };
    
    CashCell *cashCell = [tableView dequeueReusableCellWithIdentifier:CashCellID];
    QuotesCell *quotesCell = [tableView dequeueReusableCellWithIdentifier:QuotesCellID];
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCellID];
    
    switch (indexPath.section) {
        case 0:
            return fourBtnCell;
            break;
        case 1:
            cashCell.numberImgView.image = [UIImage imageNamed:self.cashImgsArray[indexPath.row]];
            NSInteger cashCount = self.cashArray.count;
            NSInteger cashIndex = indexPath.row;
            if(cashCount < 3)
            {
                cashIndex %= cashCount;
            }
            cashCell.cashModel = self.cashArray[cashIndex];
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

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CashHeaderView *cashHeaderView = [CashHeaderView cashHeaderView];
    QuotesHeaderView *quotesHeaderView = [QuotesHeaderView quotesHeaderView];
    quotesHeaderView.seeAllBtnClickedBlock = ^{
        HomeCashVC *cashVC = HomeCashVC.new;
        [self.navigationController pushViewController:cashVC animated:YES];
    };
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
    NSDictionary *dic = @{@"project":ProjectCategory};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getTalkListByProject" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.newsArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求行业风暴失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getCashData
{
    NSString *URLStr = @"http://data.api51.cn/apis/integration/rank/?market_type=cryptocurrency&limit=13&order_by=desc&fields=prod_name%2Cprod_code%2Clast_px%2Cpx_change%2Cpx_change_rate%2Chigh_px%2Clow_px%2Cupdate_time&token=3f39051e89e1cea0a84da126601763d8";
    
    [NetWork requestGet:URLStr Success:^(NSDictionary * _Nonnull dic) {
        WEAKSELF
        
        NSDictionary *dataD = [dic objectForKey:@"data"];
        
        NSArray *dataArr = NSArray.new;
        
        dataArr = [NSArray arrayWithArray:(NSArray *)dataD[@"candle"]];
        
        if (dataArr.count == 0) {
            [Toast makeText:self.view Message:@"请求货币信息失败" afterHideTime:DELAYTiME];
            return;
        }
        
        NSMutableArray *temp = NSMutableArray.new;
        for (NSArray *cashArr in dataArr) {
            CashModel *cashModel = [CashModel cashWithArray:cashArr];
            [temp addObject:cashModel];
        }
        weakSelf.cashArray = temp;
        
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } ERROR:^(NSError * _Nonnull error) {
//         [Toast makeText:self.view Message:@"网络开小差了，在刷新试试😢" afterHideTime:DELAYTiME];
//        [SVProgressHUD  showWithStatus:@"网络开小差了，在刷新试试😢"];
        
    }];
}

@end
