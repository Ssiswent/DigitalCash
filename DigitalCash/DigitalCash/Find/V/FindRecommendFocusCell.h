//
//  FindRecommendFocusCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseBtnClickedBlock)(void);
typedef void(^NeedToLoginBlock)(void);

@interface FindRecommendFocusCell : UITableViewCell

@property (nonatomic, copy) CloseBtnClickedBlock closeBlock;
@property (nonatomic, copy) NeedToLoginBlock needToLoginBlock;

@end

NS_ASSUME_NONNULL_END
