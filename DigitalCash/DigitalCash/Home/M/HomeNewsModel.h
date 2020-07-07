//
//  HomeNewsModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeNewsModel : BaseModel

@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *country;
@property (nonatomic, strong)NSNumber *time;

@end

NS_ASSUME_NONNULL_END
