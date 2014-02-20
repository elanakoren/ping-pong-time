//
//  FileStorage.h
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileStorage : NSObject
-(FileStorage *) initWithFilename:(NSString *) filename;
-(void) append:(NSString *) string;
-(NSArray *) all;
@end
