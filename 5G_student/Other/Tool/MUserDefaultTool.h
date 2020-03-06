//
//  MUserDefaultTool.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUserDefaultTool : NSObject

+ (void)saveObject:(id)object forKey:(NSString *)key;//保存键值
+ (id)getObjectForKey:(NSString *)key;//取出值

+ (void)saveCategoryList:(NSArray *)array;
+ (NSArray *)getCategoryList;

@end

NS_ASSUME_NONNULL_END
