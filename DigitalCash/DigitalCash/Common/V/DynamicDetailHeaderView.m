//
//  DynamicDetailHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "DynamicDetailHeaderView.h"

@implementation DynamicDetailHeaderView

+ (instancetype)dynamicDetailHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DynamicDetailHeaderView class]) owner:nil options:nil] firstObject];
}

@end
