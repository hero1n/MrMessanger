//
//  ViewController.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberListViewController;
@class SetupViewController;

@interface ViewController : UITabBarController < UITabBarControllerDelegate >

-(void)LogIn:(NSString *)pUserID PassWord:(NSString *)pPass;

@property(strong,nonatomic) MemberListViewController *pMemberListViewController;
@property(strong,nonatomic) SetupViewController *pSetupViewController;
@property(strong,nonatomic) NSString *UserID;

@end

