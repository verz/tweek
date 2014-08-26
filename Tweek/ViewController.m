//
//  ViewController.m
//  Tweek
//
//  Created by Shamansky A. on 8/25/14.
//  Copyright (c) 2014 Shamansky A. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "constants.h"


@interface ViewController ()

@property (strong,nonatomic) NSArray *tweetArr;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getTweetTimeLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tweetArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        
    }
    //NSLog(@"%@",self.tweetArr.description);

    NSDictionary *twitDic = [_tweetArr objectAtIndex:indexPath.row];
    NSDictionary *userDic = [twitDic objectForKey:@"user"];

    cell.detailTextLabel.text =[userDic objectForKey:@"name"];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1];
    cell.textLabel.text = [twitDic objectForKey:@"text"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 85;
}

-(void)getTweetTimeLine{
    ACAccountStore* account = [[ACAccountStore alloc] init];
    ACAccountType * accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted,NSError* error){
        if (!granted) {
            NSLog(@"%@",[error localizedDescription]);
            return;
        }
        
        NSArray *accounts = [account accountsWithAccountType:accountType];
        if (!accounts.count) {
            return;
        }
                                      
        [self getTimelineWithParameteres:[accounts lastObject]];
    }];
}

-(void)getTimelineWithParameteres:(ACAccount*)account {
    NSURL * requestUrl = [NSURL URLWithString:TIMELINE_URL];
    NSDictionary* params = @{@"count": @"50", @"include_entities": @"1"};
    SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                          requestMethod:SLRequestMethodGET
                                                    URL:requestUrl
                                             parameters:params];
    posts.account = account;
    [posts performRequestWithHandler:^(NSData *response,NSHTTPURLResponse *urlResponse, NSError* errorNew){
        self.tweetArr = [NSJSONSerialization JSONObjectWithData:response
                                                        options:NSJSONReadingMutableLeaves
                                                          error:&errorNew];
        
        if (self.tweetArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.twtTable reloadData];
            });
        }
    }];
}

@end
