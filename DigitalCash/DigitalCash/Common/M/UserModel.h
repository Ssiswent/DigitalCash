//
//  UserModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BaseModel

@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *pwd;

@property (nonatomic, copy)NSString *head;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, strong)NSNumber *followCount;
@property (nonatomic, strong)NSNumber *fansCount;
@property (nonatomic, copy)NSString *signature;
@property (nonatomic, strong)NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
