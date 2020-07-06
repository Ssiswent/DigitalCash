//
//  CheckInModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckInModel : BaseModel

@property (nonatomic, strong)NSNumber *continueTimes;
@property (nonatomic, assign)double time;

@end

NS_ASSUME_NONNULL_END
