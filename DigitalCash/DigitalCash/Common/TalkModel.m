//
//  CommunityDynamicModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "TalkModel.h"

#import "UserModel.h"

@implementation TalkModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
        NSStringFromSelector(@selector(talkId)):@"id",
        NSStringFromSelector(@selector(content)):@"content",
        NSStringFromSelector(@selector(picture)):@"picture",
        NSStringFromSelector(@selector(publishTime)):@"publishTime",
        NSStringFromSelector(@selector(zanCount)):@"zanCount",
        NSStringFromSelector(@selector(commentCount)):@"commentCount",
        NSStringFromSelector(@selector(user)):@"user",
    };
}

+(NSValueTransformer *)userJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSError *newError;
        UserModel *model = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:value error:&newError];
        return model;
    }];
}

@end
