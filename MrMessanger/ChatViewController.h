//
//  ChatViewController.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetWorkController;
@interface ChatViewController : UIViewController <UITextViewDelegate>

//대화내용 테이블
@property(weak,nonatomic) IBOutlet UITableView *pChatListView;
//대화내용 입력
@property(weak,nonatomic) IBOutlet UITextView *pTextView;
//도움말
@property(weak,nonatomic) IBOutlet UIView *pBackView;
@property(strong,nonatomic) UIButton *pButton;
@property(strong,retain) NetWorkController *pNetWorkController;
-(IBAction)sendText;
-(IBAction)CloseClick;

@end
