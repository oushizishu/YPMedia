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

#import "NSDate+BJCF.h"
#import "NSDateFormatter+BJCF.h"

#define BJCFDATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define BJCFCURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (BJCF)

/*距离当前的时间间隔描述*/
- (NSString *)bjcf_timeIntervalDescription
{
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
	if (timeInterval < 60) {
        return @"1分钟内";
	} else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
	} else if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
	} else if (timeInterval < 2592000) {//30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / 86400];
    } else if (timeInterval < 31536000) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"M月d日"];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}

/*精确到分钟的日期描述*/
- (NSString *)bjcf_minuteDescription
{
    NSDateFormatter *dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"yyyy-MM-dd"];
    
	NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
	NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
		[dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
	} else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7) {//间隔一周内
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else {//以前
		[dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        return [dateFormatter stringFromDate:self];
	}
}

/**
 *  @author LiangZhao, 15-09-23 16:09:17
 *
 *  测试代码
 *   
    NSArray *testList = @[@"2014-09-20 23:20:10",@"2015-09-20 23:20:10", @"2015-09-21 23:20:10",@"2015-09-21 00:20:10",@"2015-09-21 01:20:10",@"2015-09-21 00:00:00",@"2015-09-22 23:20:10",@"2015-09-22 00:20:10",@"2015-09-22 01:20:10",@"2015-09-22 00:00:00",@"2015-09-23 00:20:10",@"2015-09-23 23:20:10",@"2015-09-23 01:20:10",@"2015-09-23 00:00:00"];
    for (NSString *oneStr in testList)
    {
        NSDate *date = [[NSDateFormatter defaultDateFormatter] dateFromString:oneStr];
        NSLog(@"date:%@ 转换：%@",oneStr,[date formattedTime]);
    }
 *
 */
- (NSInteger) bjcf_maxHoursAfterDate:(NSDate *)date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    NSInteger hour = 0;
    NSTimeInterval hi = ti / D_HOUR;
    if (ti>=0) {
        hour = ceil(hi);
    }
    else
        hour = -ceil(fabs(hi));
    return hour;
}

- (BOOL)bjcf_isAMPM
{
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

/**
 *  根据传入的 ampm/24 区别返回不同的时间格式化数据
 *
 *  @param isAMPM 是上下午的 YES
 *
 *  @return 返回格式化好的字符串
 */
- (NSString *)bjcf_formattedTimeWithAMPM:(BOOL)isAMPM
{
    NSDateFormatter* formatter = [NSDateFormatter bjcf_dateFormatter];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间
    
    
    NSInteger hour = [self bjcf_maxHoursAfterDate:date];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    
    BOOL hasAMPM = isAMPM;
    
    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"昨天HH:mm"];
        }else {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }else {
        if (hour >= 0 && hour <= 6) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"凌晨hh:mm"];
        }else if (hour > 6 && hour <=12 ) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"上午hh:mm"];
        }else if (hour > 12 && hour <= 18) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"下午hh:mm"];
        }else if (hour > 18 && hour <= 24) {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"晚上hh:mm"];
        }else if (hour < 0 && hour >= -24){
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"昨天HH:mm"];
        }else  {
            dateFormatter = [NSDateFormatter bjcf_dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }
    
    ret = [dateFormatter stringFromDate:self];
    return ret;
}

/*标准时间日期描述*/
-(NSString *)bjcf_formattedTime
{
    return [self bjcf_formattedTimeWithAMPM:[self bjcf_isAMPM]];
}


/*格式化日期描述*/
- (NSString *)bjcf_formattedDateDescription
{
    NSDateFormatter *dateFormatter = [NSDateFormatter bjcf_dateFormatter];
    
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
	NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
	} else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟前", (long)(timeInterval / 60)];
	} else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%ld小时前", (long)timeInterval / 3600];
	} else if ([theDay isEqualToString:currentDay]) {//当天
		[dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
	} else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else {//以前
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
	}
}

- (double)bjcf_timeIntervalSince1970InMilliSecond {
    double ret;
    ret = [self timeIntervalSince1970] * 1000;
    
    return ret;
}

- (long long)bjcf_millisecondsSince1970 {
    return (long long)([self timeIntervalSince1970] * 1000);
}

+ (NSDate *)bjcf_dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

+ (NSDate *)bjcf_dateWithMillisecondsSince1970:(long long)milliseconds {
    return [NSDate dateWithTimeIntervalSince1970:((double)milliseconds) / 1000];
}

+ (NSString *)bjcf_formattedTimeFromTimeInterval:(long long)time{
    return [[NSDate bjcf_dateWithTimeIntervalInMilliSecondSince1970:time] bjcf_formattedTime];
}

