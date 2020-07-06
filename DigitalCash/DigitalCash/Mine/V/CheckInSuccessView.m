//
//  CheckInSuccessView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CheckInSuccessView.h"

@interface CheckInSuccessView()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CheckInSuccessView

+ (instancetype)checkInSuccessView
{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CheckInSuccessView class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_dateLabel.text];
    // 改变文字颜色
    [attributedText setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"#F85B3A"]} range:NSMakeRange(7, 2)];
    _dateLabel.attributedText = attributedText;
}

- (IBAction)closeBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.clickedCloseBtnBlock)
    {
        weakSelf.clickedCloseBtnBlock();
    }
}

@end
