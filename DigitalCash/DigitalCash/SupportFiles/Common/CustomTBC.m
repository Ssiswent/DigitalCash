//
//  CustomTBC.m
//  futures
//
//  Created by Ssiswent on 2020/5/12.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "CustomTBC.h"

@interface CustomTBC ()

@property(nonatomic,assign) NSInteger index;

@property(nonatomic, strong)CustomTBC *tabBarC;

@end

@implementation CustomTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去掉原生tabbar分割线
    [self.tabBar setShadowImage:[UIImage new]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#F85B3A"];
    self.tabBar.unselectedItemTintColor = [UIColor colorWithHexString:@"#AAAAAA"];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != _index) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
                
            }
        }
        if(arry == nil || arry.count == 0){
            return;
        }
        // 控制器如果这么写标题 self.title = @"aaa"; 这个会同时改变 navigationController的title 和 tabBarItem的title,而且tabBarButton的对象也发生了改变(遍历的UITabBarButton顺序可能发生改变了)。所以保险起见 在此加个排序。
        for (int i = 1; i < arry.count; i++) {
            for (int j = 0; j < arry.count - i; j++) {
                int x0 = [arry[j]frame].origin.x;
                int x1 = [arry[j+1]frame].origin.x;
                if (x0>x1) {
                    [arry exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
                
            }
        }
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = 1;      //次数
        animation.duration = 0.25;       //时间
        animation.fromValue = [NSNumber numberWithFloat:0.8];   //伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1];     //结束伸缩倍数
        [[arry[index] layer] addAnimation:animation forKey:nil];
        //记录当前的显示的Tabbar的index
        _index = index;
    }
}

//隐藏显示tabbar
+ (void)setTabBarHidden:(BOOL)hidden TabBarVC:(UITabBarController*)tabbarVC

{
    //打印的数据为 iPhone7 测试
    
    UIView *tab = tabbarVC.view; //UILayoutContainerView: 0x145d10390; frame = (0 0; 375 667);
    
    CGRect tabRect = tabbarVC.tabBar.frame;//tabRect = (origin = (x = 0, y = 618), size = (width = 375, height = 49))
    
    if ([tab.subviews count] < 2) {// tab.subviews[0] = UITransitionView ;  tab.subviews[1] = UITabbar
        
        return;
        
    }
    
    UIView *view; //UITransitionView  frame 等于 全屏
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        
        view = [tab.subviews objectAtIndex:1];
        
    } else {
        
        view = [tab.subviews objectAtIndex:0];
        
    }
    
    
    if (hidden) {
        //隐藏
        view.frame = tab.bounds;
        
        tabRect.origin.y=[[UIScreen mainScreen]bounds].size.height+tabbarVC.tabBar.frame.size.height;
        
    } else {
        //显示
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        
        tabRect.origin.y=[[UIScreen mainScreen] bounds].size.height-tabbarVC.tabBar.frame.size.height;
        
    }
    
    
    [UIView animateWithDuration:0.3f animations:^{
        
        tabbarVC.tabBar.frame=tabRect;
        
    }completion:^(BOOL finished) {
        
    }];
    
}

@end
