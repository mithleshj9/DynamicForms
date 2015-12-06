//
//  ViewController.h
//  DynamicForms
//
//  Created by Mithlesh Jha on 12/5/15.
//  Copyright (c) 2015 Mithlesh Jha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (void) startLoadingWidgetsInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *widgetsContainerScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

