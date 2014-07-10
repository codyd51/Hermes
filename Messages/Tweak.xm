#import <notify.h>
#import <libobjcipc/objcipc.h>
#import <objc/runtime.h>
#import <objc/objc.h>
#import "Interfaces.h"
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]
#define dla(x, a) if(debug) NSLog(x, a)
#define dl(x) if(debug) NSLog(x)

@class GarbClass;
CKIMMessage* sbMessage = [[CKIMMessage alloc] init];
BOOL isPending;
BOOL enabled;
//BOOL alertActive = NO;
BOOL debug = YES;
NSString* rawAddress;
NSString* reply;
UITextField* responseField;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
GarbClass* garb = [[%c(GarbClass) alloc] init];

@interface UIApplication (HermesKik)
-(id)_accessibilityFrontMostApplication;
@end
@interface SBApplication (HermesKik)
-(id)bundleIdentifier;
@end
@interface GarbClass
-(UIAlertView*)createQRAlertWithType:(NSString*)type name:(NSString*)name text:(NSString*)text;
@end

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

			dl(@"[Hermes3] Touched send button, doing with IPC! :D");
			dla(@"[Hermes3] Conversation is %@", conversation);
			dla(@"[Hermes3] Message is %@", smsMessage);
			dla(@"[Hermes3] rawAddress is %@", rawAddress);
			dla(@"[Hermes3] Reply text is %@", text);
    		dla(@"Received message from SpringBoard: %@", message);

    		return 0;
		}];
	}
	else {
		dl(@"[Hermes3] Not enabled, not doing anything");
	}
	return %orig;
}
%end

%hook CKIMMessage

- (BOOL)postMessageReceivedIfNecessary {
	if ([[prefs objectForKey:@"enabled"] boolValue]) {
		dl(@"[Hermes3] recieved message");

		sbMessage = self;
		dla(@"[Hermes3] sbMessage is %@", sbMessage);

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
			dl(@"[Hermes3] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3] Prefs didn't write successfully D:");
		}

		dla(@"[Hermes3] Prefs dict is %@", prefs);

		notify_post("com.phillipt.hermes.received");
	}
	else {
		dl(@"[Hermes3] Not enabled, not doing anything");
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

	dl(@"[Hermes3] Touched send button");
	dla(@"[Hermes3] Conversation is %@", conversation);
	dla(@"[Hermes3] Message is %@", smsMessage);
	dla(@"[Hermes3] rawAddress is %@", rawAddress);
	dla(@"[Hermes3] Reply text is %@", text);
}

%end

void quickReply() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	if (prefs) {
	SBApplication* currOpen = [[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication];
	dla(@"[Hermes3] Currently open application is %@", [currOpen bundleIdentifier]);
/*
	if (![[currOpen bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"]) {
		dl(@"[Hermes3] Messages was not open, writing NO to plist");
		[(NSMutableDictionary*)prefs setObject:@NO forKey:@"mesOpen"];
		if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			dl(@"[Hermes3] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3] Prefs didn't write successfully D:");
		}
	}
	else {
		dl(@"[Hermes3] Messages WAS open, writing YES to plist");
		[(NSMutableDictionary*)prefs setObject:@YES forKey:@"mesOpen"];
		//So heres another hackey solution since the message tried to show in both Messages and SpringBoard; we'll make it think it's already shown a message for this GUID.
		[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
		if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			dl(@"[Hermes3] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3] Prefs didn't write successfully D:");
		}
	}
*/
	dla(@"[Hermes3] prefs are %@", [prefs description]);
	dla(@"[Hermes3] isOutgoing is %@", prefs[@"isOutgoing"]);
	dl(@"[Hermes3] Received message");
	//if (![prefs[@"isOutgoing"] boolValue] && ![prefs[@"isFromMe"] boolValue]) {

	//if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.MobileSMS"] && ![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		//if (![prefs[@"mesOpen"] boolValue]) {
			//if (!isPending) {
			//if (!alertActive) {
			//if (![[prefs objectForKey:@"alertActive"] boolValue]) {
				//rawAddress = sbMessage.sender.rawAddress;

				rawAddress = prefs[@"rawAddress"];
				if (![prefs[@"alertActive"] boolValue]) {
					UIAlertView* alert = [garb createQRAlertWithType:prefs[@"titleType"] name:prefs[@"displayName"] text:prefs[@"text"]];
					//This is a (very hacky) check to see if we've already shown an alert for this message's GUID, to prevent the same alert popping up in SpringBoard and Messages.
					if (![prefs objectForKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]]) {
						dl(@"[Hermes3] We have not already shown an alert for this GUID. Show it!");
						[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
						if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
							dl(@"[Hermes3] Prefs wrote successfully");
						}
						else {
							dl(@"[Hermes3] Prefs didn't write successfully D:");
						}
						dl(@"[Hermes3] Messages was not open, showing alert");
						[alert show];
						dl(@"[Hermes3] ALL CHECKS SUCCEEDED showing alert...");
					}
					else {
						dl(@"[Hermes3] We've already shown a message for that GUID!! >:(");
					}
				}
				else {
					NSLog(@"[Hermes3] alertActive was true");
				}
				if (debug) NSLog(@"[Hermes3] %@ from %@: %@", prefs[@"titleType"], prefs[@"displayName"], prefs[@"text"]);

				//if (debug) NSLog(@"[Hermes3] Prefs dict is %@", prefs);
				dla(@"[Hermes3] Prefs dict is %@", prefs);
				//NSLog(@"[Hermes3] Did not have pending alert");
				dla(@"[Hermes3] Is showing alert? %@", isPending ? @"True":@"False");
				isPending = YES;
			//}
			//else {
				//isPending = NO;
			//	NSLog(@"[Hermes3] Had pending alert");
			//	NSLog(@"[Hermes3] Is showing alert? %@", isPending ? @"True":@"False");
			//}
		//}
		//else {
		//	dl(@"[Hermes3] Messages WAS open, not showing alert");
		//}
	//}
	//else {
	//	dl(@"[Hermes3] Messages was open brah :(");
	//}
	//}
	//else {
	//	NSLog(@"[Hermes3] Message was from me, not performing any actions");
	//}
	SBApplication *mesApp = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.apple.MobileSMS"];
	BKSProcessAssertion *keepAlive = [[BKSProcessAssertion alloc] initWithPID:[mesApp pid] flags:0xF reason:7 name:@"epichax" withHandler:nil];
	}
	else {
		dl(@"[Hermes3] Prefs was not valid");
	}
}

%ctor {
	system("open /Applications/MobileSMS.app");

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)quickReply,
									CFSTR("com.phillipt.hermes.received"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);
}