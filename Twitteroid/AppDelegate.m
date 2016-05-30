//
//  AppDelegate.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import "TWRCoreDataManager.h"
#import "TWRLoginWireframe.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupKeychain];
    [self setupAppearance];

    TWRLoginWireframe *loginWireframe = [TWRLoginWireframe new];

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[loginWireframe createLoginViewController]];
    navigationController.navigationBarHidden = YES;

    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)setupKeychain {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
}

- (void)setupAppearance {
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor navBarColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor navBarTitleColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor navBarTitleColor],
                                                           NSFontAttributeName : [UIFont navBarTitleFont]}];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor navBarTitleColor]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[TWRCoreDataManager sharedInstance] saveContext];
}

@end
