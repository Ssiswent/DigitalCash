//
//  CommunityTopicListModel.m
//  futures
//
//  Created by Ssiswent on 2020/6/8.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "TalkListModel.h"

#import "TalkModel.h"

@implementation TalkListModel

+ (NSDictionary*) JSONKeyPathsByPropertyKey{
    return @{
             NSStringFromSelector(@selector(talksArray)):@"list",
             NSStringFromSelector(@selector(hasMore)):@"hasMore",
             };
}

+(NSValueTransformer *)talksArrayJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSError *newError;
        NSArray *talksArray = [MTLJSONAdapter modelsOfClass:[TalkModel class] fromJSONArray:value error:&newError];
        return talksArray;
    }];
}

@end
