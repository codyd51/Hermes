#import <MessageUI/MessageUI.h>
#import "Interfaces.h"
#import <objc/runtime.h>
#import <objc/objc.h>
//#import <ChatKit/CKService.h>
//#import <xpc/xpc.h>
#import <notify.h>
#import <libobjcipc/objcipc.h>
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]
#define dla(x, a) if(debug) NSLog(x, a)
#define dl(x) if(debug) NSLog(x)

%hook TGForwardTargetController			//@synthesize sendMessages=_sendMessages - In the implementation block
-(id)initWithForwardMessages:(id)arg1 sendMessages:(id)arg2 {
	%log;
	return %orig;
}
%end
%hook TGGroupModernConversationCompanion
-(id)_sendMessagePathForMessageId:(int)arg1 {
	%log;
	return %orig;
}
%end
%hook TGTcpWorker
-(void)sendData:(id)arg1 {
	%log;
	%orig;
}
%end
%hook TGTLSerialization
-(id)resendMessagesRequest:(id)arg1 {
	%log;
	return %orig;
}
%end

%ctor {
	NSLog(@"[Hermes3 - Telegram] Loading HermesTelegram...");
}