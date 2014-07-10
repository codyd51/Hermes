%hook XMPPConnection

-(void)sendMessage:(id)arg1 toRecipients:(id)arg2 {
	%log;
	NSLog(@"[Hermes - WhatsApp] Send message %@ to recipients %@", arg1, arg2);
	%orig;
}

%end

%hook WAContactInfoViewController

-(void)sendMessageToWAPhoneWithID:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] sendMessageToWAPhoneWithID: %@", arg1);
	%orig;
}

%end

%hook ChatViewController

-(void)sendMessageAction:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] sendMessageAction: %@", arg1);
	%orig;
}
-(void)replyMessageSenderFromCell:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] replyMessageSenderFromCell: %@", arg1);
	%orig;
}
-(void)sendTextMessage {
	%log;
	NSLog(@"[Hermes - WhatsApp] sendTextMessage");
	%orig;
}
-(void)setButtonSendMessage:(id)arg1 {
	%log;
	NSLog(@"[Hermes - WhatsApp] setButtonSendMessage: %@", arg1);
	%orig;
}

%end