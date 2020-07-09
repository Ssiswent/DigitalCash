//
//  MineDynamicVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface MineDynamicVC : UIViewController

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) BOOL isMineDynamic;

@property (nonatomic, strong) NSNumber *talksCount;

@end

NS_ASSUME_NONNULL_END
