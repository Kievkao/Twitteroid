//
//  TWRUserProfile.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/29/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRUserProfile.h"
#import "SDWebImageDownloader.h"

static NSString *const kUserNameKey = @"TWRUserNameKey";
static NSString *const kUserNicknameKey = @"TWRUserNicknameKey";
static NSString *const kUserIDKey = @"TWRUserIDKey";
static NSString *const kUserAvatarKey = @"TWRUserAvatarKey";

@interface TWRUserProfile()

@end

@implementation TWRUserProfile
@synthesize userNickname = _userNickname;
@synthesize userName = _userName;
@synthesize userID = _userID;
@synthesize userAvatar = _userAvatar;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - User Nickname
- (void)setUserNickname:(NSString *)userNickname {
    _userNickname = userNickname;
    [[NSUserDefaults standardUserDefaults] setObject:userNickname forKey:kUserNicknameKey];
}

- (NSString *)userNickname {
    
    if (!_userNickname) {
        _userNickname = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNicknameKey];
    }
    
    return _userNickname;
}

#pragma mark - User Name
- (void)setUserName:(NSString *)userName {
    _userName = userName;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameKey];
}

- (NSString *)userName {
    
    if (!_userName) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    }
    
    return _userName;
}

#pragma mark - User ID
- (void)setUserID:(NSString *)userID {
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserIDKey];
}

- (NSString *)userID {
    
    if (!_userID) {
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIDKey];
    }
    
    return _userID;
}

#pragma mark - User Avatar
- (void)setUserAvatarByURL:(NSURL *)url {
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            _userAvatar = image;
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:kUserAvatarKey];
        }
    }];
}

- (UIImage *)userAvatar {
    
    if (!_userAvatar) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAvatarKey];
        _userAvatar = [UIImage imageWithData:imageData];
    }
    
    return _userAvatar;
}

@end
