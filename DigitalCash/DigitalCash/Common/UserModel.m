//
//  UserModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
        NSStringFromSelector(@selector(phone)):@"phone",
        NSStringFromSelector(@selector(pwd)):@"password",
        
        NSStringFromSelector(@selector(head)):@"head",
        NSStringFromSelector(@selector(nickName)):@"nickName",
        NSStringFromSelector(@selector(followCount)):@"followCount",
        NSStringFromSelector(@selector(fansCount)):@"fansCount",
        NSStringFromSelector(@selector(signature)):@"signature",
        NSStringFromSelector(@selector(userId)):@"id",
    };
}

@end
