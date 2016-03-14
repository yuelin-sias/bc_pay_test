//
//  AppDelegate.m
//  bc_pay_test
//
//  Created by yl on 16/2/29.
//  Copyright © 2016年 yl. All rights reserved.
//

#import "AppDelegate.h"
#import "BeeCloud.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initBeeCloud];
    return YES;
}



- (void)initBeeCloud {
    //[BeeCloud initWithAppID:@"30bd43f5-067f-42f5-9b6c-a3a61aeaf379" andAppSecret:@"c9d63bc4-042d-4313-a198-cd0b68c035a0"];
    
    [BeeCloud initWithAppID:@"ffbaa421-0410-40df-a9b6-cd03a7864a21" andAppSecret:@"6f6f80e2-5f4f-4334-8ef8-7e8e9fc8e26b" sandbox:NO];
    
    
    [BeeCloud initWeChatPay:@"wxe22446c371987284"];
    
    
    //初始化PayPal
    [BeeCloud initPayPal:@"AZ1v_K7ZtHTJc4gPX6lU2Rem1817G3tHJP_V2-y4_2DwhRG6NyhmY9S3x9aj94en7yAZg9O_4ranPVqb"
                  secret:@"ENGTfsV_8lVY3Gyh1GF7NX1MVjQ1C8oQhM-Jr3CA6Jx3S1SsV25zcRTlllK_r5R6PbPqVxE0ZszNyjn6"
                 sandbox:NO];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

//iOS9之后官方推荐用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"options %@", options);
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
