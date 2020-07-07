//
//  HomeNewsHeaderView.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/7.
//

#import "HomeNewsHeaderView.h"

@interface HomeNewsHeaderView()

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HomeNewsHeaderView

+ (instancetype)homeNewsHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeNewsHeaderView class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dateView.layer.cornerRadius = 3;
    _dateView.layer.masksToBounds = YES;
    
    NSDate *todayDate = [NSDate date];
    _dateLabel.text = [self getTimeToTimeStr:todayDate];
}


- (NSString *)getTimeToTimeStr:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY年M月d日"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
}

@end
