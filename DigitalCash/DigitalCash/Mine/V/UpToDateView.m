//
//  UpToDateView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/6.
//

#import "UpToDateView.h"

@implementation UpToDateView

+ (instancetype)upToDateView
{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UpToDateView class]) owner:nil options:nil] firstObject];
}

- (IBAction)confirmBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.clickedConfirmBtnBlock)
    {
        weakSelf.clickedConfirmBtnBlock();
    }
}


@end
