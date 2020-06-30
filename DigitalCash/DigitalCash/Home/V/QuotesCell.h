//
//  QuotesCell.h
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeQuotesModel;

@interface QuotesCell : UITableViewCell

@property (nonatomic, strong) HomeQuotesModel *quotesModel;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
