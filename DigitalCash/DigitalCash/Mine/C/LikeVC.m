//
//  LikeVC.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/8.
//

#import "LikeVC.h"

#import "LikeCell.h"

@interface LikeVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LikeVC

NSString *LikeCellID = @"LikeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initialSetUp
{
    self.title = _titleStr;
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LikeCell class]) bundle:nil] forCellReuseIdentifier:LikeCellID];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITableViewViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:LikeCellID];
    if([_titleStr isEqualToString:@"评论"])
    {
        cell.isCommentCell = YES;
    }
    else if ([_titleStr isEqualToString:@"点赞"])
    {
        cell.isCommentCell = NO;
    }
    return cell;
}

@end
