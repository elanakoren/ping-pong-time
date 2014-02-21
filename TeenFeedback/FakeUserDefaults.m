//
//  FakeUserDefaults.m
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "FakeUserDefaults.h"

@interface FakeUserDefaults ()
@property NSMutableDictionary * dictionary;
@end

@implementation FakeUserDefaults
- (id) init {
    self = [super init];
    if (self)
    {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self.dictionary setObject:[NSNumber numberWithInteger:value] forKey:key];
}
- (NSInteger)integerForKey:(NSString *)key {
    return [[self.dictionary objectForKey:key] integerValue];
}

@end
