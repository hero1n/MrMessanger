//
//  SetupViewController.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface SetupViewController : UIViewController

-(IBAction)LogIn;

@property(weak,nonatomic) IBOutlet UITextField *pUserIDField;
@property(weak,nonatomic) IBOutlet UITextField *pPassField;
@property(strong,nonatomic) ViewController *pRootViewController;
@end
