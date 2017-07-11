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

#import "BJAudioBufferRecorder.h"
#import "BJAudioPlayer.h"
#import "BJRecordAudio.h"
#import "lame.h"

FOUNDATION_EXPORT double YPMediaVersionNumber;
FOUNDATION_EXPORT const unsigned char YPMediaVersionString[];

