//
//  TWRLoginWebPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginWebPresenter.h"

@interface TWRLoginWebPresenter()

@property (strong, nonatomic) NSURLRequest *request;

@end

@implementation TWRLoginWebPresenter

- (instancetype)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}

- (void)webLoginDidSuccess {
    [self.wireframe notifyLoginSuccess];
}

- (void)webLoginDidFinishWithError:(NSError *)error {
    [self.wireframe notifyLoginError:error];
}

- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request {
    return [self.interactor shouldStartLoadRequest:request];
}

- (void)handleViewDidLoad {
    [self.view loadURLRequest:self.request];
}

- (void)handleCancelAction {
    [self.wireframe dismissLoginWebScreen];
}

@end
