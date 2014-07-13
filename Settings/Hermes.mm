//#import <Preferences/Preferences.h>
#import <Preferences/PSListController1.h>
#import <Preferences/PSTableCell.h>
//#import <Preferences/PSEditableListController.h>
//#import "PSViewController.h"

int width = [[UIScreen mainScreen] bounds].size.width;

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface HermesListController: PSListController {
}
@end

@interface HermesCustomCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *_label;
	UILabel *underLabel;
	@public
	UILabel *randLabel;
}
-(NSString*)randomString;
@end
@interface HermesCreditsCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *_label;
	UILabel* underLabel;
}
@end

@interface PSListController (Hermes)
- (void)viewWillDisappear:(BOOL)arg1;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(id)arg2;
@end

@interface PSTableCell (Hermes)
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface PSViewController (CustNav)
@end

@interface NewClass : NSObject
-(void)nextButton;
@end
@interface HermesCreditsListController : PSListController {
}
@end
/*
@interface ActionListController : PSViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tabView;
@property (strong, nonatomic) NSMutableArray *numbArray;
@property (nonatomic) int indexPathToUse;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableDictionary *prefs;
@property (strong, nonatomic) NSMutableArray *wordsArray;
@end
*/
@interface HermesGiantMakerCell1 : PSTableCell {
	UIImageView *_background;
	UILabel *label;
	UILabel *label2;
	UIButton *twitterButton;
	UIButton *githubButton;
	UIButton *emailButton;
}
@end

@interface HermesGiantMakerCell3 : PSTableCell {
	UIImageView *_background;
	UILabel *label;
	UILabel *label2;
	UIButton *twitterButton;
	UIButton *githubButton;
	UIButton *emailButton;
}
@end

@interface hermesOpenTwitterPhillipController : PSListController { }
@end

@interface hermesOpenTwitterJasonController : PSListController { }
@end

@implementation HermesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Hermes" target:self];
	}
	return _specifiers;
}
-(void)respring {
	system("killall backboardd");
}
@end
@implementation HermesCreditsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"HermesCredits" target:self];
	}
	return _specifiers;
}
@end

@implementation HermesCustomCell
- (id)initWithSpecifier:(PSSpecifier *)specifier
{
	//self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self) {
		CGRect frame = CGRectMake(0, -15, width, 60);
		CGRect botFrame = CGRectMake(0, 20, width, 60);
		CGRect randFrame = CGRectMake(0, 40, width, 60);
 
		_label = [[UILabel alloc] initWithFrame:frame];
		[_label setNumberOfLines:1];
		_label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
		[_label setText:@"Hermes"];
		[_label setBackgroundColor:[UIColor clearColor]];
		_label.textColor = [UIColor blackColor];
		//[_label setShadowColor:[UIColor blackColor]];
		//[_label setShadowOffset:CGSizeMake(1,1)];
		_label.textAlignment = NSTextAlignmentCenter;

		underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[underLabel setNumberOfLines:1];
		underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[underLabel setText:@"The lightweight quick reply solution"];
		[underLabel setBackgroundColor:[UIColor clearColor]];
		underLabel.textColor = [UIColor grayColor];
		underLabel.textAlignment = NSTextAlignmentCenter;

		randLabel = [[UILabel alloc] initWithFrame:randFrame];
		[randLabel setNumberOfLines:1];
		randLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[randLabel setText:[self randomString]];
		[randLabel setBackgroundColor:[UIColor clearColor]];
		randLabel.textColor = [UIColor grayColor];
		randLabel.textAlignment = NSTextAlignmentCenter;
 
		[self addSubview:_label];
		[self addSubview:underLabel];
		[self addSubview:randLabel];
		//[_label release];
		//[underLabel release];
		//[randLabel release];

	}
	return self;
}
int randNum = 0;
-(NSString*)randomString {
	//int randNum = arc4random_uniform(10);
	if (randNum == 10) randNum = 0;
	switch (randNum) {
		case 0:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"Thank you for your purchase.";
		case 1:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"Enjoy.";
		case 2:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"From Phillip Tennen.";
		case 3:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"Special thanks to jaysan1292.";
		case 4:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"Use responsibly.";
		case 5:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"Follow @phillipten on Twitter.";
		case 6:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			//return @"From Codyd51";
			return @"Is this thing on?";
		case 7:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"We love you, /r/jailbreak!";
		case 8:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			return @"The quickest way to respond.";
		case 9:
			if (randNum == 0) randNum++;
			else if (randNum < 10 && randNum != 0) randNum++;
			//return @"Is this thing on?"; 
			return @"Aeeiii! I'm a bug.";
		default:
			return @"Aeeiii! I'm a bug.";
	}
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	CGFloat prefHeight = 90.0;
	return prefHeight;
}
@end

