#import "APIClient.h"
#import "KSPromise.h"
#import "AFHTTPRequestOperationManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(APIClientSpec)

describe(@"APIClient", ^{
    __block APIClient *apiClient;
    __block AFHTTPRequestOperationManager *operationManager;
    __block NSOperationQueue *operationQueue;


    beforeEach(^{
        operationManager = nice_fake_for([AFHTTPRequestOperationManager class]);
        spy_on(operationManager);
        operationQueue = [[NSOperationQueue alloc] init];
        operationManager stub_method(@selector(operationQueue)).and_return(operationQueue);
        operationManager stub_method(@selector(baseURL)).and_return(@"http://localhost:3000");
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

        it(@"should return a KSPromise", ^{
            [apiClient updateName:@"some name"] should be_instance_of([KSPromise class]);
        });

        it(@"makes a request with devices unique ID", ^{
            [apiClient updateName:@"some name"];

            [UIDevice currentDevice] should have_received(@selector(identifierForVendor));
            operationManager should have_received(@selector(POST:parameters:success:failure:)).
            with(@"/name_announcements", @{@"phone_id": @"68753A44-4D6F-1226-9C60-0050E4C00067", @"name": @"some name"}, Arguments::anything, Arguments::anything);
        });

        xdescribe(@"when the request is successful", ^{
            //TODO: test this better
            beforeEach(^{
                [apiClient updateName:@"some name"];
//                NSInvocation *postRequest = (NSInvocation *)[[operationManager sent_messages] firstObject];
//                AFHTTPRequestOperation *returnValue = nil;
//                [postRequest getReturnValue:&returnValue];
//                NSLog(@"================> %@", (AFHTTPRequestOperation *)returnValue);
            });

            it(@"does stuff", ^{

            });
        });
    });

});

SPEC_END