//
//  LoginVC.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginVCDidGetUserBlock)(void);

@interface LoginVC : UIViewController

@property (nonatomic, copy) LoginVCDidGetUserBlock loginVCDidGetUserBlock;


@end

NS_ASSUME_NONNULL_END
