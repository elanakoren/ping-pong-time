//
//  FakeAFHTTPRequestOperationManager.m
//  TeenFeedback
//
//  Created by pivotal on 2/25/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "FakeAFHTTPRequestOperationManager.h"

@implementation FakeAFHTTPRequestOperationManager

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    self.lastRequest = request;
    self.lastSuccessBlock = success;
    self.lastFailureBlock = failure;

    return nil;
}

@end
