//
//  HomeFourBtnCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FourBtnCell.h"

@interface FourBtnCell()
@property (weak, nonatomic) IBOutlet UIView *cashView;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *businessView;
@property (weak, nonatomic) IBOutlet UIView *newsView;

@property (weak, nonatomic) IBOutlet UIView *BTCView;

@end

@implementation FourBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _BTCView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _BTCView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _BTCView.layer.shadowOffset = CGSizeMake(0,0);
    _BTCView.layer.shadowOpacity = 1;
    _BTCView.layer.shadowRadius = 7;
    _BTCView.layer.cornerRadius = 10;
    
    [self addGestures];
}

- (void)addGestures
{
    [self addClickCashViewGes];
    [self addClickCalendarViewGes];
    [self addClickBusinessViewGes];
    [self addClickNewsViewGes];
}

- (void)addClickCashViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cashViewClicked)];
    [_cashView addGestureRecognizer:tap];
}

- (void)cashViewClicked
{
    WEAKSELF
    if(weakSelf.cashViewClickedBlock)
    {
        weakSelf.cashViewClickedBlock();
    }
}

- (void)addClickCalendarViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(calendarViewClicked)];
    [_calendarView addGestureRecognizer:tap];
}

- (void)calendarViewClicked
{
    WEAKSELF
    if(weakSelf.calendarViewClickedBlock)
    {
        weakSelf.calendarViewClickedBlock();
    }
}

- (void)addClickBusinessViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(businessViewClicked)];
    [_businessView addGestureRecognizer:tap];
}

- (void)businessViewClicked
{
    WEAKSELF
    if(weakSelf.businessViewClickedBlock)
    {
        weakSelf.businessViewClickedBlock();
    }
}

- (void)addClickNewsViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newsViewClicked)];
    [_newsView addGestureRecognizer:tap];
}

- (void)newsViewClicked
{
    WEAKSELF
    if(weakSelf.newsViewClickedBlock)
    {
        weakSelf.newsViewClickedBlock();
    }
}

@end
