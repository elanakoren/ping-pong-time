//
//  AppDelegate.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "APIClient.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:@"counter"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *vc = [[ViewController alloc] init];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000"]];
    APIClient *apiClient = [[APIClient alloc] initWithOperationManager:operationManager];
    UIViewController *vc2 = [[SettingsViewController alloc] initWithAPIClient:apiClient];
    
    UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    UITabBarItem* theItem2 = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:0];
    
    vc.tabBarItem = theItem;
    vc2.tabBarItem = theItem2;
    
    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    NSArray * controllers = [NSArray arrayWithObjects:vc,vc2, nil];
    tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    NSLog(@"DidFinishLaunching");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
