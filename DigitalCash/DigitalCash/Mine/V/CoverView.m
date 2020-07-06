//
//  CoverView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/20.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CoverView.h"
#import "CheckInSuccessView.h"

@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _successView = [CheckInSuccessView checkInSuccessView];
        WEAKSELF
        _successView.clickedCloseBtnBlock = ^{
            if(weakSelf.clickedCloseBtnBlock1)
            {
                weakSelf.clickedCloseBtnBlock1();
            }
        };
        [self addSubview:_successView];
    }
    return self;
}

- (void)layoutSubviews
{
        [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 294 / 375));
        }];
}

@end
