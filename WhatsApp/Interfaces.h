#import <notify.h>
#import <libobjcipc/objcipc.h>
#import <objc/runtime.h>
#import <objc/objc.h>

@class CKConversation, CKEntity, IMMessage, IMService, NSArray, NSAttributedString, NSDate, NSError, NSString;

@interface CKIMMessage : NSObject
{
    NSDate *_date;
    CKConversation *_conversation;
    IMMessage *_imMessage;
    NSArray *_parts;
    long long _partCount;
    float _cachedPercentComplete;
    struct {
        unsigned int hasPostedComplete:1;
        unsigned int shouldPlayReceivedTone:1;
        unsigned int isPlaceHolderDate:1;
    } _messageFlags;
}

@property(nonatomic) CKConversation *conversation; // @synthesize conversation=_conversation;
@property(readonly, nonatomic) _Bool shouldUseSeparateSubject;
@property(readonly, nonatomic) _Bool shouldPlayReceivedTone;
@property(readonly, nonatomic) _Bool wantsSendStatus;
- (id)url;
@property(readonly, nonatomic) BOOL outgoingBubbleColor;
@property(readonly, nonatomic) IMService *service;
@property(readonly, nonatomic) _Bool isSMS;
@property(readonly, nonatomic) _Bool isiMessage;
- (_Bool)postMessageReceivedIfNecessary;
- (void)updateMessageCompleteQuietly;
@property(retain, nonatomic) IMMessage *IMMessage;
@property(readonly, nonatomic) long long sequenceNumber;
@property(readonly, nonatomic) long long rowID;
@property(readonly, nonatomic) NSString *guid;
@property(readonly, nonatomic) _Bool isTypingIndicator;
@property(readonly, nonatomic) _Bool isPlaceholder;
@property(nonatomic) _Bool isFromDowngrading;
- (id)description;
- (void)deleteMessageParts:(id)arg1;
- (void)resetParts;
- (void)loadParts;
@property(readonly, nonatomic) _Bool hasAttachments;
@property(readonly, nonatomic) NSArray *parts;
- (id)messagePartAtIndex:(unsigned long long)arg1;
@property(readonly, nonatomic) unsigned long long messagePartCount;
@property(readonly, nonatomic) NSString *previewText;
- (id)attachmentText:(_Bool)arg1;
- (id)_rawPreviewText;
- (long long)compare:(id)arg1;
- (_Bool)isEqual:(id)arg1;
@property(readonly, nonatomic) _Bool supportsDeliveryReceipts;
- (id)timeDelivered;
@property(readonly, nonatomic) _Bool isDelivered;
@property(readonly, nonatomic) _Bool isFromFilteredSender;
@property(readonly, nonatomic) _Bool isWaitingForDelivery;
@property(readonly, nonatomic) _Bool isFromMe;
@property(readonly, nonatomic) long long failedSendCount;
@property(readonly, nonatomic) long long pendingCount;
- (_Bool)pending;
@property(readonly, nonatomic) long long sentCount;
@property(readonly, nonatomic) _Bool partiallyFailedSend;
@property(readonly, nonatomic) _Bool failedSend;
- (void)markAsRead;
@property(readonly, nonatomic) _Bool isToEmailAddress;
@property(readonly, nonatomic) _Bool isOutgoing;
@property(readonly, nonatomic) NSDate *timeRead;
@property(readonly, nonatomic) _Bool isRead;
@property(readonly, nonatomic) _Bool hasBeenSent;
@property(readonly, nonatomic) NSError *error;
@property(readonly, nonatomic) NSAttributedString *subject;
@property(readonly, nonatomic) CKEntity *sender;
@property(readonly, nonatomic) NSString *address;
- (int)messageCount;
@property(readonly, nonatomic) NSArray *recipients;
@property(readonly, nonatomic) NSDate *date;
@property(readonly, nonatomic) float percentComplete;
- (long long)totalMessageCount;
- (void)_loadCounts;
- (void)_parseIMMessagePartsWithTextProcessingBlock:(id)arg1 fileTransferProcessingBlock:(void)arg2;
- (void)_resetData;
- (void)dealloc;
- (id)initPlaceholderWithDate:(id)arg1;
- (id)initWithIMMessage:(id)arg1;

@end

@class NSAttributedString, NSString;

@interface CKMessagePart : NSObject
{
    BOOL _color;
    NSString *_guid;
    NSAttributedString *_displayText;
    //id <CKMessage> _parentMessage;
    long long _partID;
}

+ (id)messagePartsWithComposition:(id)arg1;
@property(nonatomic) BOOL color; // @synthesize color=_color;
@property(nonatomic) long long partID; // @synthesize partID=_partID;
//@property(nonatomic) id <CKMessage> parentMessage; // @synthesize parentMessage=_parentMessage;
- (id)compositionRepresentation;
- (id)pasteboardItems;
- (int)type;
- (id)detachedCopy;
- (id)imageFilename;
- (id)previewImage;
- (id)highlightData;
- (id)image;
- (id)imageData;
- (void)contentSizeCategoryDidChange:(id)arg1;
@property(readonly, nonatomic) NSAttributedString *displayText; // @synthesize displayText=_displayText;
- (id)text;
- (_Bool)isSeparateSubjectPart;
- (id)previewText;
@property(readonly, nonatomic) _Bool isOutgoing;
- (id)mediaObject;
@property(readonly, nonatomic) NSString *guid; // @synthesize guid=_guid;
- (_Bool)isEqual:(id)arg1;
- (id)description;
- (id)init;
- (void)dealloc;

@end

@class NSAttributedString;

@interface CKTextMessagePart : CKMessagePart
{
    NSAttributedString *_text;
}

- (id)compositionRepresentation;
- (id)pasteboardItems;
- (id)description;
@property(readonly, nonatomic) NSAttributedString *text; // @synthesize text=_text;
- (id)initWithText:(id)arg1;
- (int)type;
- (id)detachedCopy;
- (void)dealloc;

@end

@class IMHandle, NSAttributedString, NSString, UIImage;

@interface CKEntity : NSObject
{
    IMHandle *_handle;
}

