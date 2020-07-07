//
//  HomeNewsModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeNewsModel.h"

@implementation HomeNewsModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
             NSStringFromSelector(@selector(content)):@"content",
             NSStringFromSelector(@selector(country)):@"country",
             NSStringFromSelector(@selector(time)):@"time",
             };
}

@end
