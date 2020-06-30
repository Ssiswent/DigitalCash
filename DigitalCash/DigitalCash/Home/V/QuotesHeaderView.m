//
//  CashHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "QuotesHeaderView.h"

@implementation QuotesHeaderView

+ (instancetype)quotesHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([QuotesHeaderView class]) owner:nil options:nil] firstObject];
}

@end
