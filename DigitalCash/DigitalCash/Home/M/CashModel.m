//
//  CashModel.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/14.
//

#import "CashModel.h"

@implementation CashModel

+ (instancetype)cashWithArray:(NSArray *)array
{
    CashModel *cashModel = self.new;
    
    cashModel.name = array[0];
    cashModel.code = array[1];
    cashModel.money = array[2];
    cashModel.upDownMoney = array[3];
    cashModel.upDownPercent = array[4];
    
    return cashModel;
}

@end
