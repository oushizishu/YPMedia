#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JLCalendarPermission.h"
#import "JLCameraPermission.h"
#import "JLContactsPermission.h"
#import "JLLocationPermission.h"
#import "JLMicrophonePermission.h"
#import "JLNotificationPermission.h"
#import "JLPermissionsCore+Internal.h"
#import "JLPermissionsCore.h"
#import "JLPhotosPermission.h"
#import "JLRemindersPermission.h"

FOUNDATION_EXPORT double YPPermissionVersionNumber;
FOUNDATION_EXPORT const unsigned char YPPermissionVersionString[];

