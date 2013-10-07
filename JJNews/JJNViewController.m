//
//  JJNViewController.m
//  JJNews
//
//  Created by Raphael on 13-10-6.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import "JJNViewController.h"
#import "JJNInfoCell.h"
#import "NSArray+Util.h"
#import "JJNDetailViewController.h"

@interface JJNViewController ()

@property (nonatomic) BOOL pageControlBeingUsed;
@property (nonatomic, strong) NSArray *infoList;
@property (nonatomic, strong) NSString *selectInfoFileName;

@end

@implementation JJNViewController

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!_pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.indexScrollView.frame.size.width;
        int page = floor((self.indexScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.indexControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar.png"]];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_name.png"]];
    titleImageView.frame = CGRectMake(80, 4, 160, 36);
    
    [self.navigationController.navigationBar addSubview:titleBackView];
    [self.navigationController.navigationBar addSubview:titleImageView];
    
    
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_ad_image.png"]];
    UIImageView *secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_ad_image.png"]];
    firstImageView.frame = CGRectMake(0, 0, 320, 120);
    secondImageView.frame = CGRectMake(320, 0, 320, 120);
    [self.indexScrollView addSubview:firstImageView];
    [self.indexScrollView addSubview:secondImageView];
    self.indexScrollView.contentSize = CGSizeMake(640, 120);
    self.indexScrollView.delegate = self;
    
    self.infoList = [[NSArray alloc] initArrayWithPlistName:@"infoList"];
    
    self.indexControl.currentPage = 0;
    self.indexControl.numberOfPages = 2;
    
    self.indexTable.delegate = self;
    self.indexTable.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"fromIndexToDetail" isEqualToString: segue.identifier]) {
        JJNDetailViewController *jdvc = (JJNDetailViewController *)segue.destinationViewController;
        jdvc.detialPlistName = self.selectInfoFileName;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.infoList objectAtIndex:indexPath.row];
    self.selectInfoFileName = [dict objectForKey:@"target"];
    
    [self performSegueWithIdentifier:@"fromIndexToDetail" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJNInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indexCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [self.infoList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dict objectForKey:@"title"];
    cell.detailText.text = [dict objectForKey:@"detail"];
    cell.dateLabel.text = [dict objectForKey:@"date"];
    
    return cell;
}

- (IBAction)pageTouched:(UIPageControl *)sender {
    int pageNum = sender.currentPage;
    
    [self.indexScrollView scrollRectToVisible:CGRectMake(pageNum * 320, 0, 320, 140) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
