//
//  ChangeNickNameViewController.h
//  5G_student
//
//  Created by dahe on 2020/3/6.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeNickNameViewControllerDelegate <NSObject>

- (void)changeNickNameViewControllerDidConfirm:(NSString *)text;

@end

@interface ChangeNickNameViewController : BaseViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
