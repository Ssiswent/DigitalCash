//
//  CoverView.h
//  Futures
//
//  Created by Ssiswent on 2020/6/20.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckInSuccessView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickedCloseBtnBlock1)(void);

@interface CoverView : UIView

@property (nonatomic, weak) CheckInSuccessView *successView;

@property (nonatomic, copy) ClickedCloseBtnBlock1 clickedCloseBtnBlock1;


@end

NS_ASSUME_NONNULL_END
