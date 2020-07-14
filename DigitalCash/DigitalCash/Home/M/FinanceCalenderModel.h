//
//  FinanceCalenderModel.h
//  Futures0628
//
//  Created by Francis on 2020/7/8.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinanceCalenderModel : BaseModel

@property(nonatomic, copy) NSString *affect;
@property(nonatomic, copy) NSString *consensus;
@property(nonatomic, copy) NSString *previous;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, strong) NSNumber *star;
@property(nonatomic, strong) NSNumber *time;

@end

NS_ASSUME_NONNULL_END
