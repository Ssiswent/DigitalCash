//
//  MineFocusAndFansVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineUserModel;

@interface MineFocusAndFansVC : UIViewController

@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *focusOrFans;

@property (nonatomic, strong)MineUserModel *user;

@end

NS_ASSUME_NONNULL_END
