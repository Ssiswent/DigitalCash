//
//  CheckInModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CheckInModel.h"

@implementation CheckInModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
             NSStringFromSelector(@selector(continueTimes)):@"continueTimes",
             NSStringFromSelector(@selector(time)):@"time",
             };
}

@end
