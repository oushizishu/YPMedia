//
//  Jockey.m
//  JockeyJS
//
//  Copyright (c) 2013, Tim Coulter
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "BJCFJockey.h"
@interface BJCFJockey ()

- (void)triggerEventFromWebView:(UIWebView*)webView withData:(NSDictionary*)envelope;
- (void)triggerCallbackOnWebView:(UIWebView*)webView forMessage:(NSString*)messageId;
- (void)triggerCallbackForMessage:(NSNumber*)messageId;
@end

@implementation BJCFJockey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageCount = @0;
        _listeners = [[NSMutableDictionary alloc] init];
        _callbacks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)on:(NSString*)type perform:(BJCFJockeyHandler)handler
{
    void (^ extended)(UIWebView *webView, NSDictionary *payload, void (^ complete)()) = ^(UIWebView *webView, NSDictionary *payload, void(^ complete)()) {
        handler(payload);
        complete();
    };
    
    [self on:type performAsync:extended];
}

- (void)on:(NSString *)type performAsync:(BJCFJockeyAsyncHandler)handler
{
    BJCFJockey *instance = self;
    
    NSDictionary *listeners = [instance listeners];
    
    NSMutableArray *listenerList = [listeners objectForKey:type];
    
    if (listenerList == nil) {
        listenerList = [[NSMutableArray alloc] init];
        
        [instance.listeners setValue:listenerList forKey:type];
    }
    [listenerList addObject:handler];
}

- (void)off:(NSString *)type {
    NSMutableDictionary *listeners = [self listeners];
    [listeners removeObjectForKey:type];
}

- (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView
{
    [self send:type withPayload:payload toWebView:webView perform:nil];
}

- (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView perform:(void (^)())complete {
    BJCFJockey *jockey = self;
    
    NSNumber *messageId = jockey.messageCount;
    
    if (complete != nil) {
        [jockey.callbacks setValue:complete forKey:[messageId stringValue]];
    }
    
    NSError *err;
    if (payload == nil){
        payload = @{};
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *javascript = [NSString stringWithFormat:@"Jockey.trigger(\"%@\", %@, %@);", type, @([messageId integerValue]), jsonString];
    
    [webView stringByEvaluatingJavaScriptFromString:javascript];
    
    jockey.messageCount = @([jockey.messageCount integerValue] + 1);
}

- (BOOL)webView:(UIWebView*)webView withUrl:(NSURL*)url
{
    if ( [[url scheme] isEqualToString:@"jockey"] )
    {
        
        NSString *eventType = [url host];
        NSString *messageId = [[url path] substringFromIndex:1];
        NSString *query = [url query];
        NSString *jsonString = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options: NSJSONReadingMutableContainers
                                                               error: &error];
        
        // NSLog(@"jockey:%@",JSON);
        if ([eventType isEqualToString:@"event"]) {
            [self triggerEventFromWebView:webView withData:JSON];
        } else if ([eventType isEqualToString:@"callback"]) {
            [self triggerCallbackForMessage:@([messageId integerValue])];
        }
//        DLog(@"%@,%@,%@",[self messageCount],[self listeners],[self callbacks]);
        return NO;
    }
    return YES;
}

- (void)triggerEventFromWebView:(UIWebView*)webView withData:(NSDictionary*)envelope
{
    NSDictionary *listeners = [self listeners];
    
    NSString *messageId = [envelope objectForKey:@"id"];
    NSString *type = [envelope objectForKey:@"type"];
    
    NSDictionary *payload = [envelope objectForKey:@"payload"];
    
    NSArray *listenerList = (NSArray*)[listeners objectForKey:type];

    __block NSInteger executedCount = 0;
    
    void (^complete)() = ^() {
        executedCount += 1;
        
        if (executedCount >= [listenerList count]) {
            [self triggerCallbackOnWebView:webView forMessage:messageId];
        }
    };
    
    for (BJCFJockeyAsyncHandler handler in listenerList) {
        handler(webView, payload, complete);
    }
}

- (void)triggerCallbackOnWebView:(UIWebView*)webView forMessage:(NSString*)messageId
{
    NSString *javascript = [NSString stringWithFormat:@"Jockey.triggerCallback(\"%@\");", messageId];
    
    [webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)triggerCallbackForMessage:(NSNumber *)messageId {
    NSString *messageIdString = [messageId stringValue];
    
    void (^ callback)() = [_callbacks objectForKey:messageIdString];
    
    if (callback != nil) {
        callback();
    }
    
    [_callbacks removeObjectForKey:messageIdString];
}

@end
