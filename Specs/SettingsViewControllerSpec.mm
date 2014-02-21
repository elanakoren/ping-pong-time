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
            settingsViewController.textField.text = @"Alex";
            [settingsViewController.saveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should send a network call with the content of the text field", ^{
            apiClient should have_received(@selector(updateName:)).with(@"Alex");
        });
    });
});

SPEC_END
