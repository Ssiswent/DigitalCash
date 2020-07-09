//
//  LikeCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "LikeCell.h"

@interface LikeCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelTop;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end

@implementation LikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatarImgView.layer.cornerRadius = 20;
    _avatarImgView.layer.masksToBounds = YES;
    
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

- (void)setIsCommentCell:(BOOL)isCommentCell
{
    _isCommentCell = isCommentCell;
    
    if(isCommentCell)
    {
        _actionLabel.text = @"评论了这条动态";
        _commentLabel.hidden = NO;
        _commentLabelHeight.constant = 15;
        _commentLabelTop.constant = 8.5;
    }
    else
    {
        _actionLabel.text = @"赞了这条动态";
        _commentLabel.hidden = YES;
        _commentLabelHeight.constant = 0;
        _commentLabelTop.constant = 0;
    }
}

@end
