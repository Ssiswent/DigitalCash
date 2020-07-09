//
//  MineMessagesVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "MineMessagesVC.h"

#import "MineUserModel.h"

#import "MineFocusAndFansVC.h"
#import "LikeVC.h"

#import "CustomTBC.h"

@interface MineMessagesVC ()<UIGestureRecognizerDelegate, YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet UIView *fansView;

@end

@implementation MineMessagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = @"消息";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self addGestures];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addGestures
{
    [self addClickLikeViewGes];
    [self addClickCommitViewGes];
    [self addClickFansViewGes];
}

- (void)addClickLikeViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeViewClicked)];
    [_likeView addGestureRecognizer:tap];
}

- (void)likeViewClicked
{
    LikeVC *likeVC = LikeVC.new;
    likeVC.titleStr = @"点赞";
    [self.navigationController pushViewController:likeVC animated:YES];
}

- (void)addClickCommitViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commitViewClicked)];
    [_commitView addGestureRecognizer:tap];
}

- (void)commitViewClicked
{
    LikeVC *commitVC = LikeVC.new;
    commitVC.titleStr = @"评论";
    [self.navigationController pushViewController:commitVC animated:YES];
}

- (void)addClickFansViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fansViewClicked)];
    [_fansView addGestureRecognizer:tap];
}

- (void)fansViewClicked
{
    MineFocusAndFansVC *focusAndFansVC = [[MineFocusAndFansVC alloc] init];
    focusAndFansVC.titleStr = @"粉丝";
    focusAndFansVC.focusOrFans = @"Fans";
    MineUserModel *user = [MineUserModel sharedMineUserModel];
    focusAndFansVC.user = user;
    [self.navigationController pushViewController:focusAndFansVC animated:YES];
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

@end
