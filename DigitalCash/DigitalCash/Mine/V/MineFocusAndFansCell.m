//
//  HomeFocusAndFansCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineFocusAndFansCell.h"

#import "UIImage+Image.h"

#import "UserModel.h"

@interface MineFocusAndFansCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MineFocusAndFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatarImgView.layer.cornerRadius = 20;
    _avatarImgView.layer.masksToBounds = YES;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = model.nickName;
}

@end
