//
//  SetupViewController.m
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "SetupViewController.h"
#import "MemberListViewController.h"
#import "ViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController
@synthesize pUserIDField;
@synthesize pRootViewController;
@synthesize pPassField;

//뷰 컨트롤러 생성후 초기화할때 호출되는 콜백 함수
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"로그인";
        
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(IBAction)LogIn{
    [self.pUserIDField resignFirstResponder];
    [self.pPassField resignFirstResponder]; // 키보드 창 닫기
    [pRootViewController LogIn:pUserIDField.text PassWord:pPassField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
