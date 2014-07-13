#import "Interfaces.h"
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.hermes.plist"]
#define dla(x, a) if(debug) NSLog(x, a)
#define dl(x) if(debug) NSLog(x)

@class SBApplication, BKSProcessAssertion;
KikStorage* storage;
id network;
id userManager;
id messageManager;
id chatManager;
id accountManager;
id attachmentManager;
id userHelper;
id chatHelper;
id user;
id chat;
id conversation;
CoreDataConversationManager* manager;
BOOL isPending;
//BOOL enabled;
//BOOL alertActive = NO;
BOOL debug = YES;
NSString* rawAddress;
NSString* reply;
UITextField* responseField;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

KikGarbClass* kikGarb = [[%c(KikGarbClass) alloc] init];
%group Kik
%hook CoreDataConversationManager

-(id)initWithStorage:(id)arg1 andNetwork:(id)arg2 andUserManager:(id)arg3 andMessageManager:(id)arg4 andChatManager:(id)arg5 andAccountManager:(id)arg6 andAttachmentManager:(id)arg7 { 
	id r = %orig;

	NSLog(@"[Hermes3 - Kik] CoreDataConversationManager init");
	//if ([[prefs objectForKey:@"enabled"] boolValue]) {
		[UIWindow setAllWindowsKeepContextInBackground:NO];

		storage = arg1;
		network = arg2;
		userManager = arg3;
		messageManager = arg4;
		chatManager = arg5;
		accountManager = arg6;
		attachmentManager = arg7;
		manager = self;

		dispatch_async(dispatch_get_main_queue(), ^{
			[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"com.phillipt.hermes.kik" handler:^NSDictionary *(NSDictionary *message) {
				dla(@"[Hermes3 - Kik] Received message from SpringBoard: %@", message);
				userHelper = [[%c(KikUserHelper) alloc] initWithManagedObjectContext:storage.managedObjectContext];
				NSLog(@"[Hermes3 - Kik] managedObjectContext is %@", storage.managedObjectContext);
				dla(@"[Hermes3 - Kik] UserHelper is %@", userHelper);
				NSLog(@"[Hermes3 - Kik] allUsers %@", [userHelper allUsers]);
				chatHelper = [[%c(KikChatHelper) alloc] initWithManagedObjectContext:storage.managedObjectContext];
				dla(@"[Hermes3 - Kik] ChatHelper is %@", chatHelper);
				NSString* respUserName = [NSString stringWithFormat:@"%@", message[@"kikUser"]];
				//user = [userHelper userWithUsername:respUserName];
				user = [userHelper userWithJid:message[@"jid"]];
				dla(@"[Hermes3 - Kik] User is %@", user);
				chat = [chatHelper chatForUser:user];
				dla(@"[Hermes3 - Kik] Chat is is %@", chat);
				conversation = [[%c(CoreDataConversation) alloc] initWithKikChat:chat];
				[manager sendTextMessage:message[@"reply"] toConversation:conversation];

				dl(@"[Hermes3 - Kik] Sending Kik message! :D");

    			return 0;
			}];
		});
	//}
	//else {
	//	dl(@"[Hermes3 - Kik] Not enabled, not doing anything");
	//}
	return r; 
}

%end

%hook ChatManager

-(void)messageReceivedHandler:(id)arg1 {
	NSConcreteNotification* notif = arg1;
	NSDictionary* userInfo = notif.userInfo;
	NSLog(@"[KikTest] userInfo is %@", userInfo);

	NSMutableDictionary* kikMessage = [[NSMutableDictionary alloc] init];
	[kikMessage setObject:@"Kik" forKey:@"titleType"];
	NSString* dispNameFull = [userInfo objectForKey:@"chatUserJid"];
	NSRange range= [dispNameFull rangeOfString: @"@" options: NSBackwardsSearch];
	//NSString* displayName= [dispNameFull substringToIndex:range.location];

	KikUserHelper* helper = [[%c(KikUserHelper) alloc] initWithManagedObjectContext:storage.managedObjectContext];
	KikUser* user = [helper userWithJid:[userInfo objectForKey:@"chatUserJid"]];
	NSLog(@"[Hermes3 - Kik] dispNameFull is %@", dispNameFull);
	NSLog(@"[Hermes3 - Kik] user is %@", user);
	NSString* displayName = user.nameForDisplay;

	[kikMessage setObject:displayName forKey:@"displayName"];
	[kikMessage setObject:user.username forKey:@"kikUser"];
	[kikMessage setObject:[userInfo objectForKey:@"chatUserJid"] forKey:@"jid"];
	[kikMessage setObject:[userInfo objectForKey:@"messageContent"] forKey:@"text"];

	NSLog(@"[Hermes3 - Kik] kikMessage is %@", kikMessage);

	//if ([[prefs objectForKey:@"enabled"] boolValue]) {
		dl(@"[Hermes3 - Kik] recieved kik message");

		NSString* titleType = @"Kik";

		NSDictionary *reply = [OBJCIPC sendMessageToSpringBoardWithMessageName:@"com.phillipt.hermes.kikMsgSend" dictionary:kikMessage];

		//notify_post("com.phillipt.hermes.kikReceived");
	//}
	//else {
	//	dl(@"[Hermes3 - Kik] Not enabled, not doing anything");
	//}
	%orig; 
}

