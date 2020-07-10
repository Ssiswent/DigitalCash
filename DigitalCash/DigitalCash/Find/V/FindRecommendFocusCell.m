//
//  FindRecommendFocusCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import "FindRecommendFocusCell.h"

#import "UserModel.h"

#import "FindRecommendCollctionCell.h"

#import "LoginVC.h"

@interface FindRecommendFocusCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *recommendUsersArray;

@property (nonatomic, assign) BOOL isFocus;
@property (strong, nonatomic) NSNumber *followerId;
@property (assign, nonatomic) NSInteger focusIndex;

@property (strong, nonatomic) NSNumber *userId;

@end

@implementation FindRecommendFocusCell

NSString *FindRecommendCollctionCellID = @"FindRecommendCollctionCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self getUserDefault];
    [self setCollectonView];
    [self getRecommendUsers];
}

- (void)setCollectonView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    CGFloat itemW = (SCREEN_WIDTH - 20) / 2;
    //    CGFloat itemH = itemW * 256 / 180;
    layout.itemSize = CGSizeMake(110, 125);
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    //    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 7.5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRecommendCollctionCell class]) bundle:nil] forCellWithReuseIdentifier:FindRecommendCollctionCellID];
}

- (IBAction)closeBtnClicked:(id)sender {
    WEAKSELF
    if(weakSelf.closeBlock)
    {
        weakSelf.closeBlock();
    }
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendUsersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FindRecommendCollctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FindRecommendCollctionCellID forIndexPath:indexPath];
    
    WEAKSELF
    if(self.recommendUsersArray.count > 0)
    {
        UserModel *recommendUserModel = self.recommendUsersArray[indexPath.row];
        
        cell.userId = _userId;
        cell.recommendUserModel = recommendUserModel;
        
        //关注
        cell.focusBtnClickedBlock = ^(BOOL isFocus) {
            [weakSelf getUserDefault];
            if(weakSelf.userId != nil)
            {
                weakSelf.followerId = recommendUserModel.userId;
                weakSelf.focusIndex = indexPath.row;
                weakSelf.isFocus = isFocus;
                [weakSelf focusUser];
            }
            else
            {
                LoginVC *loginVC = [LoginVC new];
                loginVC.loginVCDidGetUserBlock = ^{
                    [weakSelf getUserDefault];
                    [Toast makeText:weakSelf Message:@"登录成功" afterHideTime:DELAYTiME];
                };
                [[weakSelf getControllerFromView:weakSelf] presentViewController:loginVC animated:YES completion:nil];
                [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
            }
        };
    }
    return cell;
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (UIViewController *)getControllerFromView:(UIView *)view {
    // 遍历响应者链。返回第一个找到视图控制器
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    // 如果没有找到则返回nil
    return nil;
}


#pragma mark - API

-(void)getRecommendUsers{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/getRecommandUserList" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.recommendUsersArray = [MTLJSONAdapter modelsOfClass:[UserModel class] fromJSONArray:result[@"data"] error:&error];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"请求推荐关注失败" afterHideTime:DELAYTiME];
    }];
}

- (void)focusUser{
    WEAKSELF
    NSString *isFocus;
    if(weakSelf.isFocus)
    {
        isFocus = @"true";
    }
    else
    {
        isFocus = @"false";
    }
    
    NSDictionary *dic = @{
        @"userId":_userId,
        @"followerId":_followerId,
        @"isFollow":isFocus
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/follow/follow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:weakSelf.focusIndex inSection:0]];
        [weakSelf.collectionView reloadItemsAtIndexPaths:indexPaths];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"关注失败" afterHideTime:DELAYTiME];
    }];
}

@end
