//
//  TWRUserProfile.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/13/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRUserProfile : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNickname;
@property (nonatomic, strong) UIImage *userAvatar;

@end
