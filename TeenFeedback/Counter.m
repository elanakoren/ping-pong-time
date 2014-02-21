//
//  Counter.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "Counter.h"

@interface Counter ()
@property int counter;
@property NSUserDefaults * userDefaults;
@end

@implementation Counter
- (id)initWithUserDefaults:(id)userDefaults {
    // Forward to the "designated" initialization method
    self = [super init];
    if (self) {
        self.userDefaults = userDefaults;
        self.counter = [userDefaults integerForKey:@"counter"];
    }
    return self;
}
- (void)inc{
    self.counter += 1;
    [self.userDefaults setInteger:self.counter forKey:@"counter"];
}

- (int)count{
    return self.counter;
}

@end
