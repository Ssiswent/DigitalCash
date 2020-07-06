//
//  CheckInSuccessView.h
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickedCloseBtnBlock)(void);


@interface CheckInSuccessView : UIView

+ (instancetype)checkInSuccessView;

@property (nonatomic, copy) ClickedCloseBtnBlock clickedCloseBtnBlock;

@end

NS_ASSUME_NONNULL_END
