//
//  HomeFocusAndFansCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FocusBtnClickedBlock)(BOOL isFocus);

@class UserModel;

@interface MineFocusAndFansCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (nonatomic, strong)UserModel *model;

@property (nonatomic, copy) FocusBtnClickedBlock focusBtnClickedBlock;

@property (strong, nonatomic) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
