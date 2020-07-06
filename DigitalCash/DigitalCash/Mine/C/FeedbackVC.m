//
//  FeedbackVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/20.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "FeedbackVC.h"

#import "UIImage+Image.h"

#import "UITextView+WZB.h"

#import "CustomTBC.h"

@interface FeedbackVC ()<UIGestureRecognizerDelegate, YPNavigationBarConfigureStyle>
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIView *textViewBgView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong)NSNumber *userId;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self getUserDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}


- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)initialSetUp
{
    [self setTagBtn:_tagBtn1];
    [self setTagBtn:_tagBtn2];
    [self setTagBtn:_tagBtn3];
    
    _tagBtn1.selected = YES;
    
    [_tagBtn1 setTitle:_tag1Str forState:UIControlStateNormal];
    [_tagBtn2 setTitle:_tag2Str forState:UIControlStateNormal];
    
    _textViewBgView.layer.cornerRadius = 10;
    _textViewBgView.layer.masksToBounds = YES;
    _contactView.layer.cornerRadius = 5;
    _contactView.layer.masksToBounds = YES;
    
    _contentTextView.wzb_placeholder = @"请输入内容";
    _contentTextView.wzb_placeholderColor = [UIColor colorWithHexString:@"#B5B5B7"];
    
    self.title = _titleStr;
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_contentTextView];
    [self.contactTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _submitBtn.layer.cornerRadius = 20;
    _submitBtn.layer.masksToBounds = YES;
    
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#F75B39"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    [_submitBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
}

- (void)textDidChange {
    if(_contactTextField.text.length == 11 && _contentTextView.text.length != 0)
    {
        _submitBtn.enabled = YES;
    }
    else
    {
        _submitBtn.enabled = NO;
    }
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTagBtn:(UIButton *)tagBtn
{
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor colorWithHexString:@"#F7C1B7"];
    UIImage *btnBgSelectedImg = [UIImage imageWithColor:btnBgSelectedColor];
    [tagBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [tagBtn setBackgroundImage:btnBgSelectedImg forState:UIControlStateSelected];
    tagBtn.layer.cornerRadius = 5;
    tagBtn.layer.masksToBounds = YES;
}

- (IBAction)tagBtnClicked:(UIButton *)sender {
    switch (sender.tag) {
            case 11:
                _tagBtn1.selected = YES;
                _tagBtn2.selected = NO;
                _tagBtn3.selected = NO;
                break;
            case 12:
                _tagBtn1.selected = NO;
                _tagBtn2.selected = YES;
                _tagBtn3.selected = NO;
                break;
            case 13:
                _tagBtn1.selected = NO;
                _tagBtn2.selected = NO;
                _tagBtn3.selected = YES;
                break;
            default:
            break;
        }
}

- (IBAction)submitBtnClicked:(id)sender {
    [self feedback];
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarBackgroundStyleTranslucent | YPNavigationBarBackgroundStyleImage | YPNavigationBarStyleBlack;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIImage *)yp_navigationBackgroundImageWithIdentifier:(NSString *__autoreleasing *)identifier
{
    UIImage *image = [UIImage imageNamed:@"bg_nav"];
    return image;
}

// MARK: API

- (void)feedback{
    WEAKSELF
    if(!_talkId)
    {
        _talkId = @2029;
    }
    NSDictionary *dict = @{
        @"userId" : _userId,
        @"talkId" : _talkId,
        @"content" : _contentTextView.text,
        @"contact" : _contactTextField.text
    };
    
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/reportTalk" parameters:nil queryParams:dict Header:nil success:^(BOOL success, id result) {
        [self.navigationController popViewControllerAnimated:YES];
        if([self.delegate respondsToSelector:@selector(FeedbackVCDidSuccessFeedback:)])
        {
            [self.delegate FeedbackVCDidSuccessFeedback:self];
        }
    } failure:^(BOOL failuer, NSError *error) {
        [Toast makeText:weakSelf.view Message:@"反馈失败" afterHideTime:DELAYTiME];
        NSLog(@"%@",error);
    }];
}

@end
