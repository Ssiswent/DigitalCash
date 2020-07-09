//
//  FindTalkCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FocusBtnClickedBlock)(BOOL isFocus);
typedef void(^AvatarViewClickedBlock)(void);

@class TalkModel;

@interface FindTalkCell : UITableViewCell

@property (nonatomic, strong) TalkModel *talkModel;

@property (nonatomic, copy) FocusBtnClickedBlock focusBtnClickedBlock;
@property (nonatomic, copy) AvatarViewClickedBlock avatarViewClickedBlock;

@property (strong, nonatomic) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
