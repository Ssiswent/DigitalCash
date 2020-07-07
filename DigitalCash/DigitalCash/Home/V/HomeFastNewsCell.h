//
//  HomeFastNewsCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsModel;

@interface HomeFastNewsCell : UITableViewCell

@property (strong, nonatomic) HomeNewsModel *fastNewsModel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;


@end

NS_ASSUME_NONNULL_END
