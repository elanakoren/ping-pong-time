//
//  APIClient.m
//  TeenFeedback
//
//  Created by pivotal on 2/21/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "APIClient.h"
#import "KSPromise.h"
#import "KSDeferred.h"
#import "AFHTTPRequestOperationManager.h"

@interface APIClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end


@implementation APIClient

- (id)initWithOperationManager:(AFHTTPRequestOperationManager *)operationManager {
    self = [super init];
    if (self) {
        self.operationManager = operationManager;
    }
    return self;
}

-(KSDeferred *)updateName:(NSString *)name {
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSDictionary *parameters = @{@"phone_id": [oNSUUID UUIDString], @"name": name};

    KSDeferred *deferred = [[KSDeferred alloc] init];
    [self.operationManager POST:@"/name_announcements" parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", responseObject);
                            [deferred resolveWithValue:responseObject];
                        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [deferred rejectWithError:error];
    }];
    return deferred;
}

@end
