//
//  AppDelegate.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "AppDelegate.h"

#import <IQKeyboardManager.h>

#import "HomeVC.h"
#import "CashVC.h"
#import "FindVC.h"
#import "MineVC.h"

#import "CustomTBC.h"

@interface AppDelegate ()

@property(nonatomic, strong) CustomTBC *tabBarC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"#DA8D3D"]];
    [IQKeyboardManager sharedManager];
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = YES;
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setTabBarC];
    self.window.rootViewController = _tabBarC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setTabBarC
{
    CustomTBC *tabBarC = CustomTBC.new;
    
    
    self.tabBarC = tabBarC;
    
    HomeVC *homeVC = [[HomeVC alloc]init];
    YPNavigationController *homeNav = [[YPNavigationController alloc] initWithRootViewController:homeVC];
    [homeNav setNavigationBarHidden:true animated:false];
//    homeNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(kScaleFrom_iPhone8_Width(20), 0);
    [self addChildVC:homeNav title:@"首页" imgName:@"ic_home" selectedImgName:@"ic_home_sel"];
    
    CashVC *cashVC = [[CashVC alloc]init];
    YPNavigationController *cashNav = [[YPNavigationController alloc] initWithRootViewController:cashVC];
    [self addChildVC:cashNav title: @"货币" imgName:@"ic_cash" selectedImgName:@"ic_cash_sel"];
    
    FindVC *findVC = [[FindVC alloc]init];
    YPNavigationController *findNav = [[YPNavigationController alloc] initWithRootViewController:findVC];
    [self addChildVC:findNav title: @"发现" imgName:@"ic_find" selectedImgName:@"ic_find_sel"];

    MineVC *mineVC = [[MineVC alloc]init];
    YPNavigationController *mineNav = [[YPNavigationController alloc] initWithRootViewController:mineVC];
    [self addChildVC:mineNav title:@"我的" imgName:@"ic_mine" selectedImgName:@"ic_mine_sel"];
//    mineNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(kScaleFrom_iPhone8_Width(-20), 0);
}

/// TBC添加子控制器
/// @param nav 导航控制器
/// @param title 按钮文字
/// @param imgName 按钮图片
/// @param selectedImgName 按钮选择图片
- (void)addChildVC:(YPNavigationController *)nav title:(NSString *)title imgName:(NSString *)imgName selectedImgName:(NSString *)selectedImgName
{
    nav.tabBarItem.title = title;
    [nav.tabBarItem setImage:[UIImage originalImageWithName:imgName]];
    [nav.tabBarItem setSelectedImage:[UIImage originalImageWithName:selectedImgName]];
    [self.tabBarC addChildViewController:nav];
}

@end
