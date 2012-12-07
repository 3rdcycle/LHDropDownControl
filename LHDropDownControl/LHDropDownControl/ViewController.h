//
//  ViewController.h
//  LHDropDownControl
//
//  Created by Lukas Heiniger on 07.12.12.
//  Copyright (c) 2012 cyclus.ch, L. Heiniger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHDropDownControlView.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LHDropDownControlViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;

@end
