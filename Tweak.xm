
#import <MessageUI/MessageUI.h>
#import "Interfaces.h"
#import <objc/runtime.h>
#import <objc/objc.h>
//#import <ChatKit/CKService.h>
#import <xpc/xpc.h>
#import <notify.h>
#import <libobjcipc/objcipc.h>
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]

CKIMMessage* sbMessage = [[CKIMMessage alloc] init];
BOOL isPending;
BOOL enabled;
//BOOL alertActive = NO;
BOOL debug = YES;
NSString* rawAddress;
NSString* reply;
UITextField* responseField;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

@interface CKConversationList (Hermes)
-(void)sendTheMessage;
@end

@implementation CKConversationList (Hermes)
-(void)sendTheMessage {
	CKConversationList* conversationList = [CKConversationList sharedConversationList];
	CKConversation* conversation = [conversationList conversationForExistingChatWithGUID:prefs[@"guid"]];
	reply = responseField.text;
	NSAttributedString* text = [[NSAttributedString alloc] initWithString:reply];
	CKComposition* composition = [[CKComposition alloc] initWithText:text subject:nil];
	CKMessage* smsMessage = [conversation newMessageWithComposition:composition addToConversation:YES];
	[conversation sendMessage:smsMessage newComposition:YES];

	if (debug) NSLog(@"[Hermes3] Touched send button, doing from CKConversationList");
	if (debug) NSLog(@"[Hermes3] rawAddress is %@", rawAddress);
	if (debug) NSLog(@"[Hermes3] conversationList is %@", conversationList);
	if (debug) NSLog(@"[Hermes3] conversationList.conversations is %@", [conversationList conversations]);
	if (debug) NSLog(@"[Hermes3] conversationList description is %@", [conversationList description]);
	if (debug) NSLog(@"[Hermes3] Conversation is %@", conversation);
	if (debug) NSLog(@"[Hermes3] Message is %@", smsMessage);
	if (debug) NSLog(@"[Hermes3] rawAddress is %@", rawAddress);
	if (debug) NSLog(@"[Hermes3] Reply text is %@", text);
}
@end

@interface GarbClass : NSObject <UIAlertViewDelegate>
-(BOOL)hasPendingAlert;
-(UIAlertView*)alertFromCKIMMessage:(CKIMMessage*)obj andType:(NSString*)type withPart:(CKTextMessagePart*)text;
-(UIAlertView*)createQRAlertWithType:(NSString*)type name:(NSString*)name text:(NSString*)text;
-(void)explicitShow:(UIAlertView*)alert;
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
-(void)explicitShow:(UIAlertView*)alert {
	[alert show];
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
    		NSLog(@"Received reply from MobileSMS: %@", response);
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
		NSLog(@"[Hermes3] Hermes shutting down :(");
	}
	else {
		NSLog(@"[Hermes3] Hermes turning on");
	}
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
	%orig;
	loadPrefs();
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@(enabled) forKey:@"enabled"];
	if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
		NSLog(@"[Hermes3] Prefs wrote successfully");
	}
	else {
		NSLog(@"[Hermes3] Prefs didn't write successfully D:");
	}
	//system("open /Applications/MobileSMS.app");
}
%end

%hook UIAlertView 
- (void)show {
	%orig; 
	//alertActive = YES;
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@YES forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];
} 
%end

%hook SMSApplication
- (id)init {
	if ([[prefs objectForKey:@"enabled"] boolValue]) {
		[UIWindow setAllWindowsKeepContextInBackground:NO];
		[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"com.phillipt.hermes.ipc" handler:^NSDictionary *(NSDictionary *message) {
			CKConversationList* conversationList = [CKConversationList sharedConversationList];
			CKConversation* conversation = [conversationList conversationForExistingChatWithAddresses:[NSArray arrayWithObjects:message[@"rawAddress"], nil]];
			NSAttributedString* text = [[NSAttributedString alloc] initWithString:message[@"reply"]];
			CKComposition* composition = [[CKComposition alloc] initWithText:text subject:nil];
			CKMessage* smsMessage = [conversation newMessageWithComposition:composition addToConversation:YES];
			[conversation sendMessage:smsMessage newComposition:YES];

			if (debug) NSLog(@"[Hermes3] Touched send button, doing with IPC! :D");
			if (debug) NSLog(@"[Hermes3] Conversation is %@", conversation);
			if (debug) NSLog(@"[Hermes3] Message is %@", smsMessage);
			if (debug) NSLog(@"[Hermes3] rawAddress is %@", rawAddress);
			if (debug) NSLog(@"[Hermes3] Reply text is %@", text);
    		if (debug) NSLog(@"Received message from SpringBoard: %@", message);

    		return 0;
		}];
	}
	else {
		NSLog(@"[Hermes3] Not enabled, not doing anything");
	}
	return %orig;
}
%end

%hook CKIMMessage

