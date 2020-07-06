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
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#575A61"] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8BBAF"]];
    [_confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#D95336"]];
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
