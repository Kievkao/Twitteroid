//
//  TWRUserProfile.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/29/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRUserProfile : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNickname;
@property (nonatomic, readonly, strong) UIImage *userAvatar;

- (void)setUserAvatarByURL:(NSURL *)url;

@end
