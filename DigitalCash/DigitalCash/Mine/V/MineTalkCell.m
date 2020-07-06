//
//  MineTalkCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/3.
//

#import "MineTalkCell.h"

#import "TalkModel.h"
#import "UserModel.h"

@interface MineTalkCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewTop;

@end

@implementation MineTalkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    _avatarImgView.layer.cornerRadius = 20;
    _avatarImgView.layer.masksToBounds = YES;
    
    _contentImgView.layer.cornerRadius = 10;
    _contentImgView.layer.masksToBounds = YES;
    
    //设置文本行间距
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 32, CGFLOAT_MAX)];
    CGFloat contentLabelHeight = 0;
    
    //计算文本高度,文本只有一行
    if (size.height <  2 * [UIFont systemFontOfSize:11].lineHeight) {
        contentLabelHeight = [UIFont systemFontOfSize:11].lineHeight;
    }
    //计算文本高度,文本有多行
    else
    {
        //设置文本行间距
        NSString *string = _contentLabel.text;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5; // 调整行间距
        NSRange range = NSMakeRange(0, [string length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        _contentLabel.attributedText = attributedString;
    }
}

- (void)setTalkModel:(TalkModel *)talkModel
{
    _talkModel = talkModel;
    
    UserModel *userModel = talkModel.user;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;
    self.signatureLabel.text = userModel.signature;
    
    self.contentLabel.text = talkModel.content;
    
    if([talkModel.picture isEqualToString:@""])
    {
        self.contentImgView.hidden = YES;
        self.contentImgViewHeight.constant = 0;
        self.contentImgViewTop.constant = 0;
    }
    else
    {
        self.contentImgView.hidden = NO;
        self.contentImgViewHeight.constant = 200;
        self.contentImgViewTop.constant = 10;
        
        NSString *picStr;
        if([talkModel.picture containsString:@","])
        {
            //字符串分割
            NSArray *imgsArray = [talkModel.picture componentsSeparatedByString:@","];
            picStr = imgsArray[0];
        }
        else
        {
            picStr = talkModel.picture;
        }
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:picStr]
        placeholderImage:[UIImage imageNamed:@"contentImg"]];
    }
    
    self.timeLabel.text = [self getPublishTime:talkModel.publishTime];
}

//计算发布时间
- (NSString *)getPublishTime:(double) publishTime
{
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishTime / 1000];
    NSDate *todayDate = [NSDate date];
    NSTimeInterval doubleDistance = [todayDate timeIntervalSinceDate:publishDate];
    NSInteger integerDistance = doubleDistance;
    NSInteger secondsInAnHour = 3600;
    NSInteger secondsInAMinitue = 60;
    NSInteger hoursInADay = 24;
    NSInteger hoursBetweenDates = integerDistance / secondsInAnHour;
    NSInteger minutesBetweenDates = integerDistance % secondsInAnHour / secondsInAMinitue;
    NSInteger daysBetweenDates = hoursBetweenDates / hoursInADay;
    
    NSString *timeStr1 = [NSString stringWithFormat:@"%ld小时%ld分钟前更新",(long)hoursBetweenDates,(long)minutesBetweenDates];
    NSString *timeStr2 = [NSString stringWithFormat:@"%ld分钟前更新",(long)minutesBetweenDates];
    NSString *timeStr3 = [NSString stringWithFormat:@"%ld天前更新",(long)daysBetweenDates];
    
    if(hoursBetweenDates <= 0)
    {
        return timeStr2;
    }
    else if (hoursBetweenDates > 0 && hoursBetweenDates < 24)
    {
        return timeStr1;
    }
    else
    {
        return timeStr3;
    }
}

@end
