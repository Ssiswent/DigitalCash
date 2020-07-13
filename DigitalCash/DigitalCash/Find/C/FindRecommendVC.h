//
//  FindRecommendVC.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "ContentBaseViewController.h"

typedef void(^HideBlock)(void);
typedef void(^ShowBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface FindRecommendVC : ContentBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) HideBlock hideBlock;
@property (nonatomic, copy) ShowBlock showBlock;

@end

NS_ASSUME_NONNULL_END
