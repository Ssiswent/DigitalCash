//
//  MineUserModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineUserModel.h"

@implementation MineUserModel

+ (instancetype)sharedMineUserModel
{
    static MineUserModel *_sharedMineUserModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedMineUserModel = [[self alloc] init];
    });
    return _sharedMineUserModel;
}


@end
