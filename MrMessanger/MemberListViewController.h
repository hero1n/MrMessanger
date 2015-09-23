//
//  MemberListViewController.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatViewController;
@class NetWorkController;
@interface MemberListViewController : UIViewController{
    ChatViewController *pChatViewController;
    NetWorkController *pNetWorkController;
}

-(void)ChatViewShow; // 일대일 대화 화면
-(void)ServerConnect:(NSString *)pUserID PassWord:(NSString *)pPass; //서버 로그인

@property(weak,nonatomic) IBOutlet UITableView *pListView;
@property(strong,nonatomic) NetWorkController *pNetWorkController;
@property(strong,nonatomic) ChatViewController *pChatViewController;

@end
