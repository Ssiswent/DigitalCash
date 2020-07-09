//
//  HomeCashVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/9.
//

#import "HomeCashVC.h"

#import "CustomTBC.h"

@interface HomeCashVC ()<UIGestureRecognizerDelegate>

@end

@implementation HomeCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = @"货币中心";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#272727"];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back_black"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
