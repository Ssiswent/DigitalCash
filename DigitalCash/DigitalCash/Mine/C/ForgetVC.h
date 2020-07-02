//
//  ForgetVC.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PwdChangedBlock)(void);
typedef void(^RegisterSucceedBlock)(void);

@interface ForgetVC : UIViewController

@property (nonatomic, copy) PwdChangedBlock pwdChangedBlock;
@property (nonatomic, copy) RegisterSucceedBlock registerSucceedBlock;

@property (nonatomic, copy) NSString *forgetOrRegister;

@end

NS_ASSUME_NONNULL_END
