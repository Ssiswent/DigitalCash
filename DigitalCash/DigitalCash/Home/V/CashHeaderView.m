//
//  CashHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "CashHeaderView.h"

@implementation CashHeaderView

+ (instancetype)cashHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CashHeaderView class]) owner:nil options:nil] firstObject];
}

@end
