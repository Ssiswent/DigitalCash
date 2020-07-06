//
//  MineInformationView.m
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineLogoutView.h"

@interface MineLogoutView()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation MineLogoutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:144/255.0 green:153/255.0 blue:253/255.0 alpha:0.8]];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,CGRectGetWidth(_confirmBtn.frame),CGRectGetHeight(_confirmBtn.frame));
    gl.startPoint = CGPointMake(1, 1);
    gl.endPoint = CGPointMake(0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:41/255.0 green:58/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:144/255.0 green:153/255.0 blue:253/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [_confirmBtn.layer addSublayer:gl];
}

- (IBAction)cancelBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(mineLogoutViewDidClickCancelBtn:)])
    {
        [self.delegate mineLogoutViewDidClickCancelBtn:self];
    }
}
- (IBAction)confirmBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(mineLogoutViewDidClickConfirmBtn:)])
    {
        [self.delegate mineLogoutViewDidClickConfirmBtn:self];
    }
}



@end
