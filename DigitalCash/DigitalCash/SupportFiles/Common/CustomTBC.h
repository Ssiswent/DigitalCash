//
//  CustomTBC.h
//  futures
//
//  Created by Ssiswent on 2020/5/12.
//  Copyright © 2020 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTBC : UITabBarController

//隐藏显示tabbar
+ (void)setTabBarHidden:(BOOL)hidden TabBarVC:(UITabBarController*)tabbarVC;

@end

NS_ASSUME_NONNULL_END