+ (id)copyEntityForAddressString:(id)arg1;
+ (id)_copyEntityForAddressString:(id)arg1 onAccount:(id)arg2;
@property(retain, nonatomic) IMHandle *handle; // @synthesize handle=_handle;
@property(readonly, nonatomic) NSAttributedString *attributedTranscriptText;
@property(readonly, nonatomic) UIImage *transcriptContactImage;
@property(readonly, nonatomic) NSString *textVibrationIdentifier;
@property(readonly, nonatomic) NSString *textToneIdentifier;
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) NSString *fullName;
@property(readonly, nonatomic) NSString *originalAddress;
@property(readonly, nonatomic) NSString *rawAddress;
@property(readonly, nonatomic) int propertyType;
@property(readonly, nonatomic) int identifier;
@property(readonly, nonatomic) void *abRecord;
@property(readonly, nonatomic) IMHandle *defaultIMHandle;
- (unsigned long long)hash;
- (_Bool)isEqual:(id)arg1;
- (id)description;
- (void)dealloc;
- (id)initWithIMHandle:(id)arg1;

@end

#import <Foundation/NSObject.h>

@class CKConversationList, NSString, CKEntity;

@interface CKService : NSObject {
    NSString* _serviceID;
    CKConversationList* _conversationList;
}
+ (id)availableServices;
@property(readonly, assign, nonatomic) NSString* serviceID;
@property(readonly, assign, nonatomic) CKConversationList* conversationList;
-(id)initWithServiceID:(id)serviceID;
-(int)createConversationWithRecipients:(id)recipients;
-(int)conversationIDWithRecipients:(id)recipients;
-(int)unreadConversationCount;
-(int)unreadCountForConversation:(id)conversation;
-(id)headerTitleForEntities:(id)entities;
-(id)headerTitleForComposeRecipients:(id)composeRecipients mediaObjects:(id)objects subject:(id)subject;
-(BOOL)canSendToRecipients:(id)recipients withAttachments:(id)attachments alertIfUnable:(BOOL)unable;
-(void)markAllMessagesInConversationAsRead:(id)conversationAsRead;
-(BOOL)dbFull;
-(BOOL)canSendMessageWithMediaObjectTypes:(int*)mediaObjectTypes;
-(void)dealloc;
-(id)placeholderMessageForConversation:(id)conversation withDate:(id)date;
-(id)newMessageWithComposition:(id)composition forConversation:(id)conversation;
-(id)newMessageWithMessage:(id)message forConversation:(id)conversation isForward:(BOOL)forward;
-(void)sendMessage:(id)message;
-(id)conversationSummaries:(id*)summaries groupIDs:(id*)ids;
-(id)lookupRecipientsForConversation:(id)conversation;
-(void)fixupNames;
-(int)maxRecipientCount;
-(int)unreadCount;
-(id)messagesForConversation:(id)conversation limit:(int)limit moreToLoad:(BOOL*)load;
-(BOOL)restrictsMediaObjects;
-(BOOL)canAcceptMediaObject:(id)object givenMediaObjects:(id)objects;
-(BOOL)canAcceptMediaObjectType:(int)type givenMediaObjects:(id)objects;
-(double)maxTrimDurationForMediaType:(int)mediaType;
-(CKEntity*)copyEntityForAddressString:(NSString*)addressString;
-(id)unknownEntity;
-(id)abPropertyTypes;
-(BOOL)isValidAddress:(id)address;
-(int)maxAttachmentCount;
-(void)deleteMessagesForConversationIDs:(id)conversationIDs removeConversations:(BOOL)conversations;
@end

@class NSAttributedString;

@interface CKComposition : NSObject
{
    NSAttributedString *_text;
    NSAttributedString *_subject;
}

+ (id)compositionForMessageParts:(id)arg1;
+ (id)savedCompositionForGUID:(id)arg1;
+ (void)deleteCompositionWithGUID:(id)arg1;
@property(copy, nonatomic) NSAttributedString *subject; // @synthesize subject=_subject;
@property(copy, nonatomic) NSAttributedString *text; // @synthesize text=_text;
- (id)compositionByAppendingMessagePart:(id)arg1;
- (id)mediaObjects;
- (_Bool)isTextOnly;
- (_Bool)hasNonwhiteSpaceContent;
- (_Bool)hasContent;
- (void)saveCompositionWithGUID:(id)arg1;
- (id)initWithText:(id)arg1 subject:(id)arg2;
- (_Bool)isEqual:(id)arg1;
- (id)description;
- (void)dealloc;

@end

@class CKAudioTrimViewController, CKComposition, CKConversation, CKGradientReferenceView, CKMessageEncodingInfo, CKMessageEntryView, CKQLPreviewController, CKRecipientSelectionController, CKTranscriptCollectionViewController, CKTranscriptHeaderController, CKTranscriptStatusController, CKTranscriptTypingIndicatorCell, CKVideoTrimController, NSArray, NSMutableArray, NSNotification, NSNumber, NSString, UIAlertView, UIBarButtonItem, UIImagePickerController, UINavigationItem, UITapGestureRecognizer, UIToolbar, UIView, UIWindow;

@interface CKTranscriptController : UIViewController

