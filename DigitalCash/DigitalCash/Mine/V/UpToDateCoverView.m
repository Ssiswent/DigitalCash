//
//  UpToDateCoverView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import "UpToDateCoverView.h"

#import "UpToDateView.h"

@implementation UpToDateCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _upToDateView = [UpToDateView upToDateView];
        WEAKSELF
        _upToDateView.clickedConfirmBtnBlock = ^{
            if(weakSelf.clickedConfirmBtnBlock1)
            {
                weakSelf.clickedConfirmBtnBlock1();
            }
        };
        [self addSubview:_upToDateView];
    }
    return self;
}

- (void)layoutSubviews
{
    [_upToDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 287 / 375));
    }];
}

@end
