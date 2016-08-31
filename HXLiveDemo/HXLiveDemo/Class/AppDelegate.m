//
//  AppDelegate.m
//  HXLiveDemo
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 JunLiu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//+ (AppDelegate *)getAppDelegate
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appKey = @"tocs#hxlivedemo";
    
    EMOptions *options = [EMOptions optionsWithAppkey:appKey];
    //    options.apnsCertName = @"";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    //初始化EaseUI
//    [[EaseSDKHelper shareHelper] easemobApplication:application
//                      didFinishLaunchingWithOptions:launchOptions
//                                             appkey:@"douser#istore"
//                                       apnsCertName:@"istore_dev"
//                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appKey apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
      [[EMClient sharedClient]applicationWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
