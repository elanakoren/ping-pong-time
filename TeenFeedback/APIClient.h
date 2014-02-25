//
//  APIClient.h
//  TeenFeedback
//
//  Created by pivotal on 2/21/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSPromise, AFHTTPRequestOperationManager;

@interface APIClient : NSObject

-(id)initWithOperationManager:(AFHTTPRequestOperationManager *)operationManager;
-(KSPromise *)updateName:(NSString *)name;

@end
