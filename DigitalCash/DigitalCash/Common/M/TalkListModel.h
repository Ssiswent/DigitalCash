//
//  CommunityTopicListModel.h
//  futures
//
//  Created by Ssiswent on 2020/6/8.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "BaseModel.h"

@class TalkModel;

NS_ASSUME_NONNULL_BEGIN

@interface TalkListModel : BaseModel

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSArray <TalkModel*> *talksArray;

@end

NS_ASSUME_NONNULL_END
