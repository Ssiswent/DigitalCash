//
//  HomeCalendarVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeCalendarVC.h"

#import "CustomTBC.h"

#import "HomeCalendarCell.h"

#import <FSCalendar.h>

#import "FinanceCalenderModel.h"

@interface HomeCalendarVC ()<FSCalendarDataSource, FSCalendarDelegate, YPNavigationBarConfigureStyle, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarBgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarWidth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *financeCalenderArray;

@end

@implementation HomeCalendarVC

NSString *HomeCalendarCellID = @"HomeCalendarCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
    
    [self getFinanceCalender];
}

- (void)initialSetUp
{
    self.calendar.backgroundColor = [UIColor clearColor];
    self.calendar.scope = FSCalendarScopeWeek;
    [self.calendar selectDate:[NSDate date]];
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesUpperCase;
    
    _calendarWidth.constant = SCREEN_WIDTH;
    _dateLabel.text = [self getTimeToTimeStr:[NSDate date]];
    
    self.title = @"日历数据";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCalendarCell class]) bundle:nil] forCellReuseIdentifier:HomeCalendarCellID];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.financeCalenderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCalendarCell *calendarCell = [tableView dequeueReusableCellWithIdentifier:HomeCalendarCellID];
    calendarCell.financeCalenderModel = self.financeCalenderArray[indexPath.row];
    return calendarCell;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    _dateLabel.text = [self getTimeToTimeStr:date];
}

- (NSString *)getTimeToTimeStr:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY年M月d日"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarBackgroundStyleTransparent | YPNavigationBarStyleBlack;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

#pragma mark - API

-(void)getFinanceCalender{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceCalender" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.financeCalenderArray = [MTLJSONAdapter modelsOfClass:[FinanceCalenderModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
    }];
}

@end
