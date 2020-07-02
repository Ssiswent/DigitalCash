//
//  BaseVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/2.
//

#import "BaseVC.h"

@interface BaseVC ()<YPNavigationBarConfigureStyle>

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBottomView];
}

- (void)setBottomView
{
    UIView *bottomView = UIView.new;
    
    bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bottomView.layer.shadowColor = [UIColor colorWithRed:62/255.0 green:27/255.0 blue:114/255.0 alpha:0.15].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0,0);
    bottomView.layer.shadowOpacity = 1;
    bottomView.layer.shadowRadius = 37;
    
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
    }];
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

@end
