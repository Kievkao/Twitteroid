//
//  TWRAssembly.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/9/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAssembly.h"

#import "AppDelegate.h"
#import "STTwitterAPI.h"
#import "TWRCredentialsStore.h"
#import "TWRTwitterLoginService.h"
#import "TWRTwitterFeedService.h"
#import "TWRTweetParser.h"
#import "TWRLoginInteractor.h"
#import "TWRLoginPresenter.h"
#import "TWRLoginWireframe.h"
#import "TWRLoginWebWireframe.h"
#import "TWRFeedWireframe.h"

@implementation TWRAssembly

- (AppDelegate *)appDelegate {
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(loginWireframe) with:[self loginWireframe]];
    }];
}

#pragma mark - Wireframes

- (TWRLoginWireframe *)loginWireframe {
    return [TyphoonDefinition withClass:[TWRLoginWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(twitterAPI) with:[self twitterAPI]];
        [definition injectProperty:@selector(loginService) with:[self loginService]];
        [definition injectProperty:@selector(webLoginWireframe) with:[self webLoginWireframe]];
        [definition injectProperty:@selector(feedWireframe) with:[self feedWireframe]];
    }];
}

- (TWRLoginWebWireframe *)webLoginWireframe {
    return [TyphoonDefinition withClass:[TWRLoginWebWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(loginService) with:[self loginService]];
    }];
}

- (TWRFeedWireframe *)feedWireframe {
    return [TyphoonDefinition withClass:[TWRFeedWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(feedService) with:[self feedService]];
    }];
}

#pragma mark - Services

//TWRTwitterFeedService *twitterFeedService = [[TWRTwitterFeedService alloc] initWithTwitterAPI:self.twitterAPI tweetParser:[TWRTweetParser new]];

- (TWRTwitterFeedService *)feedService {
    return [TyphoonDefinition withClass:[TWRTwitterFeedService class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(twitterAPI) with:[self twitterAPI]];
        [definition injectProperty:@selector(tweetParser) with:[self tweetParser]];
    }];
}

- (TWRTweetParser *)tweetParser {
    return [TyphoonDefinition withClass:[TWRTweetParser class]];
}

- (TWRTwitterLoginService *)loginService {
    return [TyphoonDefinition withClass:[TWRTwitterLoginService class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(twitterAPI) with:[self twitterAPI]];
        [definition injectProperty:@selector(credentialsStore) with:[self credentialsStore]];
    }];
}

- (STTwitterAPI *)twitterAPI {
    return [TyphoonDefinition withClass:[STTwitterAPI class] configuration:^(TyphoonDefinition* definition) {

            TWRCredentialsStore *store = [TWRCredentialsStore new];
            BOOL isUserLogged = store.token && store.tokenSecret;
            SEL initializer = isUserLogged ? @selector(twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:) : @selector(twitterAPIWithOAuthConsumerKey:consumerSecret:);

            [definition useInitializer:initializer parameters:^(TyphoonMethod *initializer) {

                [initializer injectParameterWith:store.twitterAPIKey];
                [initializer injectParameterWith:store.twitterAPISecret];

                if (isUserLogged) {
                    [initializer injectParameterWith:store.token];
                    [initializer injectParameterWith:store.tokenSecret];
                }
            }];
        }];
}

- (TWRCredentialsStore *)credentialsStore {
    return [TyphoonDefinition withClass:[TWRCredentialsStore class]];
}

@end
