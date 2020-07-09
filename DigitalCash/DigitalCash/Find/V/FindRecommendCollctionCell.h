//
//  FindRecommendCollctionCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FocusBtnClickedBlock)(BOOL isFocus);

@class UserModel;

@interface FindRecommendCollctionCell : UICollectionViewCell

@property (nonatomic, strong)UserModel *recommendUserModel;

@property (nonatomic, copy) FocusBtnClickedBlock focusBtnClickedBlock;
@property (strong, nonatomic) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
