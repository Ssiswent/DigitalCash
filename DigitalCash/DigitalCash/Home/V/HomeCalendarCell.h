//
//  HomeCalendarCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FinanceCalenderModel;

@interface HomeCalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property(strong, nonatomic) FinanceCalenderModel *financeCalenderModel;

@end

NS_ASSUME_NONNULL_END
