//
//  FindTalkCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import "FindTalkCell.h"

#import "TalkModel.h"
#import "UserModel.h"

@interface FindTalkCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTop;

@end

@implementation FindTalkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
    
    _contentImgView.layer.cornerRadius = 10;
    _contentImgView.layer.masksToBounds = YES;
    
    [self addClickAvatarViewGes];
}

- (void)addClickAvatarViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarViewClicked)];
    [_avatarImgView addGestureRecognizer:tap];
}

- (void)avatarViewClicked
{
    WEAKSELF
    if(weakSelf.avatarViewClickedBlock)
    {
        weakSelf.avatarViewClickedBlock();
    }
}

- (IBAction)focusBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.focusBtnClickedBlock)
    {
        weakSelf.focusBtnClickedBlock(!_focusBtn.selected);
    }
}

- (void)setTalkModel:(TalkModel *)talkModel
{
    _talkModel = talkModel;
    
    UserModel *userModel = talkModel.user;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;
    
    //字符串分割
    NSArray *contentArray = [talkModel.content componentsSeparatedByString:@"。"];
    self.titleLabel.text = contentArray[0];
    if(contentArray.count <= 1)
    {
        self.contentLabel.hidden = YES;
        self.contentLabelHeight.constant = 0;
        self.contentLabelTop.constant = 0;
    }
    else
    {
        self.contentLabel.hidden = NO;
        self.contentLabelHeight.constant = 43;
        self.contentLabelTop.constant = 15;
        self.contentLabel.text = contentArray[1];
    }
    
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
        self.contentImgViewTop.constant = 5;
        
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
    
    //随机数
    int count1 = arc4random() % 61;
    int count2 = arc4random() % 21;
    int count3 = arc4random() % 21;
    _viewLabel.text = [NSString stringWithFormat:@"%d",count1];
    _likeLabel.text = [NSString stringWithFormat:@"%d",count2];
    _commentLabel.text = [NSString stringWithFormat:@"%d",count3];
    
    _focusBtn.selected = NO;
    
    if(_userId != nil)
    {
        [self getFocusUser:userModel.userId];
    }
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
