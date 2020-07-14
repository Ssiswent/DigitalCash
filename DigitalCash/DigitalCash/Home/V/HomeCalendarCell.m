//
//  HomeCalendarCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import "HomeCalendarCell.h"

#import "FinanceCalenderModel.h"

@interface HomeCalendarCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectLabel;

@property (strong, nonatomic) NSArray *starArray;

@end

@implementation HomeCalendarCell

- (NSArray *)starArray
{
    if(_starArray == nil)
    {
        _starArray = [NSArray arrayWithObjects:
                          self.star1,
                          self.star2,
                          self.star3,
                          self.star4,
                          self.star5,
                          nil];
    }
    return _starArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _flagImgView.layer.cornerRadius = 3;
    _flagImgView.layer.masksToBounds = YES;
}

- (void)setFinanceCalenderModel:(FinanceCalenderModel *)financeCalenderModel
{
    _financeCalenderModel = financeCalenderModel;
    
    _timeLabel.text = [self getTimeToTimeStr:financeCalenderModel.time];
    
    NSString *pngStr = [NSString stringWithFormat:@"https://cdn.jin10.com/assets/img/commons/flag/%@.png", financeCalenderModel.country];
    //转utf-8
    pngStr = [pngStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [_flagImgView sd_setImageWithURL:[NSURL URLWithString:pngStr]];
    
    [self setStarStatus:financeCalenderModel.star];
    
    _contentLabel.text = financeCalenderModel.name;
    
    _previousLabel.text = financeCalenderModel.previous;
    
    if([financeCalenderModel.consensus isEqualToString:@"null"])
    {
        _expectLabel.text = @"--";
    }
    else
    {
        _expectLabel.text = financeCalenderModel.consensus;
    }
    
    if([financeCalenderModel.affect isEqualToString:@"1"])
    {
        _bgImgView.image = [UIImage imageNamed:@"bg_yigongbu_rili"];
    }
    else
    {
        _bgImgView.image = [UIImage imageNamed:@"bg_weigongbu_rili"];
    }
}

- (void)setStarStatus:(NSNumber *)star{
    
    for (UIImageView *starImgView in self.starArray) {
        starImgView.hidden = YES;
    }
    int k = star.intValue;
    for (int i = 0; i < k; i++) {
        UIImageView *imgView = self.starArray[i];
        imgView.hidden = NO;
    }
}

- (NSString *)getTimeToTimeStr:(NSNumber *)time{
    NSInteger integerTime = time.integerValue;
    CGFloat iOSTime = integerTime/1000.0;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:iOSTime];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:detailDate];
    return timeStr;
}

@end
