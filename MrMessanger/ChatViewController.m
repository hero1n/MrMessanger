//
//  ChatViewController.m
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatDataModel.h"
#import "ChatViewCell.h"
#import "NetWorkController.h"

#define WIDTH_SPACE 100.f
#define RIGHT_WIDTH_SPACE 58.0f

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize pBackView;
@synthesize pTextView;
@synthesize pButton;
@synthesize pChatListView;
@synthesize pNetWorkController;

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewDidLoad];
}

-(void)sendText{
    [pTextView resignFirstResponder]; //키보드 감추기
    [pNetWorkController SendChatTextCommand]; // 네트워크를 통해 메시지 전송
}

-(void)keyboardWillShow:(NSNotification *)pNotification{
    CGRect pFrame = pBackView.frame;
    NSDictionary *userInfo = [pNotification userInfo];
    CGRect bound;
    [(NSValue *)[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]getValue:&bound];
    pFrame.origin.y -= bound.size.height;
    pBackView.frame = pFrame;
}

-(void)keyboardWillHide:(NSNotification *)pNotification{
    CGRect pFrame = pBackView.frame;
    NSDictionary *userInfo = [pNotification userInfo];
    CGRect bound;
    [(NSValue *)[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]getValue:&bound];
    pFrame.origin.y += bound.size.height;
    pBackView.frame = pFrame;
}

-(IBAction)CloseClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 테이블 뷰 델리게이트
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(pNetWorkController.pChatData == nil)
        return 0;
    else
        return [pNetWorkController.pChatData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatDataModel *rowData = [pNetWorkController.pChatData objectAtIndex:[indexPath row]];
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    return dataSize.height + 30;
}

//박스(도움말,대화상자) 크기 설정
-(CGSize)getBoxSize:(NSString *)string{
    CGSize maxSize = CGSizeMake(170.0,1000.0);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize dataHeight = [string sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeCharacterWrap];
    return CGSizeMake(dataHeight.width + 20,dataHeight.height + 10);
}

-(ChatViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ChatViewCell" owner:self options:nil];
    ChatViewCell *cell = nil;
    ChatDataModel *rowData = [pNetWorkController.pChatData objectAtIndex:[indexPath row]];
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    CGSize windowSize = self.pChatListView.frame.size;
    if(rowData.LeftYN){
        cell = [cellArray objectAtIndex:0];
        cell.pBackImageView.image = [[UIImage imageNamed:@"box.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        cell.pBackImageView.frame = CGRectMake(cell.pBackImageView.frame.origin.x,cell.pBackImageView.frame.origin.y,MAX(dataSize.width,WIDTH_SPACE)+5,dataSize.height);
        cell.pContextView.frame = CGRectMake(cell.pContextView.frame.origin.x,cell.pContextView.frame.origin.y,MAX(dataSize.width,WIDTH_SPACE - 10.0),dataSize.height);
    }else{
        cell = [cellArray objectAtIndex:1];
        cell.pBackImageView.image = [[UIImage imageNamed:@"box.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        cell.pBackImageView.frame = CGRectMake(windowSize.width - RIGHT_WIDTH_SPACE - MAX(dataSize.width,WIDTH_SPACE)+5,cell.pBackImageView.frame.origin.y,MAX(dataSize.width,WIDTH_SPACE)+5,dataSize.height);
        cell.pContextView.frame = CGRectMake(windowSize.width - RIGHT_WIDTH_SPACE - MAX(dataSize.width,WIDTH_SPACE)+5,cell.pContextView.frame.origin.y,MAX(dataSize.width,WIDTH_SPACE - 10.0),dataSize.height);
    }
    cell.pTimeView.text = rowData.pTime;
    cell.pContextView.text = rowData.pContext;
    return cell;
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
