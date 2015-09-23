//
//  MemberListDataModel.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 13..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberListDataModel : NSObject
{
    NSString *pUserName;
    NSString *pContext;
    NSString *pUserID;
    UIImage *pUserImage;
    
}
@property(nonatomic, copy) NSString *pUserName;
@property(nonatomic, copy) NSString *pContext;
@property(nonatomic, retain) NSString *pUserID;
@property(nonatomic, retain) UIImage *pUserImage;

@end