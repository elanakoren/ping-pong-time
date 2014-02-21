//
//  FakeUserDefaults.h
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeUserDefaults : NSObject
- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (NSInteger)integerForKey:(NSString *)defaultName;
@end
