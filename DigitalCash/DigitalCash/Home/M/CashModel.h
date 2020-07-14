//
//  CashModel.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CashModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)NSNumber *money;
@property (nonatomic, strong)NSNumber *upDownMoney;
@property (nonatomic, strong)NSNumber *upDownPercent;

+ (instancetype)cashWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
