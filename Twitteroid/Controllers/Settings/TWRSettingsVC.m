//
//  TWRSettingsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsVC.h"
#import "TWRTwitterAPIManager.h"
#import "TWRTwitterAPIManager+TWRLogin.h"
#import "BHRRoundedImageView.h"
#import "TWRUserProfile.h"

@interface TWRSettingsVC ()

@property (weak, nonatomic) IBOutlet BHRRoundedImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;

@end

@implementation TWRSettingsVC

+ (NSString *)rootNavControllerIdentifier {
    return @"SettingsNavC";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNameLabel.text = [[TWRUserProfile sharedInstance] userName];
    self.userNicknameLabel.text = [NSString stringWithFormat:@"@%@",[[TWRUserProfile sharedInstance] userNickname]];
    self.userAvatarImageView.image = [[TWRUserProfile sharedInstance] userAvatar];
}

- (IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
