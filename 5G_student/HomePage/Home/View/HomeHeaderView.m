//
//  HomeHeaderView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/21.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "HomeHeaderView.h"
#import "BaseWebViewController.h"
#import "CourseCategoryViewController.h"
#import "SDCycleScrollView.h"
#import "MUserDefaultTool.h"
#import "UIButton+WebCache.h"

@interface HomeHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, copy) NSArray *advList;
@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self getAdData];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getAdData
{
    NSDictionary *parameters = @{
        @"location": @(1)
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/api/adv/list" success:^(id json) {
        if (SUCCESS) {
            NSMutableArray * imageURLStringsGroup = [NSMutableArray array];
            for (NSDictionary * advDic in json[@"data"][@"advList"]) {
//                [imageURLStringsGroup addObject:advDic[@"image"]];
                [imageURLStringsGroup addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1582446750980&di=9c485f3e949e06b8361911c7daef7dd9&imgtype=0&src=http%3A%2F%2Fmedia-cdn.tripadvisor.com%2Fmedia%2Fphoto-s%2F03%2Ff8%2F81%2F70%2Ftup-island.jpg"];
            }
            self.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup;
            self.advList = json[@"data"][@"advList"];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.cycleScrollView];
    
    NSArray * categoryArray = [MUserDefaultTool getCategoryList];
    CGFloat categoryButtonW = (MScreenWidth - 4 * MMargin) / 3;
    CGFloat categoryButtonH = 40;
    for (int i = 0; i < categoryArray.count; i++) {
        if (i >= 3) {
            return;
        }
        NSDictionary *categoryDic = categoryArray[i];
        UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryButton.tag = i;
        categoryButton.frame = CGRectMake(MMargin + (MMargin + categoryButtonW) * i, CGRectGetMaxY(self.cycleScrollView.frame) + 10, categoryButtonW, categoryButtonH);
        [categoryButton setTitle:categoryDic[@"categoryName"] forState:UIControlStateNormal];
        [categoryButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        [categoryButton sd_setImageWithURL:[NSURL URLWithString:categoryDic[@"categoryImage"]] forState:UIControlStateNormal];
        categoryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        categoryButton.layer.cornerRadius = 2;
        categoryButton.layer.borderWidth = 1;
        categoryButton.layer.borderColor = MGrayLineColor.CGColor;
        [categoryButton addTarget:self action:@selector(categoryButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:categoryButton];
    }
}

- (void)categoryButtonDidClick:(UIButton *)button
{
    CourseCategoryViewController * courseCategoryVC = [[CourseCategoryViewController alloc] init];
    NSArray * categoryArray = [MUserDefaultTool getCategoryList];
    courseCategoryVC.categoryDic = categoryArray[button.tag];
    courseCategoryVC.courseType = -1;
    [self.viewController.navigationController pushViewController:courseCategoryVC animated:YES];
}

#pragma mark - Getting
- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MScreenWidth, 200) delegate:self placeholderImage:nil];
    }
    return _cycleScrollView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary * advDic = self.advList[index];
    BaseWebViewController * webVC = [[BaseWebViewController alloc] initWithWeb:advDic[@"data"]];
    [self.viewController.navigationController pushViewController:webVC animated:YES];
}

@end
