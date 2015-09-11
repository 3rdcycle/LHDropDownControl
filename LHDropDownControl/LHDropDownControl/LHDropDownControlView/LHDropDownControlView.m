//
//  LHDropDownControlView.m
//  DropDownControl
//
//  Created by Lukas Heiniger on 06.12.12.
//  Copyright (c) 2012 cyclus.ch, L. Heiniger. All rights reserved.
//

#import "LHDropDownControlView.h"
#import <QuartzCore/QuartzCore.h>

#define kOptionHeight 20
#define kOptionSpacing 1
#define kAnimationDuration 0.2

@implementation LHDropDownControlView {
    CGFloat mBaseHeight;
    
    // Configuration
    NSArray *mSelectionOptions, *mSelectionTitles;

    // Subviews
    UILabel *mTitleLabel;
    UIImage *mBgImage;
    NSMutableArray *mSelectionCells;
    
    // Control state
    BOOL mControlIsActive;
    NSInteger mSelectionIndex;
    NSInteger mPreviousSelectionIndex;
}


#pragma mark - Object Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.optionHeight = kOptionHeight;
    mBaseHeight = self.frame.size.height;
    // Background
    mBgImage = [[UIImage imageNamed:@"Drop Down Button BG"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:mBgImage];
    backGroundView.frame = self.bounds;
    [self addSubview:backGroundView];
    
    // Title
    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    mTitleLabel.textAlignment = NSTextAlignmentCenter;
    mTitleLabel.textColor = [UIColor whiteColor];
    mTitleLabel.backgroundColor = [UIColor clearColor];
    mTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:mTitleLabel];
}

- (void)layoutSubviews {
    NSLog(@"Layout Subviews");
    [super layoutSubviews];
    mTitleLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10, mBaseHeight);
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    _title = title;
    mTitleLabel.text = title;
}


#pragma mark - Configuration

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles {
    if ([selectionOptions count] != [selectionOptionTitles count]) {
        [NSException raise:NSInternalInconsistencyException format:@"selectionOptions and selectionOptionTitles must contain the same number of objects"];
    }
    mSelectionOptions = selectionOptions;
    mSelectionTitles = selectionOptionTitles;
    mSelectionCells = nil;
}


#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
        [self activateControl];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    
    // Calculate the selection index
    CGPoint location = [touch locationInView:self];
    if ((CGRectContainsPoint(self.bounds, location)) && (location.y > mBaseHeight)) {
        mSelectionIndex = (location.y - mBaseHeight - kOptionSpacing) / (self.optionHeight + kOptionSpacing);
    } else {
        mSelectionIndex = NSNotFound;
    }
    
    if (mSelectionIndex == mPreviousSelectionIndex) 
        return;
    
    // Selection animation
    if (mSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, -6, 0);
        }];
    }
    if (mPreviousSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mPreviousSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, 6, 0);
        }];
    }
    mPreviousSelectionIndex = mSelectionIndex;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
        if (mSelectionIndex < [mSelectionOptions count]) {
            [self.delegate dropDownControlView:self didFinishWithSelection:[mSelectionOptions objectAtIndex:mSelectionIndex]];
        } else {
            [self.delegate dropDownControlView:self didFinishWithSelection:nil];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
    }
}

#pragma mark - View Transformation

- (CATransform3D)contractedTransorm {
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, M_PI / 2, 1, 0, 0);
    t.m34 = -1.0/50;
    return t;
}

#pragma mark - Control Activation / Deactivation

- (void)activateControl {
    mControlIsActive = YES;
    
    mSelectionIndex = NSNotFound;
    mPreviousSelectionIndex = NSNotFound;
    
    if ([self.delegate respondsToSelector:@selector(dropDownControlViewWillBecomeActive:)]) {
        [self.delegate dropDownControlViewWillBecomeActive:self];
    }
    
    // Prepare the selection cells
    if (mSelectionCells == nil) {
        mSelectionCells = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i < [mSelectionTitles count]; i++) {
            UIImageView *newCell = [[UIImageView alloc] initWithImage:mBgImage];
            newCell.frame = CGRectMake(0, mBaseHeight + (i * self.optionHeight + kOptionSpacing) + kOptionSpacing, self.frame.size.width, self.optionHeight);
            newCell.layer.anchorPoint = CGPointMake(0.5, 0.0);
            newCell.layer.transform = [self contractedTransorm];
            //newCell.alpha = 0;
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectInset(newCell.bounds, 10, 0)];
            newLabel.font = [UIFont systemFontOfSize:14];
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.textColor = [UIColor whiteColor];
            newLabel.text = [mSelectionTitles objectAtIndex:i];
            [newCell addSubview:newLabel];
            
            [self addSubview:newCell];
            [mSelectionCells addObject:newCell];
        }
    }
    
    // Expand our frame
    CGRect newFrame = self.frame;
    newFrame.size.height += [mSelectionOptions count] * (self.optionHeight + kOptionSpacing);
    self.frame = newFrame;

    // Show selection cells animated
    NSUInteger count = [mSelectionCells count];
    for (int i = 0; i < count; i++) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        cell.alpha = 1.0;
        [UIView animateWithDuration:kAnimationDuration delay:(i * kAnimationDuration / count) options:0 animations:^{
            CGRect destinationFrame = CGRectMake(0, mBaseHeight + i * (self.optionHeight + kOptionSpacing) + kOptionSpacing, self.frame.size.width, self.optionHeight);
            cell.frame = destinationFrame;
            cell.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

- (void)inactivateControl {
    mControlIsActive = NO;
    
    int count = (int) [mSelectionCells count];
    for (int i = count - 1; i >= 0; i--) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        [UIView animateWithDuration:kAnimationDuration delay:((count - 1 - i) * kAnimationDuration / count) options:0 animations:^{
            cell.frame = CGRectMake(0, mBaseHeight + (i * self.optionHeight + kOptionSpacing) + kOptionSpacing, self.frame.size.width, mBaseHeight);
            cell.layer.transform = [self contractedTransorm];
        } completion:^(BOOL completed){
            cell.alpha = 0;
            if (i == 0) {
                CGRect newFrame = self.frame;
                newFrame.size.height = mBaseHeight;
                self.frame = newFrame;
            }
    }];
    }
}

@end
