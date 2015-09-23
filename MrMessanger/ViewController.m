//
//  ViewController.m
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "ViewController.h"
#import "MemberListViewController.h"
#import "SetupViewController.h"


@interface ViewController ()

@end


@implementation ViewController

@synthesize pMemberListViewController;
@synthesize pSetupViewController;
@synthesize UserID;

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    self.pMemberListViewController = [[MemberListViewController alloc]initWithNibName:@"MemberListViewController" bundle:nil];
    self.pSetupViewController = [[SetupViewController alloc]initWithNibName:@"SetupViewController" bundle:nil];
    
    self.viewControllers = @[self.pSetupViewController,self.pMemberListViewController];
    self.delegate = self;
    pSetupViewController.pRootViewController = self;
    [super viewDidLoad];
}

-(void)LogIn:(NSString *)pUserID PassWord:(NSString *)pPass{
    [pMemberListViewController ServerConnect:pUserID PassWord:pPass];
}
@end
