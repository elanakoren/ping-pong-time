//
//  Counter.h
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Counter : NSObject
- (id) initWithUserDefaults:(id)defaults;
- (void)inc;
- (int)count;
@end
