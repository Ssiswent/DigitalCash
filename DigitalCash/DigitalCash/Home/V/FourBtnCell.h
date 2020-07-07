//
//  HomeFourBtnCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CashViewClickedBlock)(void);
typedef void(^CalendarViewClickedBlock)(void);
typedef void(^BusinessViewClickedBlock)(void);
typedef void(^NewsViewClickedBlock)(void);

@interface FourBtnCell : UITableViewCell

@property (nonatomic, copy) CashViewClickedBlock cashViewClickedBlock;
@property (nonatomic, copy) CalendarViewClickedBlock calendarViewClickedBlock;
@property (nonatomic, copy) BusinessViewClickedBlock businessViewClickedBlock;
@property (nonatomic, copy) NewsViewClickedBlock newsViewClickedBlock;

@end

NS_ASSUME_NONNULL_END
