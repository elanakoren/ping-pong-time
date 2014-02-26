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

    beforeEach(^{
        apiClient = nice_fake_for([APIClient class]);
        settingsViewController = [[SettingsViewController alloc] initWithAPIClient:apiClient];

        deferred = [[KSDeferred alloc] init];
        apiClient stub_method(@selector(updateName:)).and_return(deferred);
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
});

SPEC_END
