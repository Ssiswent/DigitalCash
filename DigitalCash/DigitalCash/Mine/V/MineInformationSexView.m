//
//  MineInformationSexView.m
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineInformationSexView.h"

@interface MineInformationSexView()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

@end

@implementation MineInformationSexView

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
    if([self.delegate respondsToSelector:@selector(mineInformationSexViewDidClickCancelBtn:)])
    {
        [self.delegate mineInformationSexViewDidClickCancelBtn:self];
    }
}
- (IBAction)confirmBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(mineInformationSexViewDidClickConfirmBtn:)])
    {
        [self.delegate mineInformationSexViewDidClickConfirmBtn:self];
    }
}
- (IBAction)manBtnClicked:(id)sender {
    _manBtn.selected = YES;
    _womanBtn.selected = NO;
}
- (IBAction)womanBtnClicked:(id)sender {
    _manBtn.selected = NO;
    _womanBtn.selected = YES;
}

@end
