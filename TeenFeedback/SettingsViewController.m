//
//  SettingsViewController.m
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "SettingsViewController.h"
#import "APIClient.h"
#import "KSDeferred.h"

@interface SettingsViewController ()
@property APIClient *apiClient;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *spinnerView;
@property (strong, nonatomic, readwrite) UIAlertView *currentAlertView;
@end

@implementation SettingsViewController

- (id)initWithAPIClient:(APIClient *)apiClient {
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
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

    KSDeferred *deferred = [self.apiClient updateName:self.textField.text];
    [deferred.promise then:^id(NSDictionary *value) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WELCOME!"
                                                            message:[NSString stringWithFormat:@"Congratulations, you're now %@!", value[@"name"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        self.currentAlertView = alertView;
        [self.currentAlertView show];
        [self.spinnerView stopAnimating];
        return nil;
    } error:^id(NSError *error) {
        return nil;
    }];

    //  then:^{
//        //get rid of spinner,
//        //show confirmation
//        //etc.
//    } error:^{
//        //show pop-up with error
//    }];
}

@end
