//
//  TeacherShowCollectionView.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherShowCollectionView.h"
#import "TeacherShowCollectionViewCell.h"

@interface TeacherShowCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

NSString * const TeacherShowCollectionViewCellId = @"TeacherShowCollectionViewCellId";

@implementation TeacherShowCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.collectionView.frame = self.bounds;
}

#pragma mark - Setting
- (void)setLecturerModel:(LecturerModel *)lecturerModel
{
    _lecturerModel = lecturerModel;
    
    [self.dataArray removeAllObjects];
    NSArray *picturesUrls = [_lecturerModel.pictures componentsSeparatedByString:@";"];
    for (NSString * picturesUrl in picturesUrls) {
        NSDictionary * dataDic = @{
            @"type": @"pic",
            @"data": picturesUrl
        };
        [self.dataArray addObject:dataDic];
    }
    NSArray *videoNos = [_lecturerModel.videos componentsSeparatedByString:@";"];
    for (NSString * videoNo in videoNos) {
        NSDictionary * dataDic = @{
            @"type": @"video",
            @"data": videoNo
        };
        [self.dataArray addObject:dataDic];
    }
    [self.collectionView reloadData];
}

#pragma mark - Getting
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(MMargin, MMargin, MMargin, MMargin);
        layout.minimumLineSpacing = MMargin;
        layout.minimumInteritemSpacing = MMargin;
        CGFloat itemW = (MScreenWidth - 3 * MMargin) / 2;
        layout.itemSize = CGSizeMake(itemW, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 130) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[TeacherShowCollectionViewCell class] forCellWithReuseIdentifier:TeacherShowCollectionViewCellId];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherShowCollectionViewCellId forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}

@end
