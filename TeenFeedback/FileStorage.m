//
//  FileStorage.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "FileStorage.h"

@interface FileStorage ()
@property NSString * filename;
@end

@implementation FileStorage
-(FileStorage *) initWithFilename:(NSString *)filename {
    self.filename = filename;
    return self;
}

-(NSArray *) all {
    NSData* data = [NSData dataWithContentsOfFile:self.filename];
    __autoreleasing NSError* error = nil;
    NSArray * array;
    if (data != nil) {
        array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        array = [NSArray array];
    }
    NSLog(@"----------------");
    NSLog([array componentsJoinedByString:@","]);
    NSLog(@"----------------");
    return array;
}

-(void) append:(NSString *)string {

    NSArray * array = self.all;
    array = [array arrayByAddingObject:string];
    __autoreleasing NSError* error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];
    NSString *path = self.filename;
    
    [data writeToFile:path atomically:YES];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
@end
