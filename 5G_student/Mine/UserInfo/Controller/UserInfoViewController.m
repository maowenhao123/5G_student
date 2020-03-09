//
//  UserInfoViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ChangeNickNameViewController.h"
#import "TextViewViewController.h"
#import "UserAvatarTableViewCell.h"
#import "UserInfoTableViewCell.h"
#import "HobbyPickerView.h"
#import "AreaPickerView.h"
#import "HXPhotoPicker.h"
#import "UserModel.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, ChangeNickNameViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (strong, nonatomic) UserModel *userModel;
@property (nonatomic, weak) HobbyPickerView * hobbyPickerView;
@property (nonatomic, weak) AreaPickerView * areaPickerView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"个人资料";
    [self setupUI];
    [self getUserData];
}

#pragma mark - 请求数据
- (void)getUserData
{
    NSDictionary *parameters = @{
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/ext/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        if (SUCCESS) {
            self.userModel = [UserModel mj_objectWithKeyValues:json[@"data"]];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    
    //确定
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(15, CGRectGetMaxY(self.tableView.frame), MScreenWidth - 2 * 15, 40);
    confirmButton.backgroundColor = MDefaultColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = confirmButton.height / 2;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    //选择地区
    AreaPickerView * areaPickerView = [[AreaPickerView alloc] init];
    self.areaPickerView = areaPickerView;
    __weak typeof(self) wself = self;
    areaPickerView.block = ^(NSString * _Nonnull areaStr, NSString * _Nonnull subAreaStr) {
        wself.userModel.area = [NSString stringWithFormat:@"%@ %@", areaStr, subAreaStr];
        [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    //选择爱好
    HobbyPickerView * hobbyPickerView = [[HobbyPickerView alloc] init];
    self.hobbyPickerView = hobbyPickerView;
    hobbyPickerView.block = ^(NSDictionary * categoryDic, NSDictionary * subjectDic){
        wself.userModel.hobby = [NSString stringWithFormat:@"%@ %@", categoryDic[@"categoryName"], subjectDic[@"categoryName"]];
        [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
}

- (void)confirmButtonDidClick
{
    if (MStringIsEmpty(self.userModel.headImgUrl)) {
        [MBProgressHUD showError:@"请上传头像"];
        return;
    }
    if (MStringIsEmpty(self.userModel.nickname)) {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    NSDictionary *parameters = @{
        @"headImgUrl": self.userModel.headImgUrl,
        @"nickname": self.userModel.nickname,
        @"area": self.userModel.area,
        @"hobby": self.userModel.hobby
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/ext/update" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat tableViewH = MScreenHeight - MStatusBarH - MNavBarH - MMargin;
        if (IsBangIPhone) {
            tableViewH = MScreenHeight - MStatusBarH - MNavBarH - MSafeBottomMargin - 40;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, tableViewH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (HXPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _photoManager;
}

- (UserModel *)userModel
{
    if (!_userModel) {
        _userModel = [UserModel new];
    }
    return _userModel;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserAvatarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserAvatarTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"UserAvatarTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        return cell;
    }else
    {
        UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
            cell.contentTF.userInteractionEnabled = NO;
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.titleLabel.text = @"昵称";
            cell.contentTF.placeholder = @"请输入";
            if (!MStringIsEmpty(self.userModel.nickname)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.nickname];
            }
        }else if (indexPath.section == 0 && indexPath.row == 2)
        {
            cell.titleLabel.text = @"地区";
            cell.contentTF.placeholder = @"请选择";
            if (!MStringIsEmpty(self.userModel.area)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.area];
            }
        }else if (indexPath.section == 0 && indexPath.row == 3)
        {
            cell.titleLabel.text = @"爱好";
            cell.contentTF.placeholder = @"请选择";
            if (!MStringIsEmpty(self.userModel.hobby)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.hobby];
            }
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return MCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
            HXPhotoModel * photoModel = photoList.firstObject;
            [self upLoadImageWithImage:photoModel.previewPhoto];
        } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
            MLog(@"block - 取消了");
        }];
    }else if (indexPath.row == 1)
    {
        ChangeNickNameViewController * changeNickNameVC = [[ChangeNickNameViewController alloc] init];
        changeNickNameVC.text = self.userModel.nickname;
        changeNickNameVC.delegate = self;
        [self.navigationController pushViewController:changeNickNameVC animated:YES];
    }else if (indexPath.row == 2)
    {
        [self.areaPickerView show];
    }else if (indexPath.row == 3)
    {
        [self.hobbyPickerView show];
    }
}

- (void)changeNickNameViewControllerDidConfirm:(NSString *)text
{
    self.userModel.nickname = text;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)upLoadImageWithImage:(UIImage *)image
{
    [[MHttpTool shareInstance] uploadWithImage:image currentIndex:-1 totalCount:1 Success:^(id json) {
        if (SUCCESS) {
            self.userModel.headImgUrl = json[@"data"];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            ShowErrorView
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
    }];
}

@end
