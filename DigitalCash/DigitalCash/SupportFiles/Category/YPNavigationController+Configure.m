//
//  YPNavigationController+Configure.m
//  Futures
//
//  Created by Ssiswent on 2020/6/9.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "YPNavigationController+Configure.h"

@implementation YPNavigationController (Configure)

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarBackgroundStyleTransparent;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

@end
