//
//  FindRecommendFocusCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseBtnClickedBlock)(void);

@interface FindRecommendFocusCell : UITableViewCell

@property (nonatomic, copy) CloseBtnClickedBlock closeBlock;

@end

NS_ASSUME_NONNULL_END
