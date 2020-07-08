//
//  DynamicDetailCommentCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommentModel;

@interface DynamicDetailCommentCell : UITableViewCell

@property (strong, nonatomic) CommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
