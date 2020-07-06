//
//  MineInformationView.h
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineLogoutView;

@protocol MineLogoutViewDelegate <NSObject>

@optional

- (void)mineLogoutViewDidClickCancelBtn:(MineLogoutView *)mineLogoutView;
- (void)mineLogoutViewDidClickConfirmBtn:(MineLogoutView *)mineLogoutView;

@end

@interface MineLogoutView : UIView

@property (nonatomic, weak)id<MineLogoutViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
