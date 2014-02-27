#import "SettingsViewController.h"
#import "APIClient.h"
#import "KSPromise.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(SettingsViewSpec)

describe(@"SettingsViewController", ^{
    __block SettingsViewController *settingsViewController;
    __block APIClient *apiClient;
    __block KSDeferred *deferred;
    __block NSRunLoop <CedarDouble> *timerRunLoop;
    __block NSUUID *uid;
    __block NSTimer *timer;
    __block UIDevice *currentDevice;

    beforeEach(^{
        apiClient = nice_fake_for([APIClient class]);
        timerRunLoop = nice_fake_for([NSRunLoop class]);
        settingsViewController = [[SettingsViewController alloc] initWithAPIClientandRunLoop:apiClient timerRunLoop:timerRunLoop];

        deferred = [[KSDeferred alloc] init];
        apiClient stub_method(@selector(updateName:)).and_return(deferred);
        apiClient stub_method(@selector(status)).and_return(deferred);

        settingsViewController.view should_not be_nil;

    });

    it(@"should have a text field", ^{
        settingsViewController.textField should_not be_nil;
    });

    it(@"should have a save button", ^{
        settingsViewController.saveButton.titleLabel.text should equal(@"Save");
    });

    describe(@"tapping the save button", ^{
        beforeEach(^{
            UIWindow *responderChain = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            [responderChain addSubview:settingsViewController.view];
            [responderChain makeKeyAndVisible];

            settingsViewController.textField.text = @"Alex";
            [settingsViewController.textField becomeFirstResponder];
            [settingsViewController.textField isFirstResponder] should be_truthy;

            [settingsViewController.saveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should send a network call with the content of the text field", ^{
            apiClient should have_received(@selector(updateName:)).with(@"Alex");
        });

        it(@"should dismiss the keyboard", ^{
            [settingsViewController.textField isFirstResponder] should be_falsy;
        });

        it(@"should show a spinner", ^{
            settingsViewController.spinnerView.isHidden should be_falsy;
            settingsViewController.spinnerView.isAnimating should be_truthy;
        });

        describe(@"when the request is successful", ^{
            beforeEach(^{
                [deferred resolveWithValue:@{@"name": @"Alex"}];
            });

            it(@"displays a popup", ^{
                UIAlertView *alertView = settingsViewController.currentAlertView;
                alertView.title should equal(@"WELCOME!");
                alertView.message should equal(@"Congratulations, you're now Alex!");
                alertView.numberOfButtons should equal(1);
                alertView.cancelButtonIndex should equal(0);
                [alertView buttonTitleAtIndex:0] should equal(@"OK");
            });

            it(@"hides the spinner", ^{
                settingsViewController.spinnerView.isAnimating should be_falsy;
                settingsViewController.spinnerView.isHidden should be_truthy;
            });
        });

        describe(@"when the request is not sucessful", ^{
            beforeEach(^{
                NSError *error = [[NSError alloc]initWithDomain:@"AFNetworkingErrorDomain" code:-1011 userInfo:@{@"NSLocalizedDescription": @"Name is already taken"}];
                [deferred rejectWithError: error];
            });

            it(@"should dispaly an error message", ^{
                UIAlertView *alertView = settingsViewController.currentAlertView;
                alertView.title should equal(@"ERROR!");
                alertView.message should equal(@"Name is already taken");
                alertView.numberOfButtons should equal(1);
                alertView.cancelButtonIndex should equal(0);
                [alertView buttonTitleAtIndex:0] should equal(@"OK");
            });
        });

        describe(@"when the request fails due to the name already being taken", ^{
            beforeEach(^{
                [deferred resolveWithValue:@{@"error": @"Name taken"}];
            });;

            it(@"should display a popup with the error message", ^{
                UIAlertView *alertView = settingsViewController.currentAlertView;
                alertView.title should equal(@"Error!");
                alertView.message should equal(@"Name is already taken!");
                alertView.numberOfButtons should equal(1);
                alertView.cancelButtonIndex should equal(0);
                [alertView buttonTitleAtIndex:0] should equal(@"OK");
            });
        });
    });

    describe(@"switching the play switch to on", ^{
        beforeEach(^{
            settingsViewController.playSwitch.on = YES;
            [settingsViewController.playSwitch sendActionsForControlEvents:UIControlEventValueChanged];

            uid = [[NSUUID alloc] initWithUUIDString:@"68753A44-4D6F-1226-9C60-0050E4C00067"];
            currentDevice = nice_fake_for([UIDevice class]);
            currentDevice stub_method(@selector(identifierForVendor)).and_return(uid);

            spy_on([UIDevice class]);
            [UIDevice class] stub_method(@selector(currentDevice)).and_return(currentDevice);
        });

        it(@"should send a message to the server", ^{
            apiClient should have_received(@selector(shout));
        });

        it(@"should start a timer", ^{
            timerRunLoop should have_received(@selector(addTimer:forMode:));
            NSInvocation *timerAddInvocation = timerRunLoop.sent_messages.firstObject;

            [timerAddInvocation getArgument:&timer atIndex:2]; //change this back to 2

            timer should_not be_nil;
        });

        it(@"should poll the server with a status call", ^{
            apiClient should have_received(@selector(status));
        });

        describe(@"when the server returns match data", ^{
            beforeEach(^{
                [deferred resolveWithValue:@{
                     @"status": @"waiting",
                     @"match_id": @"1",
                     @"name": @"bob",
                     @"created_at": @"2014-01-01"
                 }];
            });

            it(@"should stop the timer", ^{
                NSInvocation *timerAddInvocation = timerRunLoop.sent_messages.firstObject;

                __autoreleasing NSTimer *timer;
                [timerAddInvocation getArgument:&timer atIndex:2];
                [timer isValid] should be_falsy;
            });

            it(@"should bring up match information (opponent name, confirm, deny button)", ^{
                UIAlertView *alertView = settingsViewController.currentAlertView;
                alertView.title should equal(@"Opponent");
                alertView.message should equal(@"Do you want to play bob");
                alertView.numberOfButtons should equal(2);
                alertView.cancelButtonIndex should equal(0);
                [alertView buttonTitleAtIndex:0] should equal(@"OK");
                [alertView buttonTitleAtIndex:1] should equal(@"NO!");
            });
        });

        describe(@"when the server does not return match data", ^{
            beforeEach(^{
                [deferred resolveWithValue:@{
                     @"status": @"waiting"
                }];
            });

            it(@"should not stop the timer", ^{
                NSInvocation *timerAddInvocation = timerRunLoop.sent_messages.firstObject;

                [timerAddInvocation getArgument:&timer atIndex:2];
                [timer isValid] should be_truthy;
            });
        });

        describe(@"switching the play switch to off", ^{
            beforeEach(^{
                settingsViewController.playSwitch.on = NO;
                [settingsViewController.playSwitch sendActionsForControlEvents:UIControlEventValueChanged];

                spy_on([UIDevice class]);
            });

            it(@"should send a message to the server", ^{
                apiClient should have_received(@selector(nak));
            });

            it(@"should stop the timer if it exists", ^{

                NSInvocation *timerAddInvocation = timerRunLoop.sent_messages.firstObject;
                [timerAddInvocation getArgument:&timer atIndex:2];

                (timer == nil || [timer isValid]) should be_falsy;
            });
        });
    });

});

SPEC_END
