//
//  MineTalkSortCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickedDefaultBtnBlock)(void);
typedef void(^ClickedNewBtnBlock)(void);

@interface MineTalkSortCell : UITableViewCell

@property (nonatomic, copy) ClickedDefaultBtnBlock clickedDefaultBtnBlock;
@property (nonatomic, copy) ClickedNewBtnBlock clickedNewBtnBlock;

@end

NS_ASSUME_NONNULL_END
