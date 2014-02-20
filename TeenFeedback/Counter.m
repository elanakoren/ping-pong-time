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
@end

@implementation Counter
- (id)init {
    // Forward to the "designated" initialization method
    self = [super init];
    if (self) {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        self.counter = [standardUserDefaults integerForKey:@"counter"];
    }
    return self;
}
- (void)inc{
    self.counter += 1;
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:self.counter forKey:@"counter"];
}

- (int)count{
    return self.counter;
}

@end