%end
%end
void kikReply() {
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.kik.chat" suspended:YES];
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	NSLog(@"[Hermes3 - Kik] Kik message received!");
	SBApplication* currOpen = [[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication];
	dla(@"[Hermes3 - Kik] Currently open application is %@", [currOpen bundleIdentifier]);
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
	//dla(@"[Hermes3 - Kik] prefs are %@", [prefs description]);
	//dla(@"[Hermes3 - Kik] isOutgoing is %@", prefs[@"isOutgoing"]);
	//if (![prefs[@"isOutgoing"] boolValue] && ![prefs[@"isFromMe"] boolValue]) {

	//if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.kik.chat"]) {
		//if (![prefs[@"mesOpen"] boolValue]) {
			//if (!isPending) {
			//if (!alertActive) {
			//if (![[prefs objectForKey:@"alertActive"] boolValue]) {
				//rawAddress = sbMessage.sender.rawAddress;

				rawAddress = prefs[@"rawAddress"];
				//if (!prefs[@"alertActive"]) {
					UIAlertView* alert = [kikGarb createQRAlertWithType:prefs[@"titleType"] name:prefs[@"displayName"] text:prefs[@"text"]];
					//This is a (very hacky) check to see if we've already shown an alert for this message's GUID, to prevent the same alert popping up in SpringBoard and Kik.
					//if (![prefs objectForKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]]) {
						//dl(@"[Hermes3 - Kik] We have not already shown an alert for this GUID. Show it!");
						//[(NSMutableDictionary*)prefs setObject:@YES forKey:[NSString stringWithFormat:@"shownMessageForGUID:%@", prefs[@"guid"]]];
						//if ([(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES]) {
						//	dl(@"[Hermes3 - Kik] Prefs wrote successfully");
						//}
						//else {
						//	dl(@"[Hermes3 - Kik] Prefs didn't write successfully D:");
						//}
						//dl(@"[Hermes3 - Kik] Kik was not open, showing alert");
						[alert show];
						dl(@"[Hermes3 - Kik] ALL CHECKS SUCCEEDED showing alert...");
					//}
					//else {
					//	dl(@"[Hermes3 - Kik] We've already shown a message for that GUID!! >:(");
					//}
				//}
				//else {
				//	NSLog(@"[Hermes - Kik] Alert was active");
				//}
				if (debug) NSLog(@"[Hermes3 - Kik] %@ from %@: %@", prefs[@"titleType"], prefs[@"displayName"], prefs[@"text"]);

				//if (debug) NSLog(@"[Hermes3] Prefs dict is %@", prefs);
				dla(@"[Hermes3 - Kik] Prefs dict is %@", prefs);
				//NSLog(@"[Hermes3] Did not have pending alert");
				dla(@"[Hermes3 - Kik] Is showing alert? %@", isPending ? @"True":@"False");
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
	//	dl(@"[Hermes3 - Kik] Kik was open brah :(");
	//}
	//}
	//else {
	//	NSLog(@"[Hermes3] Message was from me, not performing any actions");
	//}
	SBApplication *mesApp = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.kik.chat"];
	BKSProcessAssertion *keepAlive = [[BKSProcessAssertion alloc] initWithPID:[mesApp pid] flags:0xF reason:7 name:@"epichax" withHandler:nil];
}

%ctor {
	system("open /Applications/Kik.app");
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)kikReply,
									CFSTR("com.phillipt.hermes.kikReceived"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);

	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	//if ([prefs[@"kikUse"] boolValue]) %init(Kik);	
	%init(Kik);
}