//
//  MineUserModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineUserModel : UserModel

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写

+ (instancetype)sharedMineUserModel;

@end

NS_ASSUME_NONNULL_END
