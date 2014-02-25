#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    __block AppDelegate *delegate;

    beforeEach(^{
        delegate = [[AppDelegate alloc] init];
        [delegate application:nil didFinishLaunchingWithOptions:@{}];
    });

    it(@"creates a tab bar with 2 items", ^{
        UITabBarController *tabController = (UITabBarController *)delegate.window.rootViewController;
        tabController should be_instance_of([UITabBarController class]);

        tabController.viewControllers[0] should be_instance_of([ViewController class]);
        [tabController.tabBar.items[0] title] should equal(@"Home");

        tabController.viewControllers[1] should be_instance_of([SettingsViewController class]);
        [tabController.tabBar.items[1] title] should equal(@"Settings");
    });
});

SPEC_END
