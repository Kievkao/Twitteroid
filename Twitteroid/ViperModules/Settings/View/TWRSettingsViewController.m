//
//  TWRSettingsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsViewController.h"
#import "BHRRoundedImageView.h"

typedef enum : NSUInteger {
    TWRAutoSettingsSection,
    TWRManualSettingsSection,
} TWRSettingsSection;

@interface TWRSettingsViewController ()

@property (weak, nonatomic) IBOutlet BHRRoundedImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;

@end

@implementation TWRSettingsViewController

+ (NSString *)identifier {
    return @"SettingsNavC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userNameLabel.text = self.userName;
    self.userNicknameLabel.text = [NSString stringWithFormat:@"@%@", self.userNickname];
    self.userAvatarImageView.image = self.userAvatar;
}

- (IBAction)doneClicked:(id)sender {
    [self.eventHandler handleDoneAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TWRAutoSettingsSection:
            [self.eventHandler handleAutoSettingsAction];
            break;

        case TWRManualSettingsSection:
            [self.eventHandler handleManualSettingsAction];
            break;

        default:
            break;
    }
}

@end
