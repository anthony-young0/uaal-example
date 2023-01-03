#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"


@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end


extern "C" {
    void showHostMainWindow(const char* color) {
        return [api showHostMainWindow:[NSString stringWithUTF8String:color]];
    }
    
    void shout(const char* message, char** userIds, int count) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            NSString *userId = [NSString stringWithUTF8String:userIds[i]];
            [list addObject:userId];
        }
        
        return [api shout:[NSString stringWithUTF8String:message] withUserIds:list];
    }
}