#pragma mark string from date
- (NSString *)bjcf_dayString
{
    NSDateFormatter *dayDateFormatter = [NSDateFormatter bjcf_dateFormatter];
    [dayDateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dayDateFormatter stringFromDate:self];
}

- (NSString *)bjcf_monthString
{
    NSDateFormatter *dayDateFormatter = [NSDateFormatter bjcf_dateFormatter];
    [dayDateFormatter setDateFormat:@"yyyy-MM"];
    return [dayDateFormatter stringFromDate:self];
}

#pragma mark Relative Dates

+ (NSDate *) bjcf_dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] bjcf_dateByAddingDays:days];
}

+ (NSDate *) bjcf_dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] bjcf_dateBySubtractingDays:days];
}

+ (NSDate *) bjcf_dateTomorrow
{
	return [NSDate bjcf_dateWithDaysFromNow:1];
}

//上一个月
- (NSDate *) bjcf_lastMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

//下一个月
- (NSDate *)bjcf_nextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

+ (NSDate *) bjcf_dateYesterday
{
	return [NSDate bjcf_dateWithDaysBeforeNow:1];
}

- (NSDate *)bjcf_nextDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * 24 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)bjcf_backDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - D_HOUR * 24 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) bjcf_dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) bjcf_dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) bjcf_dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) bjcf_dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

#pragma mark Comparing Dates

- (BOOL) bjcf_isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

- (BOOL) bjcf_isToday
{
	return [self bjcf_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) bjcf_isTomorrow
{
	return [self bjcf_isEqualToDateIgnoringTime:[NSDate bjcf_dateTomorrow]];
}

- (BOOL) bjcf_isYesterday
{
	return [self bjcf_isEqualToDateIgnoringTime:[NSDate bjcf_dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) bjcf_isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) bjcf_isThisWeek
{
	return [self bjcf_isSameWeekAsDate:[NSDate date]];
}

- (BOOL) bjcf_isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self bjcf_isSameWeekAsDate:newDate];
}

- (BOOL) bjcf_isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self bjcf_isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) bjcf_isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) bjcf_isThisMonth
{
    return [self bjcf_isSameMonthAsDate:[NSDate date]];
}

- (BOOL) bjcf_isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) bjcf_isThisYear
{
    // Thanks, baspellis
	return [self bjcf_isSameYearAsDate:[NSDate date]];
}

- (BOOL) bjcf_isNextYear
{
	NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) bjcf_isLastYear
{
	NSDateComponents *components1 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [BJCFCURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) bjcf_isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) bjcf_isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) bjcf_isInFuture
{
    return ([self bjcf_isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) bjcf_isInPast
{
    return ([self bjcf_isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL) bjcf_isTypicallyWeekend
{
    NSDateComponents *components = [BJCFCURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) bjcf_isTypicallyWorkday
{
    return ![self bjcf_isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) bjcf_dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) bjcf_dateBySubtractingDays: (NSInteger) dDays
{
	return [self bjcf_dateByAddingDays: (dDays * -1)];
}

- (NSDate *) bjcf_dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) bjcf_dateBySubtractingHours: (NSInteger) dHours
{
	return [self bjcf_dateByAddingHours: (dHours * -1)];
}

- (NSDate *) bjcf_dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) bjcf_dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self bjcf_dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) bjcf_dateAtStartOfDay
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [BJCFCURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) bjcf_componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) bjcf_minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) bjcf_minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) bjcf_hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) bjcf_hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) bjcf_daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) bjcf_daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)bjcf_distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark 日期的开始~结束 （月，天，年，星期）
- (NSDate *)bjcf_beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)bjcf_endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self bjcf_beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)bjcf_beginningOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    NSUInteger offset = ([components weekday] == [calendar firstWeekday]) ? 6 : [components weekday] - 2;
    [components setDay:[components day] - offset];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)bjcf_endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self bjcf_beginningOfWeek] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)bjcf_beginningOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)bjcf_endOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self bjcf_beginningOfMonth] options:0] dateByAddingTimeInterval:-1];
}

#pragma mark Decomposing Dates

- (NSInteger) bjcf_nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) bjcf_hour
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) bjcf_minute
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) bjcf_seconds
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) bjcf_day
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) bjcf_month
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) bjcf_week
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) bjcf_weekday
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) bjcf_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) bjcf_year
{
	NSDateComponents *components = [BJCFCURRENT_CALENDAR components:BJCFDATE_COMPONENTS fromDate:self];
	return components.year;
}

@end
