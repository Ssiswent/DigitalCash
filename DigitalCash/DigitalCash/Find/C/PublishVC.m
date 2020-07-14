//
//  PublishVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/18.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "PublishVC.h"

#import "UITextView+WZB.h"

#import <TZImagePickerController.h>

#import "LoginVC.h"

@interface PublishVC ()<UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, YPNavigationBarConfigureStyle>


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (copy, nonatomic)  NSString *saveURL;

@property (nonatomic, strong)NSNumber *userId;

@property (nonatomic, assign)BOOL selectedImg;


@end

@implementation PublishVC

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self getUserDefault];
}

- (void)initialSetUp
{
    self.title = @"发布动态";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"arrow_down"] style:0 target:self action:@selector(downBtnClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"publish_btn"] style:0 target:self action:@selector(publishBtnClicked)];
    
    _textView.wzb_placeholder = @"分享新鲜事...";
    _textView.wzb_placeholderColor = [UIColor colorWithHexString:@"#999999"];
    
    _selectBtn.layer.cornerRadius = 5;
    _selectBtn.layer.masksToBounds = YES;
    
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)downBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publishBtnClicked
{
    if(_userId != nil)
    {
        if(_textView.text.length != 0)
        {
            [self publish];
        }
        else
        {
            [Toast makeText:self.view Message:@"请输入动态内容" afterHideTime:DELAYTiME];
        }
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        WEAKSELF
        loginVC.loginVCDidGetUserBlock = ^{
            [self getUserDefault];
            [Toast makeText:weakSelf.view Message:@"登录成功" afterHideTime:DELAYTiME];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先登录" afterHideTime:DELAYTiME];
    }
}

- (IBAction)selectBtnClicked:(id)sender {
    [self selectImg];
}

- (void)selectImg
{
    //UIAlertControllerStyleAlert
    //UIAlertControllerStyleActionSheet
    //1.创建控制器
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //2.创建按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
        [self pushTZImagePickerController];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
    }];
    
    UIColor *alertTextColor = [UIColor colorWithHexString:@"#293AFF"];
    [action1 setValue:alertTextColor forKey:@"titleTextColor"];
    [action2 setValue:alertTextColor forKey:@"titleTextColor"];
    [action3 setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"titleTextColor"];
    
    
    //3.添加按钮
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    
    //4.显示弹窗(相当于show)
    //这种方法，开头必须是控制器
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

//获取照片
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectBtn setImage:photo forState:UIControlStateNormal];
    [self uploadImg:photo];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.naviBgColor = [UIColor colorWithHexString:@"#F88945"];
    imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.isSelectOriginalPhoto = YES;
//    imagePickerVc.needShowStatusBar = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    
    //     imagePickerVc.photoWidth = 1600;
    //     imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    //     imagePickerVc.minImagesCount = 3;
    //     imagePickerVc.alwaysEnableDoneBtn = YES;
    
    //裁剪
    imagePickerVc.allowCrop = YES;
    //圆形裁剪
//    imagePickerVc.needCircleCrop = YES;
    //    // 设置竖屏下的裁剪尺寸
    CGFloat width = 345;
    CGFloat height = 200;
    CGFloat x = (SCREEN_WIDTH - width) / 2;
    CGFloat y = (SCREEN_HEIGHT - height) / 2;
    imagePickerVc.cropRect = CGRectMake(x, y, width, height);
    imagePickerVc.scaleAspectFillCrop = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    WEAKSELF
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *selectedImg = photos[0];
        [weakSelf.selectBtn setImage:selectedImg forState:UIControlStateNormal];
        [self uploadImg:selectedImg];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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

#pragma mark - API

//上传图片:resopnse是地址
-(void)uploadImg:(UIImage *)img{
    WEAKSELF
    NSDictionary *dict = @{
        @"file" : img
    };
    [NetworkTool.shared postReturnString:@"http://image.yysc.online/upload" fileName:@"testImg" image:img viewcontroller:self params:dict success:^(id _Nonnull resopnse) {
        weakSelf.saveURL = resopnse;
        weakSelf.selectedImg = YES;
    } failture:^(NSError * _Nonnull error) {
        [Toast makeText:weakSelf.view Message:@"上传图片失败" afterHideTime:DELAYTiME];
    }];
}

- (void)publish{
    WEAKSELF
    NSDictionary *dict;
    if(_selectedImg)
    {
        dict = @{
            @"userId" : _userId,
            @"content" : _textView.text,
            @"picture" : self.saveURL
        };
    }
    else
    {
        dict = @{
            @"userId" : _userId,
            @"content" : _textView.text,
        };
    }
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/publishTalk" parameters:nil queryParams:dict Header:nil success:^(BOOL success, id result) {
    [self dismissViewControllerAnimated:YES completion:nil];
        [Toast makeText:weakSelf.view Message:@"发布动态成功" afterHideTime:DELAYTiME];
    } failure:^(BOOL failuer, NSError *error) {
        [Toast makeText:weakSelf.view Message:@"发布动态失败" afterHideTime:DELAYTiME];
        NSLog(@"%@",error);
    }];
}

@end