- (BOOL)postMessageReceivedIfNecessary {
	if ([[prefs objectForKey:@"enabled"] boolValue]) {
		NSLog(@"[Hermes3] recieved message");

		sbMessage = self;
		if (debug) NSLog(@"[Hermes3] sbMessage is %@", sbMessage);

		prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

		BOOL isiMessage;
		if (sbMessage.isiMessage) isiMessage = YES;
		else isiMessage = NO;
		NSString* titleType;
		if (isiMessage) titleType = @"iMessage";
		else titleType = @"SMS";

		CKTextMessagePart* text = [[sbMessage parts] objectAtIndex:0];

		[(NSMutableDictionary*)prefs setObject:titleType forKey:@"titleType"];
		[(NSMutableDictionary*)prefs setObject:sbMessage.sender.name forKey:@"displayName"];
		[(NSMutableDictionary*)prefs setObject:text.text.string forKey:@"text"];
		[(NSMutableDictionary*)prefs setObject:sbMessage.sender.rawAddress forKey:@"rawAddress"];
		[(NSMutableDictionary*)prefs setObject:sbMessage.IMMessage.guid forKey:@"guid"];                                                      
		[(NSMutableDictionary*)prefs setObject:@(sbMessage.isOutgoing) forKey:@"isOutgoing"];
		[(NSMutableDictionary*)prefs setObject:@(sbMessage.isFromMe) forKey:@"isFromMe"];
		[(NSMutableDictionary*)prefs setObject:@(sbMessage.isiMessage) forKey:@"isiMessage"];
		//[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"currentMessage"];

		if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			NSLog(@"[Hermes3] Prefs wrote successfully");
		}
		else {
			NSLog(@"[Hermes3] Prefs didn't write successfully D:");
		}

		if (debug) NSLog(@"[Hermes3] Prefs dict is %@", prefs);

		notify_post("com.phillipt.hermes.received");
	}
	else {
		NSLog(@"[Hermes3] Not enabled, not doing anything");
	}

	return %orig;
}

%new
-(void)sendMessage {
	rawAddress = prefs[@"rawAddress"];

	CKConversationList* conversationList = [CKConversationList sharedConversationList];
	CKConversation* conversation = [conversationList conversationForExistingChatWithAddresses:[NSArray arrayWithObjects:rawAddress, nil]];
	reply = responseField.text;
	NSAttributedString* text = [[NSAttributedString alloc] initWithString:reply];
	CKComposition* composition = [[CKComposition alloc] initWithText:text subject:nil];
	CKMessage* smsMessage = [conversation newMessageWithComposition:composition addToConversation:YES];
	[conversation sendMessage:smsMessage newComposition:YES];

	if (debug) NSLog(@"[Hermes3] Touched send button");
	if (debug) NSLog(@"[Hermes3] Conversation is %@", conversation);
	if (debug) NSLog(@"[Hermes3] Message is %@", smsMessage);
	if (debug) NSLog(@"[Hermes3] rawAddress is %@", rawAddress);
	if (debug) NSLog(@"[Hermes3] Reply text is %@", text);
}

%end

@interface UIApplication (Hermes)
-(id)_accessibilityFrontMostApplication;
@end
@interface SBApplication (Hermes)
-(NSString*)bundleIdentifier;
@end

void quickReply() {
	if (debug) NSLog(@"[Hermes3] prefs are %@", [prefs description]);
	if (debug) NSLog(@"[Hermes3] isOutgoing is %@", prefs[@"isOutgoing"]);
	NSLog(@"[Hermes3] Received message");
	//if (![prefs[@"isOutgoing"] boolValue] && ![prefs[@"isFromMe"] boolValue]) {
	SBApplication* currOpen = [[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication];
	NSLog(@"[Hermes3] Currently open application is %@", [currOpen bundleIdentifier]);
	if (![[currOpen bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"]) {
		for (CKMessagePart *part in [sbMessage parts]) {
			if (debug) NSLog(@"[Hermes1] Part is %@", part);
		}
		//if (!isPending) {
		//if (!alertActive) {
		//if (![[prefs objectForKey:@"alertActive"] boolValue]) {
			//rawAddress = sbMessage.sender.rawAddress;
			prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

			rawAddress = prefs[@"rawAddress"];
			UIAlertView* alert = [garb createQRAlertWithType:prefs[@"titleType"] name:prefs[@"displayName"] text:prefs[@"text"]];
			//This is a (very hacky) check to see if we've already shown an alert for this message's GUID, to prevent the same alert popping up in SpringBoard and Messages.
			if (![prefs objectForKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]]) {
				NSLog(@"[Hermes3] We have not already shown an alert for this GUID. Show it!");
				[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
				if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
					NSLog(@"[Hermes3] Prefs wrote successfully");
				}
				else {
					NSLog(@"[Hermes3] Prefs didn't write successfully D:");
				}
				NSLog(@"[Hermes3] Messages was not open, showing alert");
				[alert show];
			}
			else {
				NSLog(@"[Hermes3] We've already shown a message for that GUID!! >:(");
			}
			NSLog(@"[Hermes3] %@ from %@: %@", prefs[@"titleType"], prefs[@"displayName"], prefs[@"text"]);

			//if (debug) NSLog(@"[Hermes3] Prefs dict is %@", prefs);
			NSLog(@"[Hermes3] Prefs dict is %@", prefs);
			//NSLog(@"[Hermes3] Did not have pending alert");
			NSLog(@"[Hermes3] Is showing alert? %@", isPending ? @"True":@"False");
			isPending = YES;
		//}
		//else {
			//isPending = NO;
		//	NSLog(@"[Hermes3] Had pending alert");
		//	NSLog(@"[Hermes3] Is showing alert? %@", isPending ? @"True":@"False");
		//}
	}
	else {
		NSLog(@"[Hermes3] Messages WAS open, not showing alert");
	}
	//}
	//else {
	//	NSLog(@"[Hermes3] Message was from me, not performing any actions");
	//}
	SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.apple.MobileSMS"];
	BKSProcessAssertion *keepAlive = [[BKSProcessAssertion alloc] initWithPID:[app pid] flags:0xF reason:7 name:@"epichax" withHandler:nil];
}

%ctor {
	system("open /Applications/MobileSMS.app");

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)quickReply,
									CFSTR("com.phillipt.hermes.received"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);
/*
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)loadPrefs,
									CFSTR("com.phillipt.hermes.post"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);

	loadPrefs();
*/	
	//quickReply();
}