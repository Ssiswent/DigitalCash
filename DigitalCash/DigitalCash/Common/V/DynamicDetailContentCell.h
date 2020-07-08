//
//  DynamicDetailContentCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommitBtnClickedBlock)(void);

@class TalkModel;

@interface DynamicDetailContentCell : UITableViewCell

@property (strong, nonatomic) TalkModel *dynamicModel;

@property (nonatomic, copy) CommitBtnClickedBlock commitBtnClickedBlock;

@property (nonatomic, assign) int commitCount;

@end

NS_ASSUME_NONNULL_END
