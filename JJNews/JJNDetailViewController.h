//
//  JJNDetailViewController.h
//  JJNews
//
//  Created by Raphael on 13-10-7.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJNDetailViewController : UIViewController

@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) NSString *detialPlistName;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *positionImage;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UITextView *positionText;

@property (nonatomic, strong) NSString *urlStringPre;
@end
