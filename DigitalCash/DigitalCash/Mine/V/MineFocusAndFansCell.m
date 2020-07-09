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
    WEAKSELF
    if(weakSelf.focusBtnClickedBlock)
    {
        weakSelf.focusBtnClickedBlock(!_focusBtn.selected);
    }
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = model.nickName;
    
//    _focusBtn.selected = NO;
    
    if(_userId != nil)
    {
        [self getFocusUser:model.userId];
    }
}

// MARK: API

- (void)getFocusUser:(NSNumber *) followerId{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"followerId":followerId
    };
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/isFollow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSNumber *data = result[@"data"];
        
        BOOL isFocus = NO;
        if([data isEqualToNumber:@0])
        {
            isFocus = NO;
        }
        else if([data isEqualToNumber:@1])
        {
            isFocus = YES;
        }
        
        weakSelf.focusBtn.selected = isFocus;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"获取关注失败" afterHideTime:DELAYTiME];
    }];
}

@end
