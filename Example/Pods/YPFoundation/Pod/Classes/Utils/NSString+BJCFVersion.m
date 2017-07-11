//
//  NSString+BJCFVersion.m
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import "NSString+BJCFVersion.h"

@implementation NSString (BJCFVersion)

-(NSComparisonResult)BJCF_compareToVersion:(NSString *)version{
    NSComparisonResult result;
    
    result = NSOrderedSame;
    
    if(![self isEqualToString:version]){
        NSArray *thisVersion = [self componentsSeparatedByString:@"."];
        NSArray *compareVersion = [version componentsSeparatedByString:@"."];
        
        for(NSInteger index = 0; index < MAX([thisVersion count], [compareVersion count]); index++){
            NSInteger thisSegment = (index < [thisVersion count]) ? [[thisVersion objectAtIndex:index] integerValue] : 0;
            NSInteger compareSegment = (index < [compareVersion count]) ? [[compareVersion objectAtIndex:index] integerValue] : 0;
            
            if(thisSegment < compareSegment){
                result = NSOrderedAscending;
                break;
            }
            
            if(thisSegment > compareSegment){
                result = NSOrderedDescending;
                break;
            }
        }
    }
    
    return result;
}


-(BOOL)BJCF_isOlderThanVersion:(NSString *)version{
    return ([self BJCF_compareToVersion:version] == NSOrderedAscending);
}

-(BOOL)BJCF_isNewerThanVersion:(NSString *)version{
    return ([self BJCF_compareToVersion:version] == NSOrderedDescending);
}

-(BOOL)BJCF_isEqualToVersion:(NSString *)version{
    return ([self BJCF_compareToVersion:version] == NSOrderedSame);
}

-(BOOL)BJCF_isEqualOrOlderThanVersion:(NSString *)version{
    return ([self BJCF_compareToVersion:version] != NSOrderedDescending);
}

-(BOOL)BJCF_isEqualOrNewerThanVersion:(NSString *)version{
    return ([self BJCF_compareToVersion:version] != NSOrderedAscending);
}

@end
