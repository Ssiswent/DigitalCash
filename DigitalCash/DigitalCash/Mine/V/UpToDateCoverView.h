//
//  UpToDateCoverView.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UpToDateView;

typedef void(^ClickedConfirmBtnBlock1)(void);

@interface UpToDateCoverView : UIView

@property (nonatomic, weak) UpToDateView *upToDateView;

@property (nonatomic, copy) ClickedConfirmBtnBlock1 clickedConfirmBtnBlock1;

@end

NS_ASSUME_NONNULL_END
