//
//  TeacherInfoTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherInfoTableViewCell.h"

@interface TeacherInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@end

@implementation TeacherInfoTableViewCell

- (void)setTeacherId:(NSString *)teacherId
{
    _teacherId = teacherId;
    
    NSDictionary *parameters = @{
        @"lecturerId": _teacherId
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/focus/status" success:^(id json) {
        if (SUCCESS) {
            if ([json[@"data"] intValue] == 1) {
                [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else
            {
                [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}

#pragma mark - Setting
- (void)setLecturerModel:(LecturerModel *)lecturerModel
{
    _lecturerModel = lecturerModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_lecturerModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.nameLabel.text = _lecturerModel.lecturerName;
    self.introduceLabel.text = _lecturerModel.introduce;
}

#pragma mark - 点击事件
- (IBAction)buttonDidClick:(UIButton *)sender
{
    if (sender.tag == 101) {
        NSString * url = @"/user/auth/user/focus/on";
        if ([sender.currentTitle isEqualToString:@"已关注"]) {
            url = @"/user/auth/user/focus/off";
        }
        NSDictionary *parameters = @{
            @"lecturerId": self.lecturerModel.id
        };
        [[MHttpTool shareInstance] postWithParameters:parameters url:url success:^(id json) {
            if (SUCCESS) {
                if ([sender.currentTitle isEqualToString:@"已关注"]) {
                    [sender setTitle:@"关注" forState:UIControlStateNormal];
                }else
                {
                    [sender setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }else
            {
                ShowErrorView
            }
        } failure:^(NSError *error) {
            MLog(@"error:%@",error);
        }];
    }
}

@end