+ (id)readerScrollPositionCache;
@property(retain, nonatomic) NSMutableArray *throwEndFrames; // @synthesize throwEndFrames=_throwEndFrames;
@property(retain, nonatomic) NSMutableArray *throwIntermediateFrames; // @synthesize throwIntermediateFrames=_throwIntermediateFrames;
@property(retain, nonatomic) NSMutableArray *throwBalloonViews; // @synthesize throwBalloonViews=_throwBalloonViews;
@property(retain, nonatomic) UIView *throwAnimationSnapshotView; // @synthesize throwAnimationSnapshotView=_throwAnimationSnapshotView;
@property(retain, nonatomic) UIView *throwAnimationEnforcementView; // @synthesize throwAnimationEnforcementView=_throwAnimationEnforcementView;
@property(retain, nonatomic) CKTranscriptHeaderController *transcriptHeaderViewController; // @synthesize transcriptHeaderViewController=_transcriptHeaderViewController;
@property(readonly, nonatomic) CKRecipientSelectionController *recipientSelectionController; // @synthesize recipientSelectionController=_recipientSelectionController;
@property(nonatomic) _Bool hasPrepopulatedRecipients; // @synthesize hasPrepopulatedRecipients=_hasPrepopulatedRecipients;
@property(retain, nonatomic) CKTranscriptCollectionViewController *collectionViewController; // @synthesize collectionViewController=_collectionViewController;
@property(retain, nonatomic) CKMessageEntryView *entryView; // @synthesize entryView=_entryView;
@property(nonatomic) _Bool safeToMarkAsRead; // @synthesize safeToMarkAsRead=_safeToMarkAsRead;
@property(copy, nonatomic) NSArray *newCompositionAddresses; // @synthesize newCompositionAddresses=_newCompositionAddresses;
@property(copy, nonatomic) id alertHandler; // @synthesize alertHandler=_alertViewHandler;
@property(copy, nonatomic) id scrollBlock; // @synthesize scrollBlock=_scrollBlock;
@property(nonatomic, getter=isDimmed) _Bool dimmed; // @synthesize dimmed=_dimmed;
@property(retain, nonatomic) NSMutableArray *presetMessageParts; // @synthesize presetMessageParts=_presetMessageParts;
//@property(nonatomic) id <CKTranscriptComposeDelegate> composeDelegate; // @synthesize composeDelegate=_composeDelegate;
- (void)sendMessage:(id)arg1;
- (id)conversation;

// Remaining properties
@property(nonatomic) long long autocapitalizationType;
@property(nonatomic) long long autocorrectionType;
@property(nonatomic) _Bool enablesReturnKeyAutomatically;
@property(nonatomic) long long keyboardAppearance;
@property(nonatomic) long long keyboardType;
@property(nonatomic) long long returnKeyType;
@property(nonatomic, getter=isSecureTextEntry) _Bool secureTextEntry;
@property(nonatomic) long long spellCheckingType;

@end

@interface CTMessageCenter : NSObject
{
}

+ (id)sharedMessageCenter;
//-(void)sendMessage;
- (_Bool)getCharacterCount:(long long *)arg1 andMessageSplitThreshold:(long long *)arg2 forSmsText:(id)arg3;
- (_Bool)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withMoreToFollow:(_Bool)arg4 withID:(unsigned int)arg5;
- (_Bool)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withMoreToFollow:(_Bool)arg4;
- (_Bool)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3 withID:(unsigned int)arg4;
- (_Bool)sendSMSWithText:(id)arg1 serviceCenter:(id)arg2 toAddress:(id)arg3;
- (_Bool)isMmsConfigured;
- (_Bool)isMmsEnabled;
- (void)setDeliveryReportsEnabled:(_Bool)arg1;
- (id)decodeMessage:(id)arg1;
- (id)encodeMessage:(id)arg1;
- (id)statusOfOutgoingMessages;
- (id)deferredMessageWithId:(unsigned int)arg1;
- (id)incomingMessageWithId:(unsigned int)arg1;
- (void)acknowledgeOutgoingMessageWithId:(unsigned int)arg1;
- (void)acknowledgeIncomingMessageWithId:(unsigned int)arg1;
- (id)allIncomingMessages;
- (void)addMessageOfType:(int)arg1 toArray:(id)arg2 withIdsFromArray:(id)arg3;
- (int)incomingMessageCount;
- (id)incomingMessageWithId:(unsigned int)arg1 isDeferred:(_Bool)arg2;
- (void)sendMessageAsSmsToShortCodeRecipients:(id)arg1 andReplaceData:(id *)arg2;
- (void)dealloc;
- (id)init;

@end

@class CKComposition, CKEntity, CKIMMessage, IMChat, IMMessage, IMService, NSArray, NSMutableArray, NSString, UIImage;

@interface CKConversation : NSObject
{
    NSArray *_recipients;
    NSString *_name;
    NSMutableArray *_messages;
    NSMutableArray *_pendingMessages;
    //id <CKMessage> _placeholderMessage;
    IMChat *_chat;
    IMMessage *_incomingTypingMessage;
    IMService *_cachedPreferredService;
    unsigned int _limitToLoad;
    int _bulkMessageAddStack;
    BOOL _cachedPreferredServiceError;
    BOOL _downgradeState;
    struct {
        unsigned int ignoreDowngradeStatusUpdates:1;
        unsigned int isStale:1;
        unsigned int updatesDisabled:1;
        unsigned int needsPostAfterUpdate:1;
        unsigned int wantsAnimatedPost:1;
        unsigned int ignoringTypingUpdates:1;
        unsigned int hasPlaceholder:1;
        unsigned int moreMessagesToLoad:1;
        unsigned int blockingForHistoryQuery:1;
        unsigned int forceMMS:1;
    } _conversationFlags;
    NSArray *_pendingHandles;
    UIImage *_thumbnailImage;
    NSArray *_failedMessages;
}

