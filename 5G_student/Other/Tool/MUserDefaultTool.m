//
//  MUserDefaultTool.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MUserDefaultTool.h"

@implementation MUserDefaultTool

+ (void)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:object forKey:key];
    [defaults synchronize];
}

+ (id)getObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults stringForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)saveCategoryList:(NSArray *)array
{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * pathName = [path stringByAppendingString:@"/categoryList.plist"];
    [NSKeyedArchiver archiveRootObject:array toFile:pathName];
}

+ (NSArray *)getCategoryList
{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * pathName = [path stringByAppendingString:@"/categoryList.plist"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:pathName];
}

@end
