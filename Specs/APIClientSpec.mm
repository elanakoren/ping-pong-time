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
    __block NSOperationQueue *operationQueue;


    beforeEach(^{
        operationManager = [[FakeAFHTTPRequestOperationManager alloc] initWithBaseURL:@"http://localhost:3000"] ;
        spy_on(operationManager);
        apiClient = [[APIClient alloc] initWithOperationManager:operationManager];

    });

    describe(@"-updateName:", ^{
        beforeEach(^{
            NSUUID *uid = [[NSUUID alloc] initWithUUIDString:@"68753A44-4D6F-1226-9C60-0050E4C00067"];
            UIDevice *currentDevice = nice_fake_for([UIDevice class]);
            currentDevice stub_method(@selector(identifierForVendor)).and_return(uid);

            spy_on([UIDevice class]);
            [UIDevice class] stub_method(@selector(currentDevice)).and_return(currentDevice);
        });

        it(@"should return a KSDeferred", ^{
            [apiClient updateName:@"some name"] should be_instance_of([KSDeferred class]);
        });

        it(@"makes a request with devices unique ID", ^{
            [apiClient updateName:@"some name"];

            [UIDevice currentDevice] should have_received(@selector(identifierForVendor));
            operationManager should have_received(@selector(POST:parameters:success:failure:)).
            with(@"/name_announcements", @{@"phone_id": @"68753A44-4D6F-1226-9C60-0050E4C00067", @"name": @"some name"}, Arguments::anything, Arguments::anything);
        });

        xdescribe(@"when the request is successful", ^{
            __block KSDeferred *deferred;
            __block NSDictionary *fakeJSON;

            beforeEach(^{
                deferred = [apiClient updateName:@"some name"];
                spy_on(deferred);
                fakeJSON = @{}
                operationManager.lastSuccessBlock(nil, fakeJSON);
            });

            it(@"does stuff", ^{
                deferred should have_received(@selector(resolveWithValue:)).with(fakeJson);
            });
        });
    });

});

SPEC_END