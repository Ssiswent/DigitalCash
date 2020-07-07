//
//  MineInformationView.m
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineInformationNameView.h"

@interface MineInformationNameView()
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation MineInformationNameView

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
    if([self.delegate respondsToSelector:@selector(mineInformationNameViewDidClickCancelBtn:)])
    {
        [self.delegate mineInformationNameViewDidClickCancelBtn:self];
    }
}
- (IBAction)confirmBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(mineInformationNameViewDidClickConfirmBtn:changedName:)])
    {
        [self.delegate mineInformationNameViewDidClickConfirmBtn:self changedName:_nameTextF.text];
    }
}



@end
