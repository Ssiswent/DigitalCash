//
//  AccountSafeVC.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AccountLogOffBlock)(void);

@interface AccountSafeVC : UIViewController

@property (nonatomic, copy) AccountLogOffBlock accountLogOffBlock;

@end

NS_ASSUME_NONNULL_END
