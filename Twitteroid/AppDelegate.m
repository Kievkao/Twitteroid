//
//  AppDelegate.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import "TWRStorageManagerProtocol.h"
#import "TWRLoginWireframe.h"
#import "TWRCredentialsStore.h"
#import "STTwitterAPI.h"

@interface AppDelegate ()

@property (strong, nonatomic) TWRLoginWireframe *loginWireframe;
@property (strong, nonatomic) id<TWRStorageManagerProtocol> storageManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupKeychain];
    [self setupAppearance];

    [self presentLoginScreen];

    return YES;
}

- (void)presentLoginScreen {

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[self.loginWireframe createLoginViewController]];
    navigationController.navigationBarHidden = YES;

    self.window.rootViewController = navigationController;
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
    [self.storageManager saveContext];
}

@end
