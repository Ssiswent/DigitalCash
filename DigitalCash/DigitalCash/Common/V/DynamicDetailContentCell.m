//
//  DynamicDetailContentCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "DynamicDetailContentCell.h"

#import "TalkModel.h"

#import "UserModel.h"

@interface DynamicDetailContentCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTop;

@end

@implementation DynamicDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    _avatarImgView.layer.cornerRadius = 19;
    _avatarImgView.layer.masksToBounds = YES;
    
    _contentImgView.layer.cornerRadius = 10;
    _contentImgView.layer.masksToBounds = YES;
    
    _viewBtn.layer.cornerRadius = 15;
    _likeBtn.layer.cornerRadius = 15;
    _commitBtn.layer.cornerRadius = 15;
    _viewBtn.layer.masksToBounds = YES;
    _likeBtn.layer.masksToBounds = YES;
    _commitBtn.layer.masksToBounds = YES;
    
    _commitCount = _commitBtn.titleLabel.text.intValue;
}

- (void)setCommitCount:(int)commitCount
{
    _commitCount = commitCount;
    [_commitBtn setTitle:[NSString stringWithFormat:@"%d",commitCount] forState:UIControlStateNormal];
}

- (void)setDynamicModel:(TalkModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    
    UserModel *userModel = dynamicModel.user;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
                          placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;
    
    //字符串分割
    NSArray *contentArray = [dynamicModel.content componentsSeparatedByString:@"。"];
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
        self.contentLabelHeight.constant = 168.5;
        self.contentLabelTop.constant = 15.5;
        self.contentLabel.text = contentArray[1];
    }
    
    if([dynamicModel.picture isEqualToString:@""])
    {
        self.contentImgView.hidden = YES;
        self.contentImgViewHeight.constant = 0;
        self.contentImgViewTop.constant = 0;
    }
    else
    {
        self.contentImgView.hidden = NO;
        self.contentImgViewHeight.constant = 170;
        self.contentImgViewTop.constant = 10;
        
        NSString *picStr;
        if([dynamicModel.picture containsString:@","])
        {
            //字符串分割
            NSArray *imgsArray = [dynamicModel.picture componentsSeparatedByString:@","];
            picStr = imgsArray[0];
        }
        else
        {
            picStr = dynamicModel.picture;
        }
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:picStr]
        placeholderImage:[UIImage imageNamed:@"contentImg"]];
    }
    
    _timeLabel.text = [self getTimeToTimeStr:dynamicModel.publishTime];
    _dateLabel.text = [self getTimeToDateStr:dynamicModel.publishTime];
    
    //随机数
    int count1 = arc4random() % 61;
    int count2 = arc4random() % 21;
    [_viewBtn setTitle:[NSString stringWithFormat:@"%d",count1] forState:UIControlStateNormal];
    [_likeBtn setTitle:[NSString stringWithFormat:@"%d",count2] forState:UIControlStateNormal];
}

- (NSString *)getTimeToTimeStr:(double)time{
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:publishDate];
    return timeStr;
}

- (NSString *)getTimeToDateStr:(double)time{
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:publishDate];
    return dateStr;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

- (IBAction)likeBtnClicked:(id)sender {
    _likeBtn.selected = !_likeBtn.selected;
    NSString *likeCountStr = _likeBtn.titleLabel.text;
    int likeCount = [likeCountStr intValue];
    if(_likeBtn.selected)
    {
        likeCount ++;
    }
    else
    {
        likeCount --;
    }
    [_likeBtn setTitle:[NSString stringWithFormat:@"%d",likeCount] forState:UIControlStateNormal];
}

- (IBAction)commitBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.commitBtnClickedBlock)
    {
        weakSelf.commitBtnClickedBlock();
    }
}

@end