@implementation HermesCreditsCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self) {
		CGRect frame = CGRectMake(0, -12.5, width, 60);
		CGRect botFrame = CGRectMake(0, 20, width, 60);

		_label = [[UILabel alloc] initWithFrame:frame];
		[_label setNumberOfLines:1];
		_label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
		[_label setText:@"Credits"];
		[_label setBackgroundColor:[UIColor clearColor]];
		_label.textColor = [UIColor blackColor];
		_label.textAlignment = NSTextAlignmentCenter;

		underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[underLabel setNumberOfLines:1];
		underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[underLabel setText:@"Those who made Hermes possible"];
		[underLabel setBackgroundColor:[UIColor clearColor]];
		underLabel.textColor = [UIColor grayColor];
		underLabel.textAlignment = NSTextAlignmentCenter;

		[self addSubview:_label];
		[self addSubview:underLabel];

	}

	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	CGFloat prefHeight = 60.0;
	return prefHeight;
}
@end

UIColor* color = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];

@implementation HermesGiantMakerCell1
-(id)initWithStyle:(long long)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])){
		UIImage *bkIm = [UIImage imageWithContentsOfFile:@"/Library/Application Support/hermesPhillip.png"];
		CGSize imageSize = bkIm.size;
		CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		// Create the clipping path and add it
		UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
		[path addClip];
		[bkIm drawInRect:imageRect];
		//CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
		[path setLineWidth:30.0f];
		[path stroke];
		UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		bkIm = roundedImage;

		_background = [[UIImageView alloc] initWithImage:bkIm];
		_background.frame = CGRectMake(9, 18, 65, 65);
		[self addSubview:_background];
		
		CGRect frame = [self frame];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 84, frame.origin.y + 18, frame.size.width, frame.size.height)];
		[label setText:@"Phillip Tennen"];
		[label setBackgroundColor:[UIColor clearColor]];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[label setFont:[UIFont fontWithName:@"Helvetica Light" size:30]];
		else
			[label setFont:[UIFont fontWithName:@"Helvetica Light" size:21]];

		[self addSubview:label];
		
		label2 = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 84, frame.origin.y + 42, frame.size.width, frame.size.height)];

		[label2 setText:@"Developer"];
		[label2 setBackgroundColor:[UIColor clearColor]];
		[label2 setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];
		[self addSubview:label2];
	}
	return self;
}

@end

@implementation HermesGiantMakerCell3
-(id)initWithStyle:(long long)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])){
		UIImage *bkIm = [UIImage imageWithContentsOfFile:@"/Library/Application Support/hermesJason.png"];
		CGSize imageSize = bkIm.size;
		CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		// Create the clipping path and add it
		UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
		[path addClip];
		[bkIm drawInRect:imageRect];
		//CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
		[path setLineWidth:30.0f];
		[path stroke];
		UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		bkIm = roundedImage;

		_background = [[UIImageView alloc] initWithImage:bkIm];
		_background.frame = CGRectMake(9, 18, 65, 65);
		[self addSubview:_background];
		
		CGRect frame = [self frame];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 84, frame.origin.y + 18, frame.size.width, frame.size.height)];
		[label setText:@"Jason Recillo"];
		[label setBackgroundColor:[UIColor clearColor]];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[label setFont:[UIFont fontWithName:@"Helvetica Light" size:30]];
		else
			[label setFont:[UIFont fontWithName:@"Helvetica Light" size:21]];

		[self addSubview:label];
		
		label2 = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 84, frame.origin.y + 42, frame.size.width, frame.size.height)];

		[label2 setText:@"Mentor"];
		[label2 setBackgroundColor:[UIColor clearColor]];
		[label2 setFont:[UIFont fontWithName:@"Helvetica Light" size:15]];
		[self addSubview:label2];
	}
	return self;
}

@end

@implementation hermesOpenTwitterPhillipController
- (id)specifiers {
	NSString *user = @"phillipten";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	
	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	return 0;
}

- (void)viewDidAppear:(BOOL)arg1 {
	UINavigationController *navController = self.navigationController;
	[navController popViewControllerAnimated:YES];
}
@end

@implementation hermesOpenTwitterJasonController
- (id)specifiers {
	NSString *user = @"jaysan1292";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	
	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	return 0;
}

- (void)viewDidAppear:(BOOL)arg1 {
	UINavigationController *navController = self.navigationController;
	[navController popViewControllerAnimated:YES];
}
@end

// vim:ft=objc
