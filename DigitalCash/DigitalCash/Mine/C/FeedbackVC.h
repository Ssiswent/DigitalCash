//
//  FeedbackVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/20.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedbackVC;

@protocol FeedbackVCDelegate <NSObject>

@optional

- (void)FeedbackVCDidSuccessFeedback:(FeedbackVC *)feedbackVC;

@end

@interface FeedbackVC : UIViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *tag1Str;
@property (nonatomic, copy) NSString *tag2Str;
@property (nonatomic, strong) NSNumber *talkId;

@property (nonatomic, weak)id<FeedbackVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
