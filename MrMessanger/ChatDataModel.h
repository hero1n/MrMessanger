//
//  ChatDataModel.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 13..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ChatDataModel : NSObject
{
    NSString *pTime;
    NSString *pContext;
    UIImage *pUserImage;
    BOOL     LeftYN;
    
    
}
@property(nonatomic, copy) NSString *pTime;
@property(nonatomic, copy) NSString *pContext;
@property(nonatomic, retain) UIImage *pUserImage;
@property(nonatomic, assign) BOOL LeftYN;

@end
