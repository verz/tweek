//
//  ViewController.h
//  Tweek
//
//  Created by Shamansky A. on 8/25/14.
//  Copyright (c) 2014 Shamansky A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *twtTable;

@end
