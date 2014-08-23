#import "Interfaces.h"
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]
#define dla(x, a) if(debug) NSLog(x, a)
#define dl(x) if(debug) NSLog(x)

@class SBApplication, BKSProcessAssertion;
id storage;
BOOL isPending;
//BOOL enabled;
//BOOL alertActive = NO;
BOOL debug = NO;
NSString* rawAddress;
NSString* reply;
UITextField* responseField;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

WhatsAppGarbClass* whatsAppGarb = [[%c(WhatsAppGarbClass) alloc] init];
%group WhatsApp
%hook ChatManager
-(id)init {
	NSLog(@"[Hermes3 - WhatsApp] ChatManager init");
	//if ([[prefs objectForKey:@"enabled"] boolValue]) {
		[UIWindow setAllWindowsKeepContextInBackground:NO];

		dispatch_async(dispatch_get_main_queue(), ^{
			[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"com.phillipt.hermes.whatsapp" handler:^NSDictionary *(NSDictionary *message) {
				dla(@"[Hermes3 - WhatsApp] Received message from SpringBoard: %@", message);
				storage = [%c(ChatManager) sharedManager].storage;
				//WAChatSession* chat = [storage existingChatSessionForJID:@"12243003315@s.whatsapp.net"];
				WAChatSession* chat = [storage existingChatSessionForJID:message[@"jid"]];
				WAMessage* waMessage = [storage messageWithText:message[@"reply"] inChatSession:chat isBroadcast:YES];
				[storage sendMessage:waMessage notify:YES];
				dl(@"[Hermes3 - WhatsApp] Sending WhatsApp message :D");

    			return 0;
			}];
		});
	//}
	//else {
		//NSLog(@"[Hermes3 - WhatsApp] Not enabled");
	//}
	storage = self.storage;
	return %orig;
}
-(void)receiveChatMessages:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] receiveChatMessages: %@", arg1);
	%orig;
}
-(void)chatStorage:(id)arg1 didReceiveMessage:(id)arg2 {
	%log;
	NSLog(@"[Hermes - WhatsApp] chatStorage: %@ didReceiveMessage: %@", arg1, arg2);
	//NSConcreteNotification* notif = arg2;
	//NSDictionary* userInfo = notif.userInfo;
	//NSLog(@"[WhatsAppTest] userInfo is %@", userInfo);
	WAMessage* message = (WAMessage*)arg2;

	NSMutableDictionary* whatsAppMessage = [[NSMutableDictionary alloc] init];
	[whatsAppMessage setObject:@"WhatsApp" forKey:@"titleType"];
	//NSString* dispNameFull = [userInfo objectForKey:@"chatUserJid"];
	//NSRange range= [dispNameFull rangeOfString: @"@" options: NSBackwardsSearch];
	//NSString* displayName= [dispNameFull substringToIndex:range.location];

	//WhatsAppUserHelper* helper = [[%c(WhatsAppUserHelper) alloc] initWithManagedObjectContext:storage.managedObjectContext];
	//WhatsAppUser* user = [helper userWithJid:[userInfo objectForKey:@"chatUserJid"]];
	//NSLog(@"[Hermes3 - WhatsApp] dispNameFull is %@", dispNameFull);
	//NSLog(@"[Hermes3 - WhatsApp] user is %@", user);
	//NSString* displayName = user.nameForDisplay;

	//[kikMessage setObject:displayName forKey:@"displayName"];
	[whatsAppMessage setObject:message.fromJID forKey:@"responseJID"];
	if (message.text != nil && ![message.text isEqualToString:@""]) [whatsAppMessage setObject:message.text forKey:@"text"];
	else [whatsAppMessage setObject:[NSString stringWithFormat:@"%@ has sent you a picture message!", message.pushName] forKey:@"text"];
	[whatsAppMessage setObject:message.pushName forKey:@"displayName"];
	//[kikMessage setObject:user.username forKey:@"kikUser"];
	//[kikMessage setObject:[userInfo objectForKey:@"chatUserJid"] forKey:@"jid"];
	//[kikMessage setObject:[userInfo objectForKey:@"messageContent"] forKey:@"text"];

	//NSLog(@"[Hermes3 - WhatsApp] kikMessage is %@", kikMessage);

	//if ([[prefs objectForKey:@"enabled"] boolValue]) {
		dl(@"[Hermes3 - WhatsApp] recieved WhatsApp message");

		NSLog(@"[Hermes3 - WhatsApp] whatsAppMessage is %@", whatsAppMessage);

		NSString* titleType = @"WhatsApp";

		NSDictionary *reply = [OBJCIPC sendMessageToSpringBoardWithMessageName:@"com.phillipt.hermes.WhatsAppMsgSend" dictionary:whatsAppMessage];

		//notify_post("com.phillipt.hermes.whatsAppReceived");
	//}
	//else {
	//	dl(@"[Hermes3 - WhatsApp] Not enabled, not doing anything");
	//}
	%orig;
}
%end

%hook WAChatStorage
-(void)sendMessage:(id)arg1 notify:(BOOL)arg2 {
	%log;
	NSLog(@"[Hermes - WhatsApp] sendMessage: %@ notify: %d", arg1, arg2);
	%orig;
}
-(void)receiveChatMessages:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] receiveChatMessages: %@", arg1);
	%orig;
}
%end

