//
//  HomeFastNewsCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import "HomeFastNewsCell.h"

#import "HomeNewsModel.h"

@interface HomeFastNewsCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




@end

@implementation HomeFastNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
}

- (void)setFastNewsModel:(HomeNewsModel *)fastNewsModel
{
    _fastNewsModel = fastNewsModel;
    _contentLabel.text = fastNewsModel.content;
    _timeLabel.text = [self getTimeToTimeStr:fastNewsModel.time];
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
