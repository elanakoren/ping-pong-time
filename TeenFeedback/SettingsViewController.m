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
    [self.apiClient updateName:self.textField.text];
}

@end
