//
//  HomeFourBtnCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "FourBtnCell.h"

@interface FourBtnCell()

@property (weak, nonatomic) IBOutlet UIView *BTCView;

@end

@implementation FourBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _BTCView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _BTCView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _BTCView.layer.shadowOffset = CGSizeMake(0,0);
    _BTCView.layer.shadowOpacity = 1;
    _BTCView.layer.shadowRadius = 7;
    _BTCView.layer.cornerRadius = 10;
}

@end
