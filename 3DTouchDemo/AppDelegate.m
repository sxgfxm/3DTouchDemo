//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by 宋晓光 on 20/10/2016.
//  Copyright © 2016 Light. All rights reserved.
//

#import "AppDelegate.h"

#import "Item1ViewController.h"
#import "Item2ViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@property(nonatomic, strong) UINavigationController *mainNav;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  //  主界面入口
  ViewController *vc = [[ViewController alloc] init];
  self.mainNav = [[UINavigationController alloc] initWithRootViewController:vc];
  self.window.rootViewController = self.mainNav;

  //  创建快捷访问Items
  UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon
      iconWithType:UIApplicationShortcutIconTypeTask];
  UIApplicationShortcutItem *item1 =
      [[UIApplicationShortcutItem alloc] initWithType:@"item1"
                                       localizedTitle:@"item1"
                                    localizedSubtitle:@"1"
                                                 icon:icon1
                                             userInfo:nil];
  UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon
      iconWithType:UIApplicationShortcutIconTypeMail];
  UIApplicationShortcutItem *item2 =
      [[UIApplicationShortcutItem alloc] initWithType:@"item2"
                                       localizedTitle:@"item2"
                                    localizedSubtitle:@"2"
                                                 icon:icon2
                                             userInfo:nil];
  //  添加快捷访问Items
  application.shortcutItems = @[ item1, item2 ];
  return YES;
}

- (void)application:(UIApplication *)application
    performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
               completionHandler:(void (^)(BOOL))completionHandler {
  //  响应Item对应的操作，跳转至对应controller
  if ([shortcutItem.type isEqualToString:@"item1"]) {
    Item1ViewController *vc = [[Item1ViewController alloc] init];
    [self.mainNav pushViewController:vc animated:YES];
  }
  if ([shortcutItem.type isEqualToString:@"item2"]) {
    Item2ViewController *vc = [[Item2ViewController alloc] init];
    [self.mainNav pushViewController:vc animated:YES];
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate
  // graphics rendering callbacks. Games should use this method to pause the
  // game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
