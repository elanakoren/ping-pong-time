//
//  SettingsViewController.m
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "SettingsViewController.h"
#import "APIClient.h"

@interface SettingsViewController ()
@property APIClient *apiClient;
@end

@implementation SettingsViewController

- (id)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.saveButton addTarget:self
                        action:@selector(buttonTouch)
              forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonTouch {
    [self.textField resignFirstResponder];

    if (!self.spinnerView) {
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
        self.spinnerView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }
    [self.spinnerView setHidden:NO];
    [self.spinnerView startAnimating];
    [self.view addSubview:self.spinnerView];
//
    [self.apiClient updateName:self.textField.text];
}

@end
