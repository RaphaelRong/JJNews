//
//  JJNDetailViewController.m
//  JJNews
//
//  Created by Raphael on 13-10-7.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import "JJNDetailViewController.h"
#import "NSArray+Util.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@interface JJNDetailViewController ()

@property (nonatomic, strong) NSArray *infoList;
@property (nonatomic, strong) UIButton *fakeBackButton;

@end

@implementation JJNDetailViewController

- (IBAction)backBarButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoList = self.detailList;
    
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
        UITextView *aText = [[UITextView alloc] initWithFrame:CGRectMake(textFrame.origin.x + (320 * i), textFrame.origin.y, textFrame.size.width, textFrame.size.height - (IS_IOS7 ? 64 : 44))];
        aText.editable = NO;
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageFrame.origin.x + (320 * i), imageFrame.origin.y, imageFrame.size.width, imageFrame.size.height)];
        aLabel.text = title;
        aText.text = detail;
        [aImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/%@", self.urlStringPre, image]] placeholderImage:[UIImage imageNamed:@"title_name.png"]];
        
        [self.detailScrollView addSubview:aLabel];
        [self.detailScrollView addSubview:aText];
        [self.detailScrollView addSubview:aImage];
        
        i++;
    }
    
    self.fakeBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.fakeBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.fakeBackButton];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.fakeBackButton removeFromSuperview];
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
