//
//  Constant.h
//  JJNews
//
//  Created by Rong Hao on 13-10-8.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#ifndef JJNews_Constant_h
#define JJNews_Constant_h

#define INNER_URL                 @"http://192.168.2.51:8888/"
#define OUTER_URL                 @"http://116.236.229.45:8888/"

#define INDEX_VERSION       @"version.plist"
#define INDEX_INFO          @"infoList.plist"

#define INNER_INDEX_INFO_URL      [INNER_URL stringByAppendingPathComponent:INDEX_INFO]
#define INNER_INDEX_VERSION_URL   [INNER_URL stringByAppendingPathComponent:INDEX_VERSION]

#define OUTER_INDEX_INFO_URL      [OUTER_URL stringByAppendingPathComponent:INDEX_INFO]
#define OUTER_INDEX_VERSION_URL   [OUTER_URL stringByAppendingPathComponent:INDEX_VERSION]






#define LOCAL_DOCUMENT      [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Documents"]]

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#endif
