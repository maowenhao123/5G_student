//
//  TextViewViewController.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TextViewViewControllerDelegate <NSObject>

- (void)textViewViewControllerDidConfirm:(NSString *)text;

@end

@interface TextViewViewController : BaseViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