+ (_Bool)_contentChangedFromOldMessage:(id)arg1 toNewMessage:(id)arg2;
+ (id)newPendingConversation;
@property(readonly, nonatomic) NSArray *failedMessages; // @synthesize failedMessages=_failedMessages;
@property(retain, nonatomic) UIImage *thumbnailImage; // @synthesize thumbnailImage=_thumbnailImage;
@property(nonatomic) unsigned int limitToLoad; // @synthesize limitToLoad=_limitToLoad;
@property(retain, nonatomic) IMMessage *incomingTypingMessage; // @synthesize incomingTypingMessage=_incomingTypingMessage;
@property(retain, nonatomic) IMChat *chat; // @synthesize chat=_chat;
@property(retain, nonatomic) NSArray *recipients; // @synthesize recipients=_recipients;
@property(copy, nonatomic) NSArray *pendingHandles; // @synthesize pendingHandles=_pendingHandles;
@property(readonly, nonatomic) NSArray *pendingMessages; // @synthesize pendingMessages=_pendingMessages;
@property(readonly, nonatomic) NSArray *messages; // @synthesize messages=_messages;
- (id)copyForPendingConversation;
- (void)sendDowngradePingForMessage:(id)arg1 manualDowngrade:(_Bool)arg2;
- (id)displayNameForMediaObjects:(id)arg1 subject:(id)arg2;
- (id)_headerTitleForPendingMediaObjects:(id)arg1 subject:(id)arg2 onService:(id)arg3;
- (id)_headerTitleForService:(id)arg1;
- (id)_nameForHandle:(id)arg1;
@property(readonly, nonatomic) NSString *serviceDisplayName;
- (BOOL)outgoingBubbleColor;
@property(readonly, nonatomic) BOOL buttonColor;
@property(readonly, nonatomic) NSString *previewText;
@property(readonly, nonatomic) NSString *name; // @dynamic name;
@property(readonly, nonatomic) unsigned long long disclosureAtomStyle; // @dynamic disclosureAtomStyle;
@property(readonly, nonatomic) _Bool shouldShowCharacterCount;
- (void)_clearTypingIndicatorsIfNecessary;
- (void)_updateTypingIndicatorForComposition:(id)arg1;
- (void)__rescindTypingIndicatorIfNecessary;
- (void)__sendTypingIndicatorIfNecessary;
@property(readonly, nonatomic) CKIMMessage *incomingTypingCKMessage;
- (_Bool)_chatSupportsTypingIndicators;
- (void)sendMessage:(id)arg1 newComposition:(_Bool)arg2;
- (void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(_Bool)arg3;
- (void)_recordRecentContact;
- (void)_targetChatToPreferredService:(id)arg1 newComposition:(_Bool)arg2;
- (void)_targetChat:(id)arg1 toService:(id)arg2 newComposition:(_Bool)arg3;
- (_Bool)_chatHasValidAccount:(id)arg1 forService:(id)arg2;
- (_Bool)_accountIsOperational:(id)arg1 forService:(id)arg2;
- (void)newMessageContentChangedWithComposition:(id)arg1;
- (id)newMessageWithComposition:(id)arg1 addToConversation:(_Bool)arg2;
- (id)newMessageWithComposition:(id)arg1 guid:(id)arg2 addToConversation:(_Bool)arg3;
- (id)newMessageWithComposition:(id)arg1;
- (double)maxTrimDurationForMediaType:(int)arg1;
- (_Bool)canSendMessageComposition:(id)arg1 error:(id *)arg2;
- (_Bool)canSendToRecipients:(id)arg1 withAttachments:(id)arg2 alertIfUnable:(_Bool)arg3;
- (_Bool)canSendMessageWithParts:(id)arg1 subject:(id)arg2 error:(id *)arg3;
- (_Bool)canSendMessageWithParts:(id)arg1 subject:(id)arg2 onService:(id)arg3 error:(id *)arg4;
- (_Bool)canSendMessageWithMediaObjectTypes:(int *)arg1;
- (_Bool)canAcceptMediaObjects:(id)arg1 givenMediaObjects:(id)arg2;
- (_Bool)canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2;
- (_Bool)canAcceptMediaObject:(id)arg1 givenMediaObjects:(id)arg2;
- (_Bool)restrictMediaObjects;
@property(readonly, nonatomic, getter=isPending) _Bool pending;
@property(readonly, nonatomic) NSArray *recipientStrings;
@property(readonly, nonatomic) NSArray *pendingEntities; // @dynamic pendingEntities;
- (void)setPendingComposeRecipients:(id)arg1;
- (long long)compareBySequenceNumberAndDateDescending:(id)arg1;
- (void)downgradeStateDidChange;
- (void)invalidatePreferredServiceCache;
- (id)shortDescription;
- (id)description;
- (void)addPlaceholderMessageIfNeededWithDate:(id)arg1;
- (_Bool)isPlaceholder;
- (void)markAllMessagesAsRead;
- (_Bool)isFromFilteredSender;
- (id)latestIncomingMessage;
- (id)latestMessage;
- (void)addMessage:(id)arg1;
- (id)placeholderMessage;
- (void)_setPlaceholderMessage:(id)arg1;
- (void)setLoadedMessageCount:(unsigned long long)arg1 completion:(id)arg2;
- (void)loadMoreMessages;
- (void)loadAllMessages;
- (void)setLoadedMessages:(id)arg1;
- (void)deleteMessage:(id)arg1;
- (void)deleteMessages:(id)arg1;
- (void)deleteAllMessagesAndRemoveGroup;
- (void)deleteAllMessages;
- (void)_deleteAllMessagesAndRemoveGroup:(_Bool)arg1;
- (void)removeAllMessages;
- (void)updateMessage:(id)arg1;
- (void)removeMessage:(id)arg1;
- (void)removeMessage:(id)arg1 postUpdate:(_Bool)arg2;
- (id)date;
@property(readonly, nonatomic) unsigned long long recipientCount;
@property(readonly, nonatomic) _Bool isEmpty;
- (id)uniqueIdentifier;
@property(readonly, nonatomic) NSString *groupID; // @dynamic groupID;
@property(nonatomic) _Bool updatesDisabled; // @dynamic updatesDisabled;
- (void)setUpdatesDisabled:(_Bool)arg1 quietly:(_Bool)arg2;
- (void)postChangedUpdate:(_Bool)arg1;
- (void)_postChangeUpdate:(_Bool)arg1;
- (void)_refreshMoreToLoadFlag;
- (void)_calculateDowngradeState;
- (id)_consecutiveDowngradeAttemptsViaManualDowngrades:(_Bool)arg1;
- (void)_calculateDowngradeStateTimerFired;
- (void)_updateDowngradeState:(BOOL)arg1 checkAgainInterval:(double)arg2;
- (void)_invalidateDowngradeState;
- (void)_handlePreferredServiceChangedNotification:(id)arg1;
- (_Bool)_handleIsForThisConversation:(id)arg1;
- (void)requestRecipientStatuses;
@property(readonly, nonatomic) IMService *preferredService;
- (id)preferredServiceWithCanSend:(_Bool *)arg1 error:(char *)arg2;
- (_Bool)canSendWithError:(char *)arg1;
- (id)_preferredServiceCheckWithServer:(_Bool)arg1 canSend:(_Bool *)arg2 error:(char *)arg3;
@property(readonly, nonatomic, getter=isGroupConversation) _Bool groupConversation;
@property(nonatomic) _Bool forceMMS; // @dynamic forceMMS;
@property(readonly, nonatomic) _Bool moreMessagesToLoad; // @dynamic moreMessagesToLoad;
@property(nonatomic, getter=isIgnoringTypingUpdates) _Bool ignoringTypingUpdates; // @dynamic ignoringTypingUpdates;
- (_Bool)isDowngraded;
- (void)_setupPreferredServiceChangeHandlers;
- (void)markAsStale;
- (_Bool)reloadIfStale;
- (int)endBulkMessageAddForcePost:(_Bool)arg1;
- (void)beginBulkMessageAdd;
- (void)_endBatchUpdates;
- (void)_beginBatchUpdates;
@property(retain, nonatomic) NSString *rememberedKeyboard;
@property(retain, nonatomic) CKComposition *unsentComposition; // @dynamic unsentComposition;
- (void)_handleChatPropertiesChangedNotification:(id)arg1;
- (void)_handleItemsDidChangeNotification:(id)arg1;
- (_Bool)_handleRemovedMessage:(id)arg1;
- (_Bool)_handleChangedMessage:(id)arg1 forQuery:(id)arg2;
- (_Bool)_handleTypingIndicationMessage:(id)arg1;
- (id)_messagesFromChat:(id)arg1;
- (void)_postNotification:(id)arg1 forMessage:(id)arg2;
- (id)_addCKMessageFromIMMessage:(id)arg1;
- (id)_existingMadridMessageForIMMessage:(id)arg1;
- (id)_IMMessageWithMessageParts:(id)arg1 subject:(id)arg2 date:(id)arg3 isFinished:(_Bool)arg4 messageGUID:(id)arg5 needsDataDetection:(_Bool)arg6;
- (id)_CKMessageFromIMMessage:(id)arg1;
- (void)acceptTransfer:(id)arg1;
- (id)ckMessageWithGUID:(id)arg1;
@property(readonly, nonatomic) CKEntity *recipient; // @dynamic recipient;
@property(readonly, nonatomic) NSArray *handles; // @dynamic handles;
@property(readonly, nonatomic) _Bool hasUnreadiMessages; // @dynamic hasUnreadiMessages;
@property(readonly, nonatomic) _Bool hasUnreadMessages; // @dynamic hasUnreadMessages;
@property(readonly, nonatomic) unsigned long long unreadCount; // @dynamic unreadCount;
- (void)resetCaches;
- (void)resetNameCaches;
- (void)resetPendingMessages;
- (void)dealloc;
- (void)_cleanupMessages;
- (id)initWithChat:(id)arg1 updatesDisabled:(_Bool)arg2;
- (id)init;

@end

@interface IMService : NSObject
{
}

+ (id)canonicalFormOfID:(id)arg1 withIDSensitivity:(int)arg2;
+ (unsigned long long)statusForABPerson:(id)arg1;
+ (unsigned long long)statusForIMPerson:(id)arg1;
+ (_Bool)isEmailAddress:(id)arg1 inDomains:(id)arg2;
+ (id)myIdleTime;
+ (unsigned long long)myStatus;
+ (id)notificationCenter;
+ (id)serviceWithName:(id)arg1;
+ (id)allServicesNonBlocking;
+ (id)allServices;
+ (id)imageURLForStatus:(unsigned long long)arg1;
+ (id)imageNameForStatus:(unsigned long long)arg1;
+ (void)forgetStatusImageAppearance;
- (id)myScreenNames;
- (id)screenNamesForPerson:(id)arg1;
- (id)peopleWithScreenName:(id)arg1;
- (id)canonicalFormOfID:(id)arg1;
- (id)infoForPreferredScreenNames;
- (id)infoForAllScreenNames;
- (id)infoForScreenName:(id)arg1;
- (unsigned long long)status;
- (id)name;
- (id)localizedShortName;
- (id)localizedName;
- (_Bool)initialSyncPerformed;
- (void)logout;
- (void)login;
- (_Bool)isEnabled;
- (id)copyWithZone:(struct _NSZone *)arg1;

@end

@interface IMService (IMService_GetService)
+ (id)smsService;
+ (id)iMessageService;
+ (id)facetimeService;
+ (id)callService;
+ (id)jabberService;
+ (id)subnetService;
+ (id)aimService;
@end

@class FZMessage, IMHandle, NSArray, NSAttributedString, NSDate, NSError, NSString;

@interface IMMessage : NSObject <NSCopying>
{
    IMHandle *_sender;
    IMHandle *_subject;
    NSAttributedString *_text;
    NSString *_plainBody;
    NSDate *_time;
    NSDate *_timeDelivered;
    NSDate *_timeRead;
    NSString *_guid;
    NSAttributedString *_messageSubject;
    NSArray *_fileTransferGUIDs;
    NSError *_error;
    NSArray *_parts;
    unsigned long long _flags;
    _Bool _isInvitationMessage;
    long long _messageID;
}

+ (id)messageFromFZMessageDictionary:(id)arg1 sender:(id)arg2 subject:(id)arg3;
+ (id)messageFromFZMessage:(id)arg1 sender:(id)arg2 subject:(id)arg3;
+ (id)fromMeIMHandle:(id)arg1 withText:(id)arg2 fileTransferGUIDs:(id)arg3 flags:(unsigned long long)arg4;
+ (id)instantMessageWithText:(id)arg1 messageSubject:(id)arg2 fileTransferGUIDs:(id)arg3 flags:(unsigned long long)arg4;
+ (id)instantMessageWithText:(id)arg1 messageSubject:(id)arg2 flags:(unsigned long long)arg3;
+ (id)instantMessageWithText:(id)arg1 flags:(unsigned long long)arg2;
+ (id)defaultInvitationMessageFromSender:(id)arg1 flags:(unsigned long long)arg2;
- (void)_updateTimeRead:(id)arg1;
@property(retain, nonatomic) NSDate *timeRead; // @synthesize timeRead=_timeRead;
- (void)_updateTimeDelivered:(id)arg1;
@property(retain, nonatomic) NSDate *timeDelivered; // @synthesize timeDelivered=_timeDelivered;
- (void)_updateFileTransferGUIDs:(id)arg1;
@property(copy, nonatomic) NSArray *fileTransferGUIDs; // @synthesize fileTransferGUIDs=_fileTransferGUIDs;
@property(nonatomic) _Bool isInvitationMessage; // @synthesize isInvitationMessage=_isInvitationMessage;
- (void)_updateError:(id)arg1;
@property(retain, nonatomic) NSError *error; // @synthesize error=_error;
- (void)_updateFlags:(unsigned long long)arg1;
@property(nonatomic) unsigned long long flags; // @synthesize flags=_flags;
- (void)_updateMessageID:(long long)arg1;
@property(nonatomic) long long messageID; // @synthesize messageID=_messageID;
- (void)_updateGUID:(id)arg1;
@property(retain, nonatomic) NSString *guid; // @synthesize guid=_guid;
- (void)_updateText:(id)arg1;
@property(retain, nonatomic) NSAttributedString *text; // @synthesize text=_text;
- (void)_updateTime:(id)arg1;
@property(retain, nonatomic) NSDate *time; // @synthesize time=_time;
@property(readonly, nonatomic) NSAttributedString *messageSubject; // @synthesize messageSubject=_messageSubject;
@property(readonly, nonatomic) IMHandle *subject; // @synthesize subject=_subject;
- (void)_updateSender:(id)arg1;
@property(retain, nonatomic) IMHandle *sender; // @synthesize sender=_sender;
- (void)_flushMessageParts;
- (id)description;
- (_Bool)isEqual:(id)arg1;
@property(readonly, nonatomic) FZMessage *_fzMessage;
- (long long)compare:(id)arg1 comparisonType:(long long)arg2;
- (long long)compare:(id)arg1;
- (long long)_compareIMMessageIDs:(id)arg1;
- (long long)_compareIMMessageDates:(id)arg1;
- (long long)_compareIMMessageGUIDs:(id)arg1;
@property(readonly, nonatomic) _Bool wasDataDetected;
@property(readonly, nonatomic) _Bool wasDowngraded;
@property(readonly, nonatomic) _Bool isAlert;
@property(readonly, nonatomic) _Bool isAddressedToMe;
- (void)setIsAddressedToMe:(_Bool)arg1;
@property(readonly, nonatomic) _Bool isSystemMessage;
@property(readonly, nonatomic) _Bool isRead;
@property(readonly, nonatomic) _Bool isDelivered;
@property(readonly, nonatomic) _Bool isAutoReply;
@property(readonly, nonatomic) _Bool isDelayed;
@property(readonly, nonatomic) _Bool isEmpty;
@property(readonly, nonatomic) _Bool isFromMe;
@property(readonly, nonatomic) _Bool isEmote;
@property(readonly, nonatomic) NSArray *inlineAttachmentAttributesArray;
@property(readonly, nonatomic) _Bool hasInlineAttachments;
@property(readonly, nonatomic) _Bool isSent;
@property(readonly, nonatomic) _Bool isTypingMessage;
@property(readonly, nonatomic) _Bool isFinished;
@property(readonly, nonatomic) _Bool hasDataDetectorResults;
@property(readonly, nonatomic) NSString *summaryString;
@property(readonly, nonatomic) NSString *senderName;
@property(readonly, nonatomic) NSString *plainBody;
- (void)dealloc;
- (id)initWithSender:(id)arg1 fileTransfer:(id)arg2;
- (id)initWithSender:(id)arg1 time:(id)arg2 text:(id)arg3 fileTransferGUIDs:(id)arg4 flags:(unsigned long long)arg5 error:(id)arg6 guid:(id)arg7 subject:(id)arg8;
- (id)initWithSender:(id)arg1 time:(id)arg2 text:(id)arg3 messageSubject:(id)arg4 fileTransferGUIDs:(id)arg5 flags:(unsigned long long)arg6 error:(id)arg7 guid:(id)arg8 subject:(id)arg9;
- (id)_initWithSender:(id)arg1 time:(id)arg2 timeRead:(id)arg3 timeDelivered:(id)arg4 plainText:(id)arg5 text:(id)arg6 messageSubject:(id)arg7 fileTransferGUIDs:(id)arg8 flags:(unsigned long long)arg9 error:(id)arg10 guid:(id)arg11 messageID:(long long)arg12 subject:(id)arg13;
- (id)_copyWithFlags:(unsigned long long)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;

@end

@interface CKSMSService : CKService {
    NSMutableSet* _deliveryObjects;
}
+(id)sharedSMSService;
+(id)dbPath;
+(void)migrate;
-(int)messageCount;
-(id)userFormattedAlphanumericStringForAddress:(id)address;
-(int)unreadCountForConversation:(id)conversation;
-(BOOL)dbFull;
-(void)markAllMessagesInConversationAsRead:(id)conversationAsRead;
//-(void)_receivedMessage:(CKSMSRecordRef)message replace:(BOOL)replace;
//-(void)_sentMessage:(CKSMSRecordRef)message;
//-(void)_sendError:(CKSMSRecordRef)error;
-(int)createConversationWithRecipients:(id)recipients;
-(int)conversationIDWithRecipients:(id)recipients;
-(void)_registerForCTNotifications;
-(id)init;
-(id)abPropertyTypes;
-(id)_newMMSMessageWithParts:(id)parts forConversation:(id)conversation subject:(id)subject;
-(id)_newMMSMessageWithComposition:(id)composition forConversation:(id)conversation;
-(id)_newSMSMessageWithText:(id)text forConversation:(id)conversation;
-(BOOL)_sendMMSByDefaultForConversation:(id)conversation;
-(id)newMessageWithMessage:(id)message forConversation:(id)conversation isForward:(BOOL)forward;
-(id)newMessageWithComposition:(id)composition forConversation:(id)conversation;
-(int)unreadConversationCount;
-(int)unreadCount;
-(id)placeholderMessageForConversation:(id)conversation withDate:(id)date;
-(void)sendMessage:(id)message;
-(void)fixupNames;
-(id)lookupRecipientsForConversation:(id)conversation;
-(id)conversationSummaries:(id*)summaries groupIDs:(id*)ids;
-(id)messagesForConversation:(id)conversation limit:(int)limit moreToLoad:(BOOL*)load;
-(void)deleteMessagesForConversationIDs:(id)conversationIDs removeConversations:(BOOL)conversations;
-(void)dealloc;
-(id)copyEntityForAddressString:(id)addressString;
-(id)unknownEntity;
-(id)headerTitleForEntities:(id)entities;
-(id)headerTitleForComposeRecipients:(id)composeRecipients mediaObjects:(id)objects subject:(id)subject;
-(BOOL)restrictsMediaObjects;
-(BOOL)canSendMessageWithMediaObjectTypes:(int*)mediaObjectTypes;
-(BOOL)canAcceptMediaObjectType:(int)type givenMediaObjects:(id)objects;
-(BOOL)canSendToRecipients:(id)recipients withAttachments:(id)attachments alertIfUnable:(BOOL)unable;
-(int)maxRecipientCount;
-(BOOL)canAcceptMediaObject:(id)object givenMediaObjects:(id)objects;
-(int)maxAttachmentCount;
-(BOOL)isValidAddress:(id)address;
-(double)maxTrimDurationForMediaType:(int)mediaType;
@end

@class CKService, CKSubConversation, NSCalendarDate, NSNumber, NSString;

@interface CKMessage : NSObject <NSFastEnumeration>
{
    unsigned int _height;
    float _cachedPercentComplete;
    unsigned int _dateLoaded:1;
    unsigned int _heightAndFlagsLoaded:1;
    unsigned int _failedSendCountLoaded:1;
    unsigned int _outgoing:1;
    unsigned int _outgoingLoaded:1;
    unsigned int _hasLoadedIsFromDowngrading:1;
    unsigned int _hasLoadedIsRead:1;
    unsigned int _isFromDowngrading:1;
    unsigned int _isRead:1;
    CKService *_service;
    NSString *_groupID;
    double _date;
    NSCalendarDate *_calendarDate;
    int _failedSendCount;
    unsigned int _flags;
    NSString *_text;
    CKSubConversation *_conversation;
}

- (id)initWithService:(id)arg1;
@property(readonly, nonatomic) NSString *guid;
@property(readonly, nonatomic) NSNumber *sequenceNumber;
- (int)messageCount;
- (BOOL)isEqual:(id)arg1;
- (void)dealloc;
- (void)_resetData;
- (void)resetHeightAndFlags;
@property(retain, nonatomic) NSString *groupID; // @synthesize groupID=_groupID;
@property(readonly, nonatomic) int rowID;
- (double)_loadDate;
- (double)timeIntervalSince1970;
- (id)date;
- (void)markAsRead;
- (BOOL)isForward;
- (BOOL)_loadOutgoing;
- (void)loadParts;
- (id)parts;
- (unsigned int)messagePartCount;
- (BOOL)hasAttachments;
- (id)messagePartAtIndex:(unsigned int)arg1;
- (id)messagePartWithRowID:(int)arg1;
- (void)_loadText;
- (BOOL)isOutgoing;
- (id)previewText;
- (id)attachmentText:(BOOL)arg1;
- (id)subject;
- (id)text;
- (id)error;
- (unsigned long)height;
- (void)_storeUIFlags:(unsigned long)arg1;
- (void)_loadUIFlags;
- (BOOL)storesFlagsInDatabase;
- (void)setUIHeight:(unsigned long)arg1 flags:(unsigned long)arg2;
- (void)getUIHeight:(unsigned int *)arg1 flags:(unsigned int *)arg2;
- (int)totalMessageCount;
- (int)pendingCount;
- (BOOL)pending;
- (int)compare:(id)arg1;
- (BOOL)failedSend;
- (BOOL)partiallyFailedSend;
- (BOOL)isDelivered;
- (BOOL)isWaitingForDelivery;
- (id)timeDelivered;
- (BOOL)_loadIsFromDowngrading;
@property(nonatomic) BOOL isFromDowngrading;
- (BOOL)_loadIsRead;
- (BOOL)isRead;
- (BOOL)isFromMe;
- (int)sentCount;
- (BOOL)hasBeenSent;
- (id)timeRead;
- (BOOL)isPlaceholder;
- (BOOL)isTypingIndicator;
- (void)_loadFailedSendCount;
- (int)failedSendCount;
- (BOOL)completelyFailedSend;
- (void)reloadFailedSendCount;
- (float)percentComplete;
- (id)sender;
- (id)address;
- (id)alertImageData;
- (BOOL)isFirstDisplayablePart:(id)arg1;
- (BOOL)isOnlyDisplayableMessagePart:(id)arg1;
- (void)deleteMessagePart:(id)arg1;
- (BOOL)smartForwardCapable;
- (BOOL)getCharacterCountNumerator:(unsigned int *)arg1 denominator:(unsigned int *)arg2;
- (void)send;
- (void)cancel;
//- (unsigned int)countByEnumeratingWithState:(CDStruct_11f37819 *)arg1 objects:(id *)arg2 count:(unsigned int)arg3;
- (BOOL)wantsSendStatus;
@property(readonly, nonatomic) CKService *service; // @synthesize service=_service;
@property(nonatomic) CKSubConversation *conversation; // @synthesize conversation=_conversation;

@end

@class CKSMSMessageDelivery, NSArray, NSMutableArray, NSString;

@interface CKSMSMessage : CKMessage
{
    NSMutableArray *_messages;
    int _associationID;
    int _rowID;
    CKSMSMessageDelivery *_delivery;
    unsigned int _messagePartsLoaded:1;
    unsigned int _subjectLoaded:1;
    NSArray *_messageParts;
    NSString *_subject;
}

@property(retain, nonatomic) CKSMSMessageDelivery *delivery; // @synthesize delivery=_delivery;
- (void)dealloc;
- (void)_loadFailedSendCount;
- (BOOL)isPlaceholder;
- (BOOL)_loadIsFromDowngrading;
- (void)setIsFromDowngrading:(BOOL)arg1;
- (BOOL)isFromMe;
- (BOOL)_loadIsRead;
- (int)totalMessageCount;
- (int)sentCount;
- (void)_loadUIFlags;
- (void)_loadSubject;
- (id)subject;
- (void)_loadText;
- (BOOL)_loadOutgoing;
- (id)_newParts;
- (void)addMessage:(void *)arg1;
- (void)setMessages:(id)arg1;
- (void)markAsRead;
- (double)_loadDate;
- (id)messages;
- (unsigned int)messagePartCount;
- (id)messagePartAtIndex:(unsigned int)arg1;
- (void)_setParts:(id)arg1;
- (void)loadParts;
- (id)initWithCTMessage:(void *)arg1 messageParts:(id)arg2;
- (id)parts;
- (BOOL)isEqual:(id)arg1;
- (unsigned int)hash;
- (id)initWithCTMessages:(id)arg1 messageParts:(id)arg2;
- (id)initWithRowID:(int)arg1;
- (int)messageCount;
- (BOOL)isForward;
- (void)prepareToResend;
- (id)sender;
- (id)address;
- (BOOL)containsDisplayableMessageParts;
- (void)deleteMessagePart:(id)arg1;
- (void)_setupDeliveryIfPending;
- (void)deliveredSubpart:(int)arg1 totalSubparts:(int)arg2 success:(BOOL)arg3;
- (void)deliveryCompletedForMessage:(id)arg1;
- (void)deliveryFailedForMessage:(id)arg1;
- (void)deliveryPartiallyFailedForMessage:(id)arg1;
- (id)guid;
- (id)sequenceNumber;
- (int)rowID;
@property(readonly, nonatomic) int associationID; // @synthesize associationID=_associationID;

@end

@interface CKConversationList : NSObject {
    NSMutableArray* _trackedConversations; 
    BOOL _loadingConversations; 
    BOOL _loadedConversations; 
    CKConversation* _pendingConversation; 
}
+(id)sharedConversationList;
-(void)sendMessage;
-(void)dealloc;
-(id)init;
-(id)conversationForHandles:(id)arg1 create:(BOOL)arg2;
-(id)conversations;
-(id)conversationForExistingChat:(id)arg1;
-(void)resetCachesAndRegenerateThumbnails;
-(void)unpendConversation;
-(id)conversationForRecipients:(id)arg1 create:(BOOL)arg2;
-(void)setPendingConversation:(id)arg1;
-(void)_abChanged:(id)arg1;
-(void)_handleRegistryDidRegisterChatNotification:(id)arg1;
-(void)_handleRegistryWillUnregisterChatNotification:(id)arg1;
-(void)_handleRegistryDidLoadChatNotification:(id)arg1;
-(void)_handleMemoryWarning:(id)arg1;
-(id)_alreadyTrackedConversationForChat:(id)arg1;
-(void)beginTrackingConversation:(id)arg1 forChat:(id)arg2;
-(id)_beginTrackingConversationWithChat:(id)arg1;
-(id)_conversationForChat:(id)arg1;
-(void)_postConversationListChangedNotification;
-(BOOL)reloadStaleConversations;
-(void)stopTrackingConversation:(id)arg1;
-(BOOL)_shouldFilterForParticipants:(id)arg1;
-(id)conversationForExistingChatWithGroupID:(id)arg1;
-(void)_beginTrackingAllExistingChatsIfNeeded;
-(void)resort;
-(void)deleteConversationAtIndex:(unsigned)arg1;
-(id)conversationForExistingChatWithGUID:(id)arg1;
-(id)_copyEntitiesForAddressStrings:(id)arg1;
-(id)conversationForExistingChatWithAddresses:(id)arg1;
-(id)firstUnreadFilteredConversationIgnoringMessages:(id)arg1;
-(id)activeConversations;
-(BOOL)hasActiveConversations;
-(int)unreadFilteredConversationCountIgnoringMessages:(id)arg1;
-(id)unreadLastMessages;
-(void)deleteConversation:(id)arg1;
-(id)pendingConversationCreatingIfNecessary;
-(int)unreadCount;
-(void)resetCaches;
@end

@interface SpringBoard : UIApplication
@end

@interface SBApplication : NSObject
@property(readonly, nonatomic) int pid;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
- (id)applicationWithDisplayIdentifier:(id)arg1;
@end

@interface BKSProcessAssertion : NSObject
- (id)initWithPID:(int)arg1 flags:(unsigned int)arg2 reason:(unsigned int)arg3 name:(id)arg4 withHandler:(id)arg5;
@end

@interface UIWindow (Hermes)
+ (void)setAllWindowsKeepContextInBackground:(_Bool)arg1;
@end

@class WAChatSession;
@interface UIApplication (HermesWhatsApp)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
-(id)_accessibilityFrontMostApplication;
@end
@interface SBApplication (HermesWhatsApp)
-(id)bundleIdentifier;
@end
@interface NSConcreteNotification : NSObject
@property NSDictionary* userInfo;
@end
@interface WhatsAppGarbClass
-(UIAlertView*)createQRAlertWithType:(NSString*)type name:(NSString*)name text:(NSString*)text;
@end
@interface WAChatStorage : NSObject
-(id)existingChatSessionForJID:(id)jid;
-(id)messageWithText:(id)text inChatSession:(id)session isBroadcast:(BOOL)brodcast;
-(void)sendMessage:(id)message notify:(BOOL)notify;
@end
@interface ChatManager : NSObject
@property WAChatStorage* storage;
+(ChatManager*)sharedManager;
@end
@interface WAMessage : NSObject
@property (nonatomic,retain) NSString* fromJID; 
@property (nonatomic,retain) NSString* toJID; 
@property (nonatomic,retain) NSString* text; 
@property (nonatomic,retain) NSNumber* isFromMe; 
@property (nonatomic,retain) NSString* pushName;
@end