%hook XMPPConnection 
-(void)xmppStream:(id)arg1 didReceiveMessages:(id)arg2 {
	%log;
	NSLog(@"[Hermes - WhatsApp] xmppStream: %@ didReceiveMessages: %@", arg1, arg2);
	%orig;
}
%end
%end
void whatsReply() {
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	NSLog(@"[Hermes3 - WhatsApp] WhatsApp message received!");
	SBApplication* currOpen = [[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication];
	dla(@"[Hermes3 - WhatsApp] Currently open application is %@", [currOpen bundleIdentifier]);
/*
	if (![[currOpen bundleIdentifier] isEqualToString:@"com.kik.chat"]) {
		dl(@"[Hermes3 - Kik] Kik was not open, writing NO to plist");
		[(NSMutableDictionary*)prefs setObject:@NO forKey:@"mesOpen"];
		if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			dl(@"[Hermes3 - Kik] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3 - Kik] Prefs didn't write successfully D:");
		}
	}
	else {
		dl(@"[Hermes3 - Kik] Kik WAS open, writing YES to plist");
		[(NSMutableDictionary*)prefs setObject:@YES forKey:@"mesOpen"];
		//So heres another hackey solution since the message tried to show in both Messages and SpringBoard; we'll make it think it's already shown a message for this GUID.
		[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
		if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
			dl(@"[Hermes3 - Kik] Prefs wrote successfully");
		}
		else {
			dl(@"[Hermes3 - Kik] Prefs didn't write successfully D:");
		}
	}
*/
	//dla(@"[Hermes3 - WhatsApp] prefs are %@", [prefs description]);
	//dla(@"[Hermes3 - Kik] isOutgoing is %@", prefs[@"isOutgoing"]);
	//if (![prefs[@"isOutgoing"] boolValue] && ![prefs[@"isFromMe"] boolValue]) {

	//if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"net.whatsapp.WhatsApp"]) {
		//if (![prefs[@"mesOpen"] boolValue]) {
			//if (!isPending) {
			//if (!alertActive) {
			//if (![[prefs objectForKey:@"alertActive"] boolValue]) {
				//rawAddress = sbMessage.sender.rawAddress;

				rawAddress = prefs[@"rawAddress"];
				//if (!prefs[@"alertActive"]) {
					UIAlertView* alert = [whatsAppGarb createQRAlertWithType:prefs[@"titleType"] name:prefs[@"displayName"] text:prefs[@"text"]];
					//This is a (very hacky) check to see if we've already shown an alert for this message's GUID, to prevent the same alert popping up in SpringBoard and Kik.
					//if (![prefs objectForKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]]) {
						dl(@"[Hermes3 - WhatsApp] We have not already shown an alert for this GUID. Show it!");
						[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
						if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
							dl(@"[Hermes3 - WhatsApp] Prefs wrote successfully");
						}
						else {
							dl(@"[Hermes3 - WhatsApp] Prefs didn't write successfully D:");
						}
						dl(@"[Hermes3 - WhatsApp] WhatsApp was not open, showing alert");
						[alert show];
						dl(@"[Hermes3 - WhatsApp] ALL CHECKS SUCCEEDED showing alert...");
					//}
					//else {
					//	dl(@"[Hermes3 - Kik] We've already shown a message for that GUID!! >:(");
					//}
				//}
				//else {
				//	NSLog(@"[Hermes - Kik] Alert was active");
				//}
				if (debug) NSLog(@"[Hermes3 - WhatsApp] %@ from %@: %@", prefs[@"titleType"], prefs[@"displayName"], prefs[@"text"]);

				//if (debug) NSLog(@"[Hermes3] Prefs dict is %@", prefs);
				//dla(@"[Hermes3 - Kik] Prefs dict is %@", prefs);
				//NSLog(@"[Hermes3] Did not have pending alert");
				dla(@"[Hermes3 - WhatsApp] Is showing alert? %@", isPending ? @"True":@"False");
				isPending = YES;
			//}
			//else {
				//isPending = NO;
			//	NSLog(@"[Hermes3 - Kik] Had pending alert");
			//	NSLog(@"[Hermes3 - Kik] Is showing alert? %@", isPending ? @"True":@"False");
			//}
		//}
		//else {
		//	dl(@"[Hermes3 - Kik] Kik WAS open, not showing alert");
		//}
	//}
	//else {
	//	dl(@"[Hermes3 - WhatsApp] WhatsApp was open brah :(");
	//}
	//}
	//else {
	//	NSLog(@"[Hermes3] Message was from me, not performing any actions");
	//}
	SBApplication *mesApp = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"net.whatsapp.WhatsApp"];
	BKSProcessAssertion *keepAlive = [[BKSProcessAssertion alloc] initWithPID:[mesApp pid] flags:0xF reason:7 name:@"epichax" withHandler:nil];
}

%ctor {
	system("open /Applications/WhatsApp.app");
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)whatsReply,
									CFSTR("com.phillipt.hermes.whatsAppReceived"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);

	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	//if ([prefs[@"whatsUse"] boolValue]) %init(WhatsApp);	
	%init(WhatsApp);
}

@interface CyHelper : NSObject
+(id)storage;
@end
@implementation CyHelper
+(id)storage {
	return storage;
}
@end