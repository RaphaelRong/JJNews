//
//  JJNViewController.h
//  JJNews
//
//  Created by Raphael on 13-10-6.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJNViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *indexTitleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *indexControl;
@property (weak, nonatomic) IBOutlet UIScrollView *indexScrollView;
@property (weak, nonatomic) IBOutlet UITableView *indexTable;

@end
