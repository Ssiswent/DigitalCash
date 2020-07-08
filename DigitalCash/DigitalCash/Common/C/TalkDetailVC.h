//
//  TalkDetailVC.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TalkModel,TalkDetailVC;

@protocol TalkDetailVCDelegate <NSObject>

@optional

- (void)dynamicDetailVCDidClickShieldBtn:(TalkDetailVC *)dynamicDetailVC shieldNum:(NSInteger)shieldNum;

@end

@interface TalkDetailVC : UIViewController

@property (strong, nonatomic) TalkModel *dynamicModel;

@property (assign, nonatomic) NSInteger cellNum;

@property (assign, nonatomic) BOOL rightBarBtnShow;

@property (nonatomic, weak) id<TalkDetailVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
