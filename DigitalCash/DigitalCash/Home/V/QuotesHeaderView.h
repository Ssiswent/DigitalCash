//
//  CashHeaderView.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SeeAllBtnClickedBlock)(void);

@interface QuotesHeaderView : UIView

+ (instancetype)quotesHeaderView;

@property (nonatomic, copy) SeeAllBtnClickedBlock seeAllBtnClickedBlock;

@end

NS_ASSUME_NONNULL_END
