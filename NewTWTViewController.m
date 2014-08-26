//
//  NewTWTViewController.m
//  Tweek
//
//  Created by Shamansky A. on 8/25/14.
//  Copyright (c) 2014 Shamansky A. All rights reserved.
//

#import "NewTWTViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "constants.h"


@interface NewTWTViewController ()

@end

@implementation NewTWTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self addInputAccessoryViewForTextView:self.textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
	self.textField.text = @"";
}

- (void)addInputAccessoryViewForTextView:(UITextView *)textView{
	
	UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
	[toolbar sizeToFit];
	toolbar.barStyle = UIBarButtonSystemItemAdd;
	
	
	toolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
					 [[UIBarButtonItem alloc]initWithTitle:@"Post!" style:UIBarButtonItemStyleDone target:self action:@selector(returnTextView:)],
					 nil];
	
	[textView setInputAccessoryView:toolbar];
	
}

- (void) returnTextView:(UIButton *)sender{
	
	[self.textField resignFirstResponder];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
	[self postTwtWithText:self.textField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postTwtWithText:(NSString*) newTwt{
	ACAccountStore *account = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
								  ACAccountTypeIdentifierTwitter];
	[account requestAccessToAccountsWithType:accountType
									 options:nil
								  completion:^(BOOL granted, NSError *error) {
		if (!granted) {
			  return;
		}
		
		NSArray *accounts = [account accountsWithAccountType:accountType];
		if (!accounts.count) {
			return;
		}
		
		ACAccount *twitterAccount = [accounts lastObject];
		[self postUpdate:twitterAccount withText:newTwt];
	}];
}

-(void)postUpdate:(ACAccount *)account withText:(NSString*)newTwt {
	NSDictionary* params = @{@"status": newTwt};
	NSURL *requestURL = [NSURL URLWithString:UPDATE_URL];
	SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
												requestMethod:SLRequestMethodPOST
														  URL:requestURL
												   parameters:params];
	postRequest.account = account;
	[postRequest performRequestWithHandler:^(NSData *responseData,
											 NSHTTPURLResponse *urlResponse, NSError *error) {
	//NSLog(@"Twitter HTTP response: %i", [urlResponse statusCode]);
	}];
}
@end
