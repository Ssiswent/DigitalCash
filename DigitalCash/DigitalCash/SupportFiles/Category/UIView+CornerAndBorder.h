//
//  UIView+CornerAndBorder.h
//  Futures
//
//  Created by Ssiswent on 2020/6/18.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CornerAndBorder)

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
