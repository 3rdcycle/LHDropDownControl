//
//  LHDropDownControlView.h
//  DropDownControl
//
//  Created by Lukas Heiniger on 06.12.12.
//  Copyright (c) 2012 cyclus.ch, L. Heiniger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHDropDownControlView;



@protocol LHDropDownControlViewDelegate <NSObject>

// Selection contains the user selected option or nil if nothing was selected
- (void)dropDownControlView:(LHDropDownControlView *)view didFinishWithSelection:(id)selection;

@optional

// You can use this to disable scrolling on a tableView
- (void)dropDownControlViewWillBecomeActive:(LHDropDownControlView *)view;

@end



@interface LHDropDownControlView : UIView

@property (nonatomic) NSString *title;
@property (nonatomic, weak) id<LHDropDownControlViewDelegate> delegate;

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles;

@end
