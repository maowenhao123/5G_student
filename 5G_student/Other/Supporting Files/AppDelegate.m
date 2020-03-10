//
//  AppDelegate.m
//  5G_student
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "TXLiteAVSDK_Professional/TXLiveBase.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TXLiveBase setConsoleEnabled:YES];
    [TXLiveBase setAppID:TXLiveAppID];
    
    //环信注册
    [self registerForRemoteNotificationsWithApplication:application];
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"duorou_dev";
#else
    apnsCertName = @"duorou_dis";
#endif
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
    options.apnsCertName = apnsCertName;
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        MLog(@"%@", error.errorDescription);
    }
    
    [Tool loginImAccount];

    return YES;
}

- (void)registerForRemoteNotificationsWithApplication:(UIApplication *)application
{
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options
{
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
