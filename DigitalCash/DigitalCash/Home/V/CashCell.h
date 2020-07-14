//
//  CashCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CashModel;

@interface CashCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *numberImgView;
@property (nonatomic, strong) CashModel *cashModel;

@end

NS_ASSUME_NONNULL_END
