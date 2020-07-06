//
//  MineTalkSortCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/3.
//

#import "MineTalkSortCell.h"

@interface MineTalkSortCell()

@property (weak, nonatomic) IBOutlet UIButton *sortNewBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortDefaultBtn;

@end

@implementation MineTalkSortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _sortDefaultBtn.selected = YES;
}

- (IBAction)sortDefaultBtnClicked:(id)sender {
    _sortDefaultBtn.selected = YES;
    _sortNewBtn.selected = NO;
    WEAKSELF
    if(weakSelf.clickedDefaultBtnBlock)
    {
        weakSelf.clickedDefaultBtnBlock();
    }
}

- (IBAction)sortNewBtnClicked:(id)sender {
    _sortDefaultBtn.selected = NO;
    _sortNewBtn.selected = YES;
    WEAKSELF
    if(weakSelf.clickedNewBtnBlock)
    {
        weakSelf.clickedNewBtnBlock();
    }
}


@end
