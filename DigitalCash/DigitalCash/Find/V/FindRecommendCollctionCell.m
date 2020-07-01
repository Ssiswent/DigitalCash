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
    _focusBtn.selected = !_focusBtn.selected;
}

- (void)setRecommendUserModel:(UserModel *)recommendUserModel
{
    _recommendUserModel = recommendUserModel;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:recommendUserModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = recommendUserModel.nickName;
    _signatureLabel.text = recommendUserModel.signature;
}

@end
