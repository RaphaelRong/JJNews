//
//  JJNViewController.m
//  JJNews
//
//  Created by Raphael on 13-10-6.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "JJNViewController.h"
#import "JJNInfoCell.h"
#import "NSArray+Util.h"
#import "JJNDetailViewController.h"
#import "Constant.h"
#import "JJNLoadingViewController.h"
#import "UIImageView+WebCache.h"

@interface JJNViewController ()

@property (nonatomic) BOOL pageControlBeingUsed;
@property (nonatomic, strong) NSArray *infoList;
@property (nonatomic, strong) NSString *selectInfoFileName;
@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) JJNLoadingViewController *loadingIndicatorView;
@property (nonatomic, strong) NSString *bannerImage;
@property (nonatomic, strong) UIImageView *firstBannerView;
@property (nonatomic, strong) UIImageView *secondBannerView;
@property (nonatomic, strong) NSString *urlStringPer;
@property (nonatomic, strong) NSString *urlIndexInfo;
@property (nonatomic, strong) NSString *urlVersionInfo;

@end

@implementation JJNViewController

dispatch_queue_t checkVersionQueue;
dispatch_queue_t checkLatestInfo;
dispatch_queue_t checkDetailQueue;

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!_pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.indexScrollView.frame.size.width;
        int page = floor((self.indexScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.indexControl.currentPage = page;
    }
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam)));
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)showLoading
{
    if (self.loadingIndicatorView == nil)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.loadingIndicatorView = [board instantiateViewControllerWithIdentifier:@"JJNLoadingViewController"];
        CGRect frame = self.loadingIndicatorView.view.frame;
        frame.origin = CGPointMake(0, 0);
        self.loadingIndicatorView.view.frame = frame;
    }
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.loadingIndicatorView.view.layer.zPosition = 1000;
    [self.view addSubview:self.loadingIndicatorView.view];
}

- (void)hideLoading
{
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.loadingIndicatorView.view removeFromSuperview];
    self.loadingIndicatorView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *ssidDict = [self fetchSSIDInfo];
    NSString *ssid = [ssidDict objectForKey:@"SSID"];
    self.urlStringPer = [@"JJIEC" isEqualToString:ssid] ? INNER_URL : OUTER_URL;
    self.urlIndexInfo = [@"JJIEC" isEqualToString:ssid] ? INNER_INDEX_INFO_URL : OUTER_INDEX_INFO_URL;
    self.urlVersionInfo = [@"JJIEC" isEqualToString:ssid] ? INNER_INDEX_VERSION_URL : OUTER_INDEX_VERSION_URL;
    
    
    UIView *titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar.png"]];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_name.png"]];
    titleImageView.frame = CGRectMake(80, 4, 160, 36);
    
    [self.navigationController.navigationBar addSubview:titleBackView];
    [self.navigationController.navigationBar addSubview:titleImageView];
    
    self.firstBannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    self.secondBannerView = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 120)];
    
    [self.indexScrollView addSubview:self.firstBannerView];
    [self.indexScrollView addSubview:self.secondBannerView];
    self.indexScrollView.contentSize = CGSizeMake(640, 120);
    self.indexScrollView.delegate = self;
    
    self.indexControl.currentPage = 0;
    self.indexControl.numberOfPages = 2;
    
    self.indexTable.delegate = self;
    self.indexTable.dataSource = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    checkVersionQueue = dispatch_queue_create("versionQueue", NULL);
    [self showLoading];
    dispatch_async(checkVersionQueue, ^{
        [self getLatestVersion];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self checkIsLatestVersion]) {
                
                if ([self checkIsLatestNews]) {
                    [self hideLoading];
                }
            }
        });
    });
    
    
}

- (void)getInfoFromFile
{
    
    NSString *indexInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_INFO];
    self.infoList = [NSArray arrayWithContentsOfFile:indexInfoFilePath];
    
    [self.indexTable reloadData];
}

- (BOOL)checkIsLatestVersion
{
    NSString *versionInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_VERSION];
    NSDictionary *versionDict = [NSDictionary dictionaryWithContentsOfFile:versionInfoFilePath];
    
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *latestVersion = [versionDict objectForKey:@"version"];
    
    if (currentVersion == nil || ![currentVersion isEqualToString:latestVersion]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的客户端不是最新版本，是否现在去App Store更新？" delegate:self
                                              cancelButtonTitle:@"退出" otherButtonTitles:@"去更新", nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (BOOL)checkIsLatestNews
{
    NSString *versionInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_VERSION];
    NSDictionary *versionDict = [NSDictionary dictionaryWithContentsOfFile:versionInfoFilePath];
    
    NSString *currentInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastInfo"];
    NSString *lastInfo = [versionDict objectForKey:@"lastInfo"];
    
    if (currentInfo == nil || ![currentInfo isEqualToString:lastInfo]) {
        checkLatestInfo = dispatch_queue_create("latestInfo", NULL);
        dispatch_async(checkLatestInfo, ^{
            [self getLatestInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getInfoFromFile];
                
                NSString *versionInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_VERSION];
                NSDictionary *versionDict = [NSDictionary dictionaryWithContentsOfFile:versionInfoFilePath];
                
                NSString *currentInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastInfo"];
                
                NSString *bannerURL = [versionDict objectForKey:@"bannerImage"];
                
                [self.firstBannerView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/%@", self.urlStringPer, bannerURL]] placeholderImage:[UIImage imageNamed:@"title_ad_image.png"]];
                [self.secondBannerView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@image/%@", self.urlStringPer, bannerURL]] placeholderImage:[UIImage imageNamed:@"title_ad_image.png"]];
                [[NSUserDefaults standardUserDefaults] setObject:currentInfo forKey:@"lastInfo"];
                [self hideLoading];
                
            });
        });
        return NO;
    } else {
        [self getInfoFromFile];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            exit(0);
            break;
        case 1:
            NSLog(@"button 2");
            break;
        default:
            break;
    }
}


- (void)getLatestVersion
{
    NSURL *versionInfoUrl=[NSURL URLWithString:self.urlVersionInfo];
    
    NSData *versionInfoUrlFile = [[NSData alloc] initWithContentsOfURL:versionInfoUrl];
    
    NSString *versionInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_VERSION];
    
    [versionInfoUrlFile writeToFile:versionInfoFilePath atomically:YES];
    
}

- (void)getLatestInfo
{
    NSURL *indexInfoUrl=[NSURL URLWithString:self.urlIndexInfo];
    
    NSData *indexInfoUrlFile = [[NSData alloc] initWithContentsOfURL:indexInfoUrl];
    
    NSString *indexInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:INDEX_INFO];
    
    [indexInfoUrlFile writeToFile:indexInfoFilePath atomically:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"fromIndexToDetail" isEqualToString: segue.identifier]) {
        JJNDetailViewController *jdvc = (JJNDetailViewController *)segue.destinationViewController;
        jdvc.detailList = self.detailList;
        jdvc.urlStringPre = self.urlStringPer;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.infoList objectAtIndex:indexPath.row];
    NSString *fileName = [dict objectForKey:@"target"];
    
    [self checkDetailArrayWithFileName:[NSString stringWithFormat:@"%@.plist", fileName]];
    
}

- (NSArray *)getDetailArrayWithFileName:(NSString *)fileName
{
    NSString *detailFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:fileName];
    return [NSArray arrayWithContentsOfFile:detailFilePath];
}

- (void)downloadDetailArrayWithFileName:(NSString *)fileName
{
    
    NSURL *detailInfoUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.urlStringPer, fileName]];
    
    NSData *detailInfoUrlFile = [[NSData alloc] initWithContentsOfURL:detailInfoUrl];
    
    NSString *detailInfoFilePath = [LOCAL_DOCUMENT stringByAppendingPathComponent:fileName];
    
    [detailInfoUrlFile writeToFile:detailInfoFilePath atomically:YES];
}

- (void)checkDetailArrayWithFileName:(NSString *)fileName
{
    NSArray *detailArray = [self getDetailArrayWithFileName:fileName];
    
    if (detailArray == nil) {
        
        checkDetailQueue = dispatch_queue_create("detailQueue", NULL);
        [self showLoading];
        dispatch_async(checkDetailQueue, ^{
            [self downloadDetailArrayWithFileName:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *details = [self getDetailArrayWithFileName:fileName];
                [self hideLoading];
                
                if (details == nil || details.count < 1) {
                    NSLog(@"ERROR: no details");
                    return;
                }
                
                self.detailList = details;
                [self performSegueWithIdentifier:@"fromIndexToDetail" sender:self];
            });
        });
    } else {
        self.detailList = detailArray;
        [self performSegueWithIdentifier:@"fromIndexToDetail" sender:self];
    }
    
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
    NSInteger pageNum = sender.currentPage;
    
    [self.indexScrollView scrollRectToVisible:CGRectMake(pageNum * 320, 0, 320, 140) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
