//
//  NSArray+Util.m
//  JJNews
//
//  Created by Raphael on 13-10-7.
//  Copyright (c) 2013年 Raphael. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (NSArray *)initArrayWithPlistName:(NSString *)fileName
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:plistPath];
}

@end
