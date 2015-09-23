//
//  MemberListViewController.m
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberViewCell.h"
#import "MemberListDataModel.h"
#import "ChatViewController.h"
#import "NetWorkController.h"

#define ROW_HEIGHT 44
#define WIDTH_SPACE 75.f

@interface MemberListViewController ()

@end

@implementation MemberListViewController
@synthesize pListView;
@synthesize pChatViewController;
@synthesize pNetWorkController;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"채팅";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        [self NetWorkInit];
    }
    return self;
}

-(void)ServerConnect:(NSString *)pUserID PassWord:(NSString *)pPass{
    if(pNetWorkController.pStatus)
        return;
    
    [pNetWorkController setMyUserInformation:pUserID PassWord:pPass];
    [pNetWorkController getServerConnect];
}

#pragma mark 테이블뷰

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(pNetWorkController.pMemberListdata == nil)
        return 0;
    else
        return [pNetWorkController.pMemberListdata count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

-(CGSize)getBoxSize:(NSString *)string{
    CGSize maxSize = CGSizeMake(170.0,30);
    CGSize dataHeight = [string sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return CGSizeMake(dataHeight.width,dataHeight.height);
}

-(MemberViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MemberViewCell";
    MemberViewCell *cell = (MemberViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MemberListDataModel *rowData = [pNetWorkController.pMemberListdata objectAtIndex:[indexPath row]];
    
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    CGSize windowSize = pListView.frame.size;
    if(cell == nil){
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"MemberViewCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.pBackImageView.image = [[UIImage imageNamed:@"box.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    cell.pBackImageView.frame = CGRectMake(cell.pBackImageView.frame.origin.x, cell.pBackImageView.frame.origin.y, MAX(dataSize.width,[self getBoxSize:cell.pNameView.text].width + WIDTH_SPACE), 30);
    cell.pNameView.text = rowData.pUserName;
    cell.pContextView.text = rowData.pContext;
    return cell;
}
-(BOOL)tableView:(UITableViewCell *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark Table View delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [pNetWorkController SendReqvCommand:indexPath.row];
}

-(void)ChatViewShow{
    [self presentViewController:self.pChatViewController animated:YES completion:nil];
}

-(void)NetWorkInit{
    pNetWorkController = [[NetWorkController alloc]init];
    if(pChatViewController == nil)
        pChatViewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    pChatViewController.pNetWorkController = pNetWorkController;
    pNetWorkController.pChatViewController = pChatViewController;
    pNetWorkController.pMemberListViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
