//
//  TWRSettingsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsVC.h"

@interface TWRSettingsVC ()

@end

@implementation TWRSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (NSString *)rootNavControllerIdentifier {
    return @"SettingsNavC";
}

- (IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
