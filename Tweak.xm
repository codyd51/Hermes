
#import <MessageUI/MessageUI.h>
#import "Interfaces.h"
#import <objc/runtime.h>
#import <objc/objc.h>
//#import <ChatKit/CKService.h>
#import <xpc/xpc.h>
#import <notify.h>
#import <libobjcipc/objcipc.h>
#import <Kik/KikUser.h>
#import <Kik/KikUserHelper.h>
#import <Kik/KikChatHelper.h>
#import <Kik/CoreDataConversationManager.h>
#import <Kik/CoreDataConversation.h>
#import <Kik/KikStorage.h>
#import <Kik/Tokener.h>
#import <Kik/XDataManager.h>
#import <Kik/MetricsDataHandler.h>
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]
#define dla(x, a) if(debug) NSLog(x, a)
#define dl(x) if(debug) NSLog(x)

CKIMMessage* sbMessage = [[CKIMMessage alloc] init];
BOOL isPending;
BOOL enabled;
//BOOL alertActive = NO;
BOOL debug = YES;
NSString* rawAddress;
NSString* reply;
UITextField* responseField;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

@interface NSConcreteNotification : NSObject
@property NSDictionary* userInfo;
@end
@interface GarbClass : NSObject <UIAlertViewDelegate>
-(BOOL)hasPendingAlert;
-(UIAlertView*)alertFromCKIMMessage:(CKIMMessage*)obj andType:(NSString*)type withPart:(CKTextMessagePart*)text;
-(UIAlertView*)createQRAlertWithType:(NSString*)type name:(NSString*)name text:(NSString*)text;
@end
@implementation GarbClass
//This code does not work on iOS 7. Apparantly, no references back to UIAlertView are kept in the keyWindow. Tl;Dr this code is useless, hence the 'isPending' variable. I'm leaving it here in case anyone wants to figure out how to make it work
-(BOOL)hasPendingAlert {
	for (UIWindow* window in [UIApplication sharedApplication].windows){
		for (UIView *subView in [window subviews]){
			if ([subView isKindOfClass:[UIAlertView class]]) {
				return YES;
			}
			else {
				return NO;
			}
		}
	}
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
		NSArray* subviews = window.subviews;
		if ([subviews count] > 0) {
		BOOL alert = [[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]];
		BOOL action = [[subviews objectAtIndex:0] isKindOfClass:[UIActionSheet class]];
		if (alert || action)
			return YES;
		}
	}
	return NO;
}
-(UIAlertView*)createQRAlertWithType:(NSString*)type name:(NSString*)name text:(NSString*)text {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ from %@", type, name] message:[NSString stringWithFormat:@"\"%@\"", text] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", /*@"Open Messages",*/ nil];
	[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
	responseField = [alert textFieldAtIndex:0];
	[alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
	[alert textFieldAtIndex:0].autocorrectionType = YES;
	[responseField setPlaceholder:@"Enter response here"];
	alert.delegate = self;
	if ([type isEqualToString:@"SMS"]) {
		alert.tintColor = [UIColor greenColor];
	}
	else {
		alert.tintColor = [UIColor blueColor];
	}
	return alert;
}
-(UIAlertView*)alertFromCKIMMessage:(CKIMMessage*)obj andType:(NSString*)type withPart:(CKTextMessagePart*)text {
	UIAlertView* alert = [self createQRAlertWithType:type name:obj.sender.name text:text.text.string];
	return alert;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	isPending = NO;
	//alertActive = NO;
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

	if (buttonIndex != [alertView cancelButtonIndex]) {
		if (buttonIndex != 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
		}
		else {
			[(NSMutableDictionary*)prefs setObject:responseField.text forKey:@"reply"];
			[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

			reply = responseField.text;
			NSDictionary* responseInfoDict = @{
				@"reply" : reply,
				@"rawAddress" : prefs[@"rawAddress"]
			};

			[OBJCIPC sendMessageToAppWithIdentifier:@"com.apple.MobileSMS" messageName:@"com.phillipt.hermes.ipc" dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
    			dla(@"Received reply from MobileSMS: %@", response);
			}];
		}
	}
	else {
		isPending = NO;
	}
}
@end
@interface KikGarbClass : GarbClass <UIAlertViewDelegate>
@end
@implementation KikGarbClass
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	isPending = NO;
	//alertActive = NO;
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

	if (buttonIndex != [alertView cancelButtonIndex]) {
		if (buttonIndex != 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"kik://"]];
		}
		else {
			[(NSMutableDictionary*)prefs setObject:responseField.text forKey:@"reply"];
			[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

			reply = responseField.text;
			NSDictionary* responseInfoDict = @{
				@"reply" : reply,
				@"displayName" : prefs[@"displayName"],
				@"jid" : prefs[@"jid"],
				@"kikUser" : prefs[@"kikUser"]
			};

			[OBJCIPC sendMessageToAppWithIdentifier:@"com.kik.chat" messageName:@"com.phillipt.hermes.kik" dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
    			dla(@"Received reply from Kik: %@", response);
			}];
		}
	}
	else {
		isPending = NO;
	}
}
@end

GarbClass* garb = [[GarbClass alloc] init];

void loadPrefs() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

	if ([prefs objectForKey:@"enabled"] == nil) enabled = NO;
	else enabled = [[prefs objectForKey:@"enabled"] boolValue];

	if (!enabled) {
		dl(@"[Hermes3] Hermes shutting down :(");
	}
	else {
		dl(@"[Hermes3] Hermes turning on");
	}
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
	%orig;
	loadPrefs();
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@(enabled) forKey:@"enabled"];

	[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"com.phillipt.hermes.kikMsgSend"  handler:^NSDictionary *(NSDictionary *message) {
    	[(NSMutableDictionary*)prefs setObject:message[@"titleType"] forKey:@"titleType"];
    	[(NSMutableDictionary*)prefs setObject:message[@"displayName"] forKey:@"displayName"];
    	[(NSMutableDictionary*)prefs setObject:message[@"text"] forKey:@"text"];
    	[(NSMutableDictionary*)prefs setObject:message[@"jid"] forKey:@"jid"];
    	[(NSMutableDictionary*)prefs setObject:message[@"kikUser"] forKey:@"kikUser"];
    	if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			dl(@"[Hermes3] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3] Prefs didn't write successfully D:");
		}
    	return 0;
	}];

	if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
		dl(@"[Hermes3] Prefs wrote successfully");
	}
	else {
		dl(@"[Hermes3] Prefs didn't write successfully D:");
	}
	//system("open /Applications/MobileSMS.app");
}
%end

%hook UIAlertView 
- (void)show {
	//alertActive = YES;
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@YES forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];
	//if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"]) {
		%orig;
	//}
} 
%end

@interface UIApplication (Hermes)
-(id)_accessibilityFrontMostApplication;
@end
@interface SBApplication (Hermes)
-(NSString*)bundleIdentifier;
@end

%ctor {
	system("open /Applications/MobileSMS.app");
}
