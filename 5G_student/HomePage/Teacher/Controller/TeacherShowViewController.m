//
//  TeacherShowViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherShowViewController.h"
#import "TeacherShowCollectionView.h"

@interface TeacherShowViewController ()

@property (nonatomic, strong) TeacherShowCollectionView *teacherShowCollectionView;

@end

@implementation TeacherShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"才艺展示";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.teacherShowCollectionView];
    self.teacherShowCollectionView.lecturerModel = self.lecturerModel;
}

#pragma mark - Getting
- (TeacherShowCollectionView *)teacherShowCollectionView
{
    if (!_teacherShowCollectionView) {
         _teacherShowCollectionView = [[TeacherShowCollectionView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
    }
    return _teacherShowCollectionView;
}

@end
