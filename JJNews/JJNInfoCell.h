//
//  JJNInfoCell.h
//  JJNews
//
//  Created by Raphael on 13-10-7.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJNInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
