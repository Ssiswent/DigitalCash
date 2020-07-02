//
//  MIneCodeView.m
//  futures
//
//  Created by Ssiswent on 2020/6/1.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineCodeView.h"

@interface MineCodeView()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;

@end

@implementation MineCodeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#575A61"] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#E8BBAF"]];
    [_confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#D95336"]];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(codeImgViewClicked)];
    [_codeImgView addGestureRecognizer:tap];
}

- (void)codeImgViewClicked
{
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickCodeImgView:)])
    {
        [self.delegate MineCodeViewDidClickCodeImgView:self];
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickCancelBtn:)])
    {
        [self.delegate MineCodeViewDidClickCancelBtn:self];
    }
}

- (IBAction)confirmBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickConfirmBtn:inputCode:)])
    {
        [self.delegate MineCodeViewDidClickConfirmBtn:self inputCode:_codeTextF.text];
    }
}
- (IBAction)changeBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickChangeBtn:)])
    {
        [self.delegate MineCodeViewDidClickChangeBtn:self];
    }
}

@end
