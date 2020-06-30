//
//  QuotesCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/6/30.
//

#import "QuotesCell.h"

#import "HomeQuotesModel.h"

@interface QuotesCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *upDownLabel;

@end

@implementation QuotesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setQuotesModel:(HomeQuotesModel *)quotesModel
{
    _quotesModel = quotesModel;
    _leftImgView.image = [UIImage imageNamed:quotesModel.leftImgStr];
    _nameLabel.text = quotesModel.nameStr;
    _cashLabel.text = quotesModel.cashStr;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    if(index % 2 == 0)
    {
        _bgImgView.image = [UIImage imageNamed:@"box_up_home"];
        _cashLabel.text = @"Bitcoin";
        _upDownLabel.text = @"+3.12%";
        _upDownLabel.textColor = [UIColor colorWithHexString:@"#EA3B34"];
    }
    else
    {
        _bgImgView.image = [UIImage imageNamed:@"box_down_home"];
        _cashLabel.text = @"Ethereum";
        _upDownLabel.text = @"-3.12%";
        _upDownLabel.textColor = [UIColor colorWithHexString:@"#34EA5B"];
    }
}

@end
