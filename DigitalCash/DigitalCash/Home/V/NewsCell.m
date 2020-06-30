//
//  NewsCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "NewsCell.h"

#import "TalkModel.h"
#import "UserModel.h"


@interface NewsCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    _contentImgView.layer.cornerRadius = 5;
    _contentImgView.layer.masksToBounds = YES;
}

- (void)setTalkModel:(TalkModel *)talkModel
{
    _talkModel = talkModel;
    _contentLabel.text = talkModel.content;
    
    UserModel *user = talkModel.user;
    _nameLabel.text = user.nickName;
    
    //随机查看数
    int count = arc4random() % 61;
    _viewCountLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    switch (index % 5) {
        case 0:
            _contentImgView.image = [UIImage imageNamed:@"news_1"];
            break;
        case 1:
            _contentImgView.image = [UIImage imageNamed:@"news_2"];
            break;
        case 2:
            _contentImgView.image = [UIImage imageNamed:@"news_3"];
            break;
        case 3:
            _contentImgView.image = [UIImage imageNamed:@"news_4"];
            break;
        default:
            _contentImgView.image = [UIImage imageNamed:@"news_5"];
            break;
    }
}

@end
