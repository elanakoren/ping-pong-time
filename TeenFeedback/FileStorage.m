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
    return [[NSArray alloc] init];
}
-(void) append:(NSString *)string {
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:self.filename];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    contents = [contents stringByAppendingString:string];
    [contents writeToFile:path atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];
}
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
@end
