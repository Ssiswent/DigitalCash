//
//  FindRecommendFocusCell.m
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/1.
//

#import "FindRecommendFocusCell.h"

#import "UserModel.h"

#import "FindRecommendCollctionCell.h"

@interface FindRecommendFocusCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *recommendUsersArray;


@end

@implementation FindRecommendFocusCell

NSString *FindRecommendCollctionCellID = @"FindRecommendCollctionCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    cell.recommendUserModel = self.recommendUsersArray[indexPath.row];
    return cell;
}


#pragma mark - API

-(void)getRecommendUsers{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/getRecommandUserList" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.recommendUsersArray = [MTLJSONAdapter modelsOfClass:[UserModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.collectionView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"请求推荐关注失败" afterHideTime:DELAYTiME];
    }];
}

@end
