#import "SettingsViewController.h"
#import "APIClient.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(SettingsViewSpec)

describe(@"SettingsViewController", ^{
    __block SettingsViewController *settingsViewController;
    __block APIClient *apiClient;

    beforeEach(^{
        apiClient = nice_fake_for([APIClient class]);
        settingsViewController = [[SettingsViewController alloc] initWithAPIClient:apiClient];
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

    });
});

SPEC_END
