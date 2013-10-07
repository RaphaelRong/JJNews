//
//  JJNDetailViewController.m
//  JJNews
//
//  Created by Raphael on 13-10-7.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import "JJNDetailViewController.h"
#import "NSArray+Util.h"

@interface JJNDetailViewController ()

@property (nonatomic, strong) NSArray *infoList;

@end

@implementation JJNDetailViewController
- (IBAction)backBarButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoList = [[NSArray alloc] initArrayWithPlistName:self.detialPlistName];
    
    self.detailScrollView.contentSize = CGSizeMake(self.infoList.count * 320, self.view.frame.size.height - 64);
    
    CGRect labelFrame = self.positionLabel.frame;
    CGRect imageFrame = self.positionImage.frame;
    CGRect textFrame = self.positionText.frame;
    
    int i = 0;
    for (NSDictionary *dict in self.infoList) {
        NSString *title = [dict objectForKey:@"title"];
        NSString *detail = [dict objectForKey:@"detail"];
        NSString *image = [dict objectForKey:@"image"];
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelFrame.origin.x + (320 * i), labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height)];
        UITextView *aText = [[UITextView alloc] initWithFrame:CGRectMake(textFrame.origin.x + (320 * i), textFrame.origin.y, textFrame.size.width, textFrame.size.height)];
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageFrame.origin.x + (320 * i), imageFrame.origin.y, imageFrame.size.width, imageFrame.size.height)];
        aLabel.text = title;
        aText.text = detail;
        [aImage setImage:[UIImage imageNamed:image]];
        
        [self.detailScrollView addSubview:aLabel];
        [self.detailScrollView addSubview:aText];
        [self.detailScrollView addSubview:aImage];
        
        i++;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
    
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
