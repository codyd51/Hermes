#import "Interfaces.h"
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
BOOL pirated;
int appFrom;
NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];

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
	[alert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeYes;
	[alert textFieldAtIndex:0].enablesReturnKeyAutomatically = YES;
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

			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
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

			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.kik.chat" suspended:YES];
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
@interface WhatsAppGarbClass : GarbClass <UIAlertViewDelegate>
@end
@implementation WhatsAppGarbClass
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	isPending = NO;
	//alertActive = NO;
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

	if (buttonIndex != [alertView cancelButtonIndex]) {
		if (buttonIndex != 1) {
			//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"kik://"]];
		}
		else {
			[(NSMutableDictionary*)prefs setObject:responseField.text forKey:@"reply"];
			[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:YES];

			reply = responseField.text;
			NSDictionary* responseInfoDict = @{
				@"reply" : reply,
				//@"displayName" : prefs[@"displayName"],
				@"jid" : prefs[@"jid"],
				//@"kikUser" : prefs[@"kikUser"]
			};

			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];
			[OBJCIPC sendMessageToAppWithIdentifier:@"net.whatsapp.WhatsApp" messageName:@"com.phillipt.hermes.whatsapp" dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
    			dla(@"Received reply from WhatsApp: %@", response);
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

	if (!prefs) {
		UIAlertView* firstRunAlert = [[UIAlertView alloc] initWithTitle:@"Hermes" message:@"Welcome to Hermes. To get started, visit Hermes's settings page." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[firstRunAlert show];
	}

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

	[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"com.phillipt.hermes.WhatsAppMsgSend"  handler:^NSDictionary *(NSDictionary *message) {
    	[(NSMutableDictionary*)prefs setObject:message[@"titleType"] forKey:@"titleType"];
    	[(NSMutableDictionary*)prefs setObject:message[@"displayName"] forKey:@"displayName"];
    	[(NSMutableDictionary*)prefs setObject:message[@"text"] forKey:@"text"];
    	[(NSMutableDictionary*)prefs setObject:message[@"responseJID"] forKey:@"jid"];
    	//[(NSMutableDictionary*)prefs setObject:message[@"kikUser"] forKey:@"kikUser"];
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
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.kik.chat" suspended:YES];
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];
	//system("open /Applications/MobileSMS.app");

	if (pirated) {
		UIAlertView* pirateAlert = [[UIAlertView alloc] initWithTitle:@"Hermes" message:@"This version of Hermes has been pirated. Please consider purchasing a copy as it took a lot of work to create." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[pirateAlert show];
	}
}
%end

//(Yet another) hacky check to not show alerts while others are pending
%hook UIAlertView 
- (void)show {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@YES forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:NO];
	%orig;
} 
-(void)dismiss {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:NO];
	%orig;
}
-(void)dismissWithClickedButtonIndex:(NSInteger)clickedButtonIndex animated:(BOOL)animated {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:NO];
	%orig;
}
-(void)dismissAnimated:(BOOL)animated {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	[(NSMutableDictionary*)prefs setObject:@NO forKey:@"alertActive"];
	[(NSMutableDictionary*)prefs writeToFile:kSettingsPath atomically:NO];
	%orig;
}
%end

%hook BBBulletin 

%new

-(BOOL)isHermesBulletin {
	if ([[self sectionID] isEqualToString:@"com.apple.MobileSMS"] || [[self sectionID] isEqualToString:@"com.kik.chat"] || [[self sectionID] isEqualToString:@"net.whatsapp.WhatsApp"]) {
		if ([[self sectionID] isEqualToString:@"com.apple.MobileSMS"]) {
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
			appFrom = 1;
		}
		else if ([[self sectionID] isEqualToString:@"com.kik.chat"]) {
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.kik.chat" suspended:YES];
			appFrom = 2;
		}
		else {
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];
			appFrom = 3;
		}
		return YES;
	}
	return NO;
}

%end

UIButton *replyButton;

BOOL shouldShowReply(int sender) {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	if (!prefs) return NO;
	if (sender == 1) {
		if ([prefs[@"messagesUse"] boolValue]) return YES;
	}
	else if (sender == 2) {
		if ([prefs[@"kikUse"] boolValue]) return YES;
	}
	else if (sender == 3) {
		if ([prefs[@"whatsUse"] boolValue]) return YES;
	}
	return NO;
} 

%hook SBDefaultBannerView

%new
-(BBBulletin *)hermesBulletin {
return [[[self bannerContext] item] pullDownNotification];
}

%new
-(BOOL)didAddButton {
	for (UIView *object in [self subviews]) {
		if (object.tag == 1337) {
			return TRUE;
		}
	}
	return FALSE;
}

-(void)layoutSubviews {
	if ([[self hermesBulletin] isHermesBulletin] && ![self didAddButton]) {
		replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[replyButton setFrame:CGRectMake(0, 0, 100, 40)];
		replyButton.tag = 1337;
		replyButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[replyButton setCenter:CGPointMake(self.center.x+((self.frame.size.width/2)-40),self.center.y)];
		[replyButton setTitle:@"Reply" forState:UIControlStateNormal];
		UIColor* butColor = [UIColor colorWithRed:0/255.0f green:160/255.0f blue:255/255.0f alpha:1.0f];
		[replyButton setTitleColor:butColor forState:UIControlStateNormal];
		if (appFrom == 1) [replyButton addTarget:self action:@selector(messageReply) forControlEvents:UIControlEventTouchUpInside];
		else if (appFrom == 2) [replyButton addTarget:self action:@selector(kikReply) forControlEvents:UIControlEventTouchUpInside];
		else [replyButton addTarget:self action:@selector(whatsReply) forControlEvents:UIControlEventTouchUpInside];
		NSLog(@"[Hermes3] appFrom is %i", appFrom);
		if (shouldShowReply(appFrom)) [self addSubview:replyButton];
	}
	%orig;
}

%new
-(void)messageReply {
	dl(@"[Hermes3] Replying to Messages after touching reply button...");
	notify_post("com.phillipt.hermes.received");
}

%new
-(void)kikReply {
	dl(@"[Hermes3] Replying to Kik after touching reply button...");
	notify_post("com.phillipt.hermes.kikReceived");
}

%new
-(void)whatsReply {
	dl(@"[Hermes3] Replying to WhatsApp after touching reply button...");
	notify_post("com.phillipt.hermes.whatsAppReceived");
}

%end

%ctor {
	system("open /Applications/MobileSMS.app");
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.kik.chat" suspended:YES];
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];

	//Yes, I totally understand the irony of having a piracy check in an open source tweak. B) deal with it
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/org.thebigboss.hermes.list"] && ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.phillipt.hermes.list"]) {
		pirated = YES;
	}
}
