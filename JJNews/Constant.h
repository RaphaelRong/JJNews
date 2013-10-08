//
//  Constant.h
//  JJNews
//
//  Created by Rong Hao on 13-10-8.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#ifndef JJNews_Constant_h
#define JJNews_Constant_h

//#define URL                 @"http://192.168.2.51:8888/"
#define URL                 @"http://116.236.229.45:8888/"

#define INDEX_VERSION       @"version.plist"
#define INDEX_INFO          @"infoList.plist"

#define INDEX_INFO_URL      [URL stringByAppendingPathComponent:INDEX_INFO]
#define INDEX_VERSION_URL   [URL stringByAppendingPathComponent:INDEX_VERSION]






#define LOCAL_DOCUMENT      [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Documents"]]

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#endif
