//
//  WordSource.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "WordSource.h"
#import "HTAutocompleteTextField.h"

@implementation WordSource
- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {
    return @"Hello";
}

@end
