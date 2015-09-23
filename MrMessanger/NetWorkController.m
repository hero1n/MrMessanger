//
//  NetWorkController.m
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 11..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "NetWorkController.h"
#import "MemberListDataModel.h"
#import "ChatDataModel.h"
#import "MemberListViewController.h"
#import "ChatViewController.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import <arpa/inet.h>

#define CLOSED 0
#define CONN 1
#define LOG 2
#define LIST 3
#define WAIT 4
#define REQV 5
#define REPL 6
#define CHAT 7
#define TEXT 8

@interface NetWorkController ()

@end

@implementation NetWorkController
@synthesize pListView,pMemberListdata,pChatData,pNetWorkController;
@synthesize pReturnData,pMemberListViewController;
@synthesize pChatViewController,pStatus;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        pStauts = CLOSED;
    }
    return self;
}

-(void)setMyUserInformation:(NSString *)strUserID PassWord:(NSString *)strPassWord{
    pMyUserID = strUserID;
    pMyPassword = strPassWord;
}

-(void)getServerConnect{
    NSLog(@"Get Server Connect...");
    CFSocketContext socketContext = {0,(__bridge void*) self,NULL,NULL,NULL};
    pSocket = CFSocketCreate(kCFAllocatorDefault,PF_INET,SOCK_STREAM,0,kCFSocketReadCallBack|kCFSocketDataCallBack|kCFSocketConnectCallBack|kCFSocketWriteCallBack,(CFSocketCallBack)SocketCallBack,&socketContext);
    struct sockaddr_in sockAddr;
    sockAddr.sin_port = htons(9500); // 9500포트
    sockAddr.sin_family = AF_INET;
    //sockAddr.sin_addr.s_addr = inet_addr("192.168.10.50");
    sockAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    CFDataRef addressData = CFDataCreate(NULL,(void *)&sockAddr,sizeof(struct sockaddr_in));
    CFSocketConnectToAddress(pSocket, addressData, 30); // 서버 접속(30초 타임아웃)
    pRunSource = CFSocketCreateRunLoopSource(NULL, pSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), pRunSource, kCFRunLoopCommonModes);
    CFRelease(addressData);
}

void SocketCallBack(CFSocketRef s,CFSocketCallBackType callbackType,CFDataRef address,const void *data,void *info){
    NetWorkController *pNetWorkController = (__bridge NetWorkController *) info;
    //데이터 수신시
    if(callbackType == kCFSocketDataCallBack){
        if(pNetWorkController.pReturnData == nil){
            pNetWorkController.pReturnData = [[NSMutableData alloc]init];
        }
        
        const UInt8 *buf = CFDataGetBytePtr((CFDataRef)data);
        int len = CFDataGetLength((CFDataRef)data);
        NSLog(@"Data Length : %d",len);
        if(len)
            [pNetWorkController.pReturnData appendBytes:(const void *)buf length:len];
        NSString *receiveStr = [[NSString alloc]initWithData:pNetWorkController.pReturnData encoding:NSUTF8StringEncoding]; // NSString 객체로 변환
        
        NSLog(@"receiveStr Status : %@",receiveStr);
        if([receiveStr rangeOfString:@"\r\n"].location != NSNotFound){
            NSLog(@"Server Status : %d",pNetWorkController.pStatus);
            switch(pNetWorkController.pStatus){
                case CLOSED:
                    break;
                case CONN: { // 로그인 요청시 호출
                    pNetWorkController.pStatus = LOG;
                    [pNetWorkController SendLoginCommand];
                    break;
                }
                case LOG: { // 로그인 요청 후 결과 처리
                    int returnCode = [[receiveStr substringWithRange:NSMakeRange(0, 3)]intValue];
                    if(returnCode == 200){ // 로그인 성공
                        pNetWorkController.pStatus = LIST;
                        [pNetWorkController SendListCommand]; // 회원정보 요청
                    }else{
                        pNetWorkController.pStatus = CONN;
                    }
                    break;
                }
                case LIST: { // 목록 요청 후 결과 처리
                    [pNetWorkController setMemberList:receiveStr];
                    //회원정보를 테이블 뷰에 갱신
                    [pNetWorkController.pMemberListViewController.pListView reloadData];
                    pNetWorkController.pStatus = WAIT;
                    break;
                }
                case REQV: { // 채팅 요청 후 결과 처리
                    int returnCode = [[receiveStr substringWithRange:NSMakeRange(0, 3)]intValue];
                    //대화요청 승인시 대화화면으로 전환
                    if(returnCode == 400)
                       [pNetWorkController startChat];
                    else
                        pNetWorkController.pStatus = WAIT;
                    break;
                }
                case WAIT : { // 로그인 후 대기 상태
                    [pNetWorkController ReceiveReqvCommand:receiveStr];
                    break;
                }
                case CHAT : { // 채팅 중 메시지가 수신됨
                    [pNetWorkController ReceiveChatText:receiveStr];
                    break;
                }
                case TEXT : { //서버로부터 메시지 받을 준비가 되었음을 수신
                    [pNetWorkController SendChatText];
                    break;
                }
                default:
                    break;
            }
            
            pNetWorkController.pReturnData = nil;
        }
    }
    
    if(callbackType == kCFSocketConnectCallBack){
        NSLog(@"Connected!");
        pNetWorkController.pStatus = CONN;
    }
}

