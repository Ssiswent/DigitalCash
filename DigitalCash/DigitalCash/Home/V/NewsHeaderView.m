//
//  CashHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "NewsHeaderView.h"

@implementation NewsHeaderView

+ (instancetype)newsHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NewsHeaderView class]) owner:nil options:nil] firstObject];
}

@end
