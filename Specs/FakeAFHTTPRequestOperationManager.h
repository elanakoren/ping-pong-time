//
//  FakeAFHTTPRequestOperationManager.h
//  TeenFeedback
//
//  Created by pivotal on 2/25/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface FakeAFHTTPRequestOperationManager : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSURLRequest *lastRequest;
@property (nonatomic, strong) SuccessBlock lastSuccessBlock;
@property (nonatomic, strong) FailureBlock lastFailureBlock;

@end
