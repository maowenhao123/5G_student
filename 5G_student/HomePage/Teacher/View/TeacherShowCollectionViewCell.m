//
//  TeacherShowCollectionViewCell.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherShowCollectionViewCell.h"

@interface TeacherShowCollectionViewCell ()

@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UIImageView * playImageView;

@end

@implementation TeacherShowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.showImageView];
        [self addSubview:self.playImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.showImageView.frame = self.bounds;
    self.playImageView.center = CGPointMake(self.width / 2, self.height / 2);
}

#pragma mark - Getting
- (UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = MPlaceholderColor;
    }
    return _showImageView;
}

- (UIImageView *)playImageView
{
    if (!_playImageView) {
        CGFloat playImageViewWH = 30;
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playImageViewWH, playImageViewWH)];
        _playImageView.image = [UIImage imageNamed:@"video_play_icon"];
    }
    return _playImageView;
}

#pragma mark - Setting
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    if ([_dataDic[@"type"] isEqualToString:@"pic"]) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"data"]] placeholderImage:[UIImage imageNamed:@""]];
        self.playImageView.hidden = YES;
    }else if ([_dataDic[@"type"] isEqualToString:@"video"])
    {
        [self getVideoUrlWithVideoNo:_dataDic[@"data"]];
        self.playImageView.hidden = NO;
    }
}

#pragma mark - 获取视频URL
- (void)getVideoUrlWithVideoNo:(NSString *)videoNo
{
    NSDictionary *parameters = @{
        @"videoNo": videoNo
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/video" success:^(id json) {
        if (SUCCESS) {
            self.showImageView.image = [Tool getVideoPreViewImage:[NSURL URLWithString:json[@"data"]]];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        
    }];
}

@end
