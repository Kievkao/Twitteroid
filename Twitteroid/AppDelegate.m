//
//  AppDelegate.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import "TWRCoreDataDAO.h"
#import "TWRLoginWireframe.h"
#import "TWRCredentialsStore.h"
#import "STTwitterAPI.h"

@interface AppDelegate ()

@property (strong, nonatomic) TWRLoginWireframe *loginWireframe;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupKeychain];
    [self setupAppearance];

    [self presentLoginScreen];

    return YES;
}

- (void)presentLoginScreen {
    TWRCredentialsStore *credentialsStore = [TWRCredentialsStore new];

    STTwitterAPI *twitterAPI = nil;
    BOOL isUserLogged = credentialsStore.token && credentialsStore.tokenSecret;

    if (isUserLogged) {
        twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:credentialsStore.twitterAPIKey consumerSecret:credentialsStore.twitterAPISecret oauthToken:credentialsStore.token oauthTokenSecret:credentialsStore.tokenSecret];
    } else {
        twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:credentialsStore.twitterAPIKey consumerSecret:credentialsStore.twitterAPISecret];
    }

    self.loginWireframe = [[TWRLoginWireframe alloc] initWithTwitterAPI:twitterAPI];

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
    [[TWRCoreDataDAO sharedInstance] saveContext];
}

@end
