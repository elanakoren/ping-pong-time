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
@property (nonatomic) APIClient *apiClient;
@property (nonatomic) NSRunLoop *timerRunLoop;
@property (nonatomic) NSTimer *timer;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *spinnerView;
@end

@implementation SettingsViewController

- (id)initWithAPIClient:(APIClient *)apiClient {
    return [self initWithAPIClientandRunLoop:apiClient timerRunLoop:[NSRunLoop mainRunLoop]];
}

- (id)initWithAPIClientandRunLoop:(APIClient *)apiClient timerRunLoop:(NSRunLoop *)timerRunLoop {
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
        self.timerRunLoop = timerRunLoop;
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)viewDidLoad {
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
        if (value[@"error"]) {
            [self presentErrorAlert];
            return nil;
        }

        [self presentWelcomeAlertWithName:value[@"name"]];

        return nil;
    } error:^id(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                            message:error.userInfo[@"NSLocalizedDescription"]                                                         delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self.spinnerView stopAnimating];
        return nil;
    }];
}

- (IBAction)playSwitchToggled:(UISwitch *)sender {
    if (self.playSwitch.on == YES) {
        [self.apiClient shout];


        self.timer = [NSTimer timerWithTimeInterval:30
                                                 target:self
                                               selector:@selector(timerFired)
                                               userInfo:nil
                                                repeats:YES];
        [self.timerRunLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];

        [self.timer fire];
    } else {
        [self.apiClient nak];
        [self.timer invalidate];
    }
}

- (void)timerFired {
    KSDeferred *deferred = [self.apiClient status];

    [deferred.promise then:^id(NSDictionary *value) {
        if (value[@"match_id"]) {
            [self.timer invalidate];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opponent"
                                                                message:[NSString stringWithFormat:@"Do you want to play %@" , value[@"name"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"NO!"
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        return nil;
    } error:^id(NSError *error) {
        return nil;
    }];
}

#pragma mark - Private

- (void)presentErrorAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Name is already taken!"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    [self.spinnerView stopAnimating];
}

- (void)presentWelcomeAlertWithName:(NSString *)name {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WELCOME!"
                                                        message:[NSString stringWithFormat:@"Congratulations, you're now %@!", name]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [self.spinnerView stopAnimating];
}

@end
