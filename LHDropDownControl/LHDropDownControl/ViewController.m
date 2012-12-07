//
//  ViewController.m
//  LHDropDownControl
//
//  Created by Lukas Heiniger on 07.12.12.
//  Copyright (c) 2012 cyclus.ch, L. Heiniger. All rights reserved.
//

#import "ViewController.h"
#import "LHDropDownControlView.h"

@interface ViewController ()

@end

@implementation ViewController {
    LHDropDownControlView *mDropDownView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    mDropDownView = [[LHDropDownControlView alloc] initWithFrame:CGRectMake(180, 20, 100, 24)];
    mDropDownView.title = @"Select";
    mDropDownView.delegate = self;
    
    // Add a bunch of options
    NSMutableArray *options = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    for (int i=1; i<=10; i++) {
        [options addObject:[NSNumber numberWithInt:i]];
        [titles addObject:[NSString stringWithFormat:@"Option %d", i]];
    }
    [mDropDownView setSelectionOptions:options withTitles:titles];
    
    [container addSubview:mDropDownView];
    return container;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Cell Text";
    return cell;
}


#pragma mark - Drop Down Selector Delegate

- (void)dropDownControlViewWillBecomeActive:(LHDropDownControlView *)view  {
    self.tableView.scrollEnabled = NO;
}

- (void)dropDownControlView:(LHDropDownControlView *)view didFinishWithSelection:(id)selection {
    self.tableView.scrollEnabled = YES;
    mDropDownView.title = [NSString stringWithFormat:@"Selected: %@", selection ? : @"-"];
}

@end
