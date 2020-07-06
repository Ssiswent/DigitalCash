//
//  UpToDateView.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickedConfirmBtnBlock)(void);

@interface UpToDateView : UIView

+ (instancetype)upToDateView;

@property (nonatomic, copy) ClickedConfirmBtnBlock clickedConfirmBtnBlock;

@end

NS_ASSUME_NONNULL_END
