//
//  CheckInVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckInVC : UIViewController

@property (strong , nonatomic) NSArray *checkInList;
@property (strong , nonatomic) NSMutableArray <NSDate *> *datesArray;
@property (nonatomic, assign) BOOL hasCheckedIn;
@property (copy,nonatomic) NSString *dateStr;

@end

NS_ASSUME_NONNULL_END
