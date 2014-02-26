#import "APIClient.h"
#import "KSPromise.h"
#import "AFHTTPRequestOperationManager.h"
#import "KSDeferred.h"
#import "FakeAFHTTPRequestOperationManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(APIClientSpec)

describe(@"APIClient", ^{
    __block APIClient *apiClient;
    __block FakeAFHTTPRequestOperationManager *operationManager;
    __block NSUUID *uid;

    beforeEach(^{
        NSURL *baseURL = [NSURL URLWithString:@"http://localhost:3000"];
        operationManager = [[FakeAFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        spy_on(operationManager);
        apiClient = [[APIClient alloc] initWithOperationManager:operationManager];

        uid = [[NSUUID alloc] initWithUUIDString:@"68753A44-4D6F-1226-9C60-0050E4C00067"];
        UIDevice *currentDevice = nice_fake_for([UIDevice class]);
        currentDevice stub_method(@selector(identifierForVendor)).and_return(uid);

        spy_on([UIDevice class]);
        [UIDevice class] stub_method(@selector(currentDevice)).and_return(currentDevice);

    });

    describe(@"-updateName:", ^{
        it(@"should return a KSDeferred", ^{
            [apiClient updateName:@"some name"] should be_instance_of([KSDeferred class]);
        });

        it(@"makes a request to /name_announcments with device's UUID", ^{
            [apiClient updateName:@"some name"];

            [UIDevice currentDevice] should have_received(@selector(identifierForVendor));
            operationManager should have_received(@selector(POST:parameters:success:failure:)).
            with(@"/name_announcements", @{@"phone_id": @"68753A44-4D6F-1226-9C60-0050E4C00067", @"name": @"some name"}, Arguments::anything, Arguments::anything);
        });
    });

    describe(@"-shout", ^{
        it(@"returns a KSDeferred", ^{
            [apiClient shout] should be_instance_of([KSDeferred class]);
        });

        it(@"makes a request to /shouts with device's UUID", ^{
            [apiClient shout];

            [UIDevice currentDevice] should have_received(@selector(identifierForVendor));
            operationManager should have_received(@selector(POST:parameters:success:failure:))
            .with(@"/shouts", @{@"phone_id": @"68753A44-4D6F-1226-9C60-0050E4C00067"}, Arguments::anything, Arguments::anything);
        });
    });

});

SPEC_END
