//
//  TeacherShowCollectionView.h
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherShowCollectionView : UIView

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) LecturerModel *lecturerModel;

@end

NS_ASSUME_NONNULL_END
