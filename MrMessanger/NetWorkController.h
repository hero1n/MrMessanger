//
//  NetWorkController.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 11..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberListViewController;
@class ChatViewController;

@interface NetWorkController : UIViewController{
    NSString *pMyUserID;
    NSString *pMyPassword;
    NSMutableArray *pMemberListdata; //회원 정보
    NSMutableArray *pChatData; //메시지 정보
    
    MemberListViewController *pMemberListViewController;
    ChatViewController *pChatViewController;
    CFSocketRef pSocket; // 소켓 참조 변수
    CFRunLoopSourceRef pRunSource; // 소켓 통신시 이벤트가 발생할 경우 콜백함수를 호출하기 위한 RunLoopSource 참조 변수
    NSMutableData *pReturnData; // 수신된 메시지를 보관하는 변수
    NetWorkController *pNetWorkController;
    int pStauts; // 현재 진행 상태를 담고 있는 변수
    int pChatTargetIndex;
}

@property(strong,nonatomic) UITableView *pListView;
@property(strong,nonatomic) NSMutableArray *pMemberListdata;
@property(strong,nonatomic) NSMutableArray *pChatData;
@property(strong,nonatomic) NetWorkController *pNetWorkController;
@property(strong,nonatomic) NSMutableData *pReturnData;
@property(strong,nonatomic) MemberListViewController *pMemberListViewController;
@property(strong,nonatomic) ChatViewController *pChatViewController;
//@property(strong,nonatomic) int pStatus;
@property int pStatus;

-(void)setMyUserInformation:(NSString *)strUserID PassWord:(NSString *)strPassWord;
-(void)getServerConnect;
-(void)SendChatTextCommand;
-(void)SendReqvCommand:(int)index;
@end
