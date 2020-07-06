//
//  EmptyView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

+ (instancetype)emptyView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([EmptyView class]) owner:nil options:nil] firstObject];
}

@end
