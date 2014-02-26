//
//  SettingsViewController.h
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APIClient;

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UISwitch *playSwitch;
@property (strong, nonatomic, readonly) UIActivityIndicatorView *spinnerView;
@property (strong, nonatomic, readonly) UIAlertView *currentAlertView;

- (id)initWithAPIClient:(APIClient *)apiClient;

@end