-(void)SendDataString:(NSString *)strMessage{
    if(self.pStatus == CLOSED)
        return;
    
    //소켓을 통해 메시지 전송
    NSString *msg = [NSString stringWithFormat:@"%@",strMessage];
    NSData *msg_data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    CFSocketSendData(pSocket, NULL, (CFDataRef)msg_data, 30);
}

-(void)SendLoginCommand{ // CONN 명령어 호출(로그인 요청)
    NSString *pstr = [NSString stringWithFormat:@"CONN %@ %@\r\n",pMyUserID,pMyPassword];
    [self SendDataString:pstr];
}

-(void)SendListCommand{ // LIST 명령어 호출(회원 정보 목록 요청)
    [self SendDataString:@"LIST\r\n"];
}

-(void)SendChatTextCommand{ // TEXT 명령어 호출(대화 메시지 송신 가능 여부 확인)
    pStatus = TEXT;
    [self SendDataString:@"TEXT\r\n"];
}

-(void)SendChatText{ // 메시지 전송
    pStauts = CHAT;
    NSString *pstr = [NSString stringWithFormat:@"%@\r\n",pChatViewController.pTextView.text];
    [self SendDataString:pstr];
    [self addChatMessage:pstr DisTime:[self getTime] forDirection:true ReLoadData:true]; // 송싱한 대화내용 화면 갱신 및 저장
}

-(void)ReceiveChatText:(NSString *)strMessage{ // 메시지 수신
    [self addChatMessage:strMessage DisTime:[self getTime] forDirection:false ReLoadData:true];
}

-(void)SendReqvCommand:(int)index{ // REQV 명령어 호출(일대일 대화 요청)
    MemberListDataModel *rowData = [pMemberListdata objectAtIndex:index];
    pStatus = REQV;
    NSString *pstr = [NSString stringWithFormat:@"REQV %@\r\n",rowData.pUserID];
    
    pChatTargetIndex = index;
    [self SendDataString:pstr];
}

-(void)ReceiveReqvCommand:(NSString *)strMessage{ // REQV 요청에 대한 응답 처리
    NSArray *messageArr = [strMessage componentsSeparatedByString:@" "];
    NSString *tld = [[messageArr objectAtIndex:1] substringToIndex:[[messageArr objectAtIndex:1] rangeOfString:@"\r\n" ].location];
    
    pChatTargetIndex = [self searchUserID:tld]; // 회원검색
    if(pChatTargetIndex == -1){
        NSString *pstr = [NSString stringWithFormat:@"REPL %@ N\r\n",tld];
        [self SendDataString:pstr];
    }else{ // 요청자가 회원일 경우 자동으로 채팅화면으로 전환
        NSString *pstr = [NSString stringWithFormat:@"REPL %@ Y\r\n",tld];
        [self SendDataString:pstr];
        [self startChat];
    }
}

-(void)startChat{
    pStatus = CHAT;
    
    [self.pMemberListViewController ChatViewShow];
}

-(void) setMemberList:(NSString *)strMessage{
    NSArray *memberArr = [strMessage componentsSeparatedByString:@"#"];
    for(int i =0; i < [memberArr count]; i++){
        NSString *memberInfo = [memberArr objectAtIndex:i];
        [self setMemberInfomation:[memberInfo componentsSeparatedByString:@"$"]];
    }
}


-(void)setMemberInfomation:(NSArray *)memberInfo{
    if(pMemberListdata == nil)
        pMemberListdata = [[NSMutableArray alloc]init];
    
    MemberListDataModel *chatData = [[MemberListDataModel alloc]init];
    chatData.pUserID = [memberInfo objectAtIndex:0]; // 회원 아이디
    chatData.pUserName = [memberInfo objectAtIndex:1]; // 회원 이름
    [pMemberListdata addObject:chatData];
}

-(int)searchUserID:(NSString *)str{
    for(int i = 0 ; i < [pMemberListdata count] ; i++){
        MemberListDataModel *chatData = [pMemberListdata objectAtIndex:i];
        if([chatData.pUserID isEqualToString:str])
            return i;
    }
    return -1;
}

-(void)addChatMessage:(NSString *)strMessage DisTime:(NSString *) time forDirection:(bool)direction ReLoadData:(bool)forRefresh{
    if(pChatData == nil)
        pChatData = [[NSMutableArray alloc]init];
    ChatDataModel *chatData = [[ChatDataModel alloc]init];
    chatData.pTime = time;
    chatData.pContext = strMessage;
    chatData.LeftYN = direction;
    [pChatData addObject:chatData];
    if(forRefresh == true)
        [pChatViewController.pChatListView reloadData];
}

-(NSString *)getTime{
    NSCalendar *pCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [pCalendar components:unitFlags fromDate:date];
    int pyear = (int)[comps year];
    int pmonth = (int)[comps month];
    int pday = (int)[comps day];
    int phour = (int)[comps hour];
    int pminute = (int)[comps minute];
    int psecond = (int)[comps second];
    return [NSString stringWithFormat:@"%04d-%02d-%02d%02d:%02d:%02d",pyear,pmonth,pday,phour,pminute,psecond];
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
