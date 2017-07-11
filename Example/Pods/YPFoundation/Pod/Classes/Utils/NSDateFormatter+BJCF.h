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

#import <Foundation/Foundation.h>

@interface NSDateFormatter (BJCF)

+ (id)bjcf_dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)bjcf_dateFormatter;//yyyy.MM.dd
+ (id)bjcf_defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/
+ (id)bjcf_defaultDateFormatter2;/*yyyy-MM-dd HH:mm*/
+ (id)bjcf_defaultDayDateFormatter;//yyyy.MM.dd
+ (id)bjcf_defaultDayDateFormatter2;//yyyy-MM-dd
+ (id)bjcf_defaultOnlyHourDateFormatter;//dd
+ (id)bjcf_defaultTimeDateFormatter;//HH:mm

@end
