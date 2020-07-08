//
//  CommentModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/18.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface CommentModel : BaseModel

@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)double publishTime;
@property (nonatomic, strong)UserModel *user;

@end

NS_ASSUME_NONNULL_END
