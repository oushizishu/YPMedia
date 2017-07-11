/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "NSDateFormatter+BJCF.h"

@implementation NSDateFormatter (BJCF)

+ (id)bjcf_dateFormatter
{
    static NSDateFormatter *dateFormate= nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dateFormate = [[NSDateFormatter alloc] init];
    });
    return dateFormate;
}

+ (id)bjcf_dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [self bjcf_dateFormatter];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)bjcf_defaultDayDateFormatter
{
    NSDateFormatter *dayDateFormatter = [self bjcf_dateFormatter];
    dayDateFormatter.dateFormat = @"yyyy.MM.dd";
    return dayDateFormatter;
}

+ (id)bjcf_defaultDayDateFormatter2
{
    NSDateFormatter *dayDateFormatter = [self bjcf_dateFormatter];
    dayDateFormatter.dateFormat = @"yyyy-MM-dd";
    return dayDateFormatter;
}

+ (id)bjcf_defaultDateFormatter
{
    NSDateFormatter *dateFormatter = [self bjcf_dateFormatter];
   dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

+ (id)bjcf_defaultDateFormatter2
{
    NSDateFormatter *dateFormatter = [self bjcf_dateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return dateFormatter;
}

+ (id)bjcf_defaultOnlyHourDateFormatter//dd
{
    NSDateFormatter *dateFormatter = [self bjcf_dateFormatter];
    dateFormatter.dateFormat = @"dd";
    return dateFormatter;
}

+ (id)bjcf_defaultTimeDateFormatter;
{
    NSDateFormatter *dateFormatter = [self bjcf_dateFormatter];
    dateFormatter.dateFormat = @"HH:mm";
    return dateFormatter;
}

@end
