//
//  CashCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "CashCell.h"

#import "CashModel.h"

@interface CashCell()

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *upDownMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *upDownPercentLabel;

@end

@implementation CashCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCashModel:(CashModel *)cashModel
{
    _cashModel = cashModel;
    
    NSString *codeStr = [cashModel.code substringWithRange:NSMakeRange(0,3)];
    
    CGFloat moneyFloat = cashModel.money.floatValue;
    NSString *moneyStr1 = [NSString stringWithFormat:@"%.5f",moneyFloat];
    NSNumber * moneyNumber = @(moneyStr1.floatValue);
    NSString * moneyStr = [NSString stringWithFormat:@"$%@",moneyNumber];
    
    CGFloat upDownMoneyFLoat = cashModel.upDownMoney.floatValue;
    NSString *upDownMoneyStr1 = [NSString stringWithFormat:@"%.5f",upDownMoneyFLoat];
    NSNumber * upDownMoneyNumber = @(upDownMoneyStr1.floatValue);
    NSString * upDownMoneyStr = [NSString stringWithFormat:@"$%@",upDownMoneyNumber];
    
    CGFloat upDownPercentFloat = cashModel.upDownPercent.floatValue;
    NSString *upDownPercentStr1 = [NSString stringWithFormat:@"%.2f%%",upDownPercentFloat];
    NSNumber * upDownPercentNumber = @(upDownPercentStr1.floatValue);
    NSString * upDownPercentStr = [NSString stringWithFormat:@"%@%%",upDownPercentNumber];
    
    _codeLabel.text = codeStr;
    _moneyLabel.text = moneyStr;
    _upDownMoneyLabel.text = upDownMoneyStr;
    _upDownPercentLabel.text = upDownPercentStr;
}

@end
