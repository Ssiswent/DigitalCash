//
//  FinanceCalenderModel.m
//  Futures0628
//
//  Created by Francis on 2020/7/8.
//

#import "FinanceCalenderModel.h"

@implementation FinanceCalenderModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
             NSStringFromSelector(@selector(affect)):@"affect",
             NSStringFromSelector(@selector(consensus)):@"consensus",
             NSStringFromSelector(@selector(previous)):@"previous",
             NSStringFromSelector(@selector(name)):@"name",
             NSStringFromSelector(@selector(country)):@"country",
             NSStringFromSelector(@selector(star)):@"star",
             NSStringFromSelector(@selector(time)):@"time",
             };
}

@end
