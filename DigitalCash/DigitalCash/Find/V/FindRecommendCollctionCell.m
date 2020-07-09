//
//  FindRecommendCollctionCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import "FindRecommendCollctionCell.h"

#import "UserModel.h"

@interface FindRecommendCollctionCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end

@implementation FindRecommendCollctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
}

- (IBAction)focusBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.focusBtnClickedBlock)
    {
        weakSelf.focusBtnClickedBlock(!_focusBtn.selected);
    }
}

- (void)setRecommendUserModel:(UserModel *)recommendUserModel
{
    _recommendUserModel = recommendUserModel;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:recommendUserModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = recommendUserModel.nickName;
    _signatureLabel.text = recommendUserModel.signature;
    
    _focusBtn.selected = NO;
    
    if(_userId != nil)
    {
        [self getFocusUser:recommendUserModel.userId];
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
