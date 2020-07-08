//
//  CommentModel.m
//  Futures
//
//  Created by Ssiswent on 2020/6/18.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommentModel.h"

#import "UserModel.h"

@implementation CommentModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
             NSStringFromSelector(@selector(content)):@"content",
             NSStringFromSelector(@selector(publishTime)):@"publishTime",
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
