//
//  ChatViewCell.h
//  MrMessanger
//
//  Created by Jaewon on 2015. 5. 7..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel *pTimeView;
@property(weak,nonatomic) IBOutlet UITextView *pContextView;
@property(weak,nonatomic) IBOutlet UIImageView *pBackImageView;

@end
