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

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (BJCF)

- (NSString *)bjcf_timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)bjcf_minuteDescription;/*精确到分钟的日期描述*/
/**
 *  根据传入的 ampm/24 区别返回不同的时间格式化数据
 *
 *  @param isAMPM 是上下午的 YES
 *
 *  @return 返回格式化好的字符串
 */
- (NSString *)bjcf_formattedTimeWithAMPM:(BOOL)isAMPM;
- (NSString *)bjcf_formattedTime;
- (NSString *)bjcf_formattedDateDescription;//格式化日期描述
- (double)bjcf_timeIntervalSince1970InMilliSecond DEPRECATED_MSG_ATTRIBUTE("use `- bjcf_millisecondsSince1970`");
- (long long)bjcf_millisecondsSince1970;
+ (NSDate *)bjcf_dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond DEPRECATED_MSG_ATTRIBUTE("use `+ bjcf_dateWithMillisecondsSince1970:`");
+ (NSDate *)bjcf_dateWithMillisecondsSince1970:(long long)milliseconds;
+ (NSString *)bjcf_formattedTimeFromTimeInterval:(long long)time DEPRECATED_MSG_ATTRIBUTE("use `- bjcf_formattedTime`");
// Relative dates from the current date
+ (NSDate *) bjcf_dateTomorrow;
//上一个月
- (NSDate *) bjcf_lastMonth;
//下一个月
- (NSDate *)bjcf_nextMonth;
//下几天
- (NSDate *)bjcf_nextDays:(NSInteger)days;
- (NSDate *)bjcf_backDays:(NSInteger)days;
+ (NSDate *) bjcf_dateYesterday;
+ (NSDate *) bjcf_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) bjcf_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) bjcf_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) bjcf_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) bjcf_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) bjcf_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) bjcf_isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) bjcf_isToday;
- (BOOL) bjcf_isTomorrow;
- (BOOL) bjcf_isYesterday;
- (BOOL) bjcf_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) bjcf_isThisWeek;
- (BOOL) bjcf_isNextWeek;
- (BOOL) bjcf_isLastWeek;
- (BOOL) bjcf_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) bjcf_isThisMonth;
- (BOOL) bjcf_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) bjcf_isThisYear;
- (BOOL) bjcf_isNextYear;
- (BOOL) bjcf_isLastYear;
- (BOOL) bjcf_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) bjcf_isLaterThanDate: (NSDate *) aDate;
- (BOOL) bjcf_isInFuture;
- (BOOL) bjcf_isInPast;

- (NSDate *)bjcf_beginningOfDay;
- (NSDate *)bjcf_endOfDay;
- (NSDate *)bjcf_beginningOfWeek;
- (NSDate *)bjcf_endOfWeek;
- (NSDate *)bjcf_beginningOfMonth;
- (NSDate *)bjcf_endOfMonth;

// string from date
- (NSString *)bjcf_dayString;
- (NSString *)bjcf_monthString;

// Date roles
- (BOOL) bjcf_isTypicallyWorkday;
- (BOOL) bjcf_isTypicallyWeekend;

// Adjusting dates
- (NSDate *) bjcf_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) bjcf_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) bjcf_dateByAddingHours: (NSInteger) dHours;
- (NSDate *) bjcf_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) bjcf_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) bjcf_dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) bjcf_dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) bjcf_minutesAfterDate: (NSDate *) aDate;
- (NSInteger) bjcf_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) bjcf_hoursAfterDate: (NSDate *) aDate;
- (NSInteger) bjcf_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) bjcf_daysAfterDate: (NSDate *) aDate;
- (NSInteger) bjcf_daysBeforeDate: (NSDate *) aDate;
- (NSInteger)bjcf_distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger bjcf_nearestHour;
@property (readonly) NSInteger bjcf_hour;
@property (readonly) NSInteger bjcf_minute;
@property (readonly) NSInteger bjcf_seconds;
@property (readonly) NSInteger bjcf_day;
@property (readonly) NSInteger bjcf_month;
@property (readonly) NSInteger bjcf_week;
@property (readonly) NSInteger bjcf_weekday;
@property (readonly) NSInteger bjcf_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger bjcf_year;

@end
