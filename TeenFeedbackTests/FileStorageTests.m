//
//  FileStorageTests.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileStorage.h"

@interface FileStorageTests : XCTestCase

@end

@implementation FileStorageTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    FileStorage * store = [[FileStorage alloc] initWithFilename:@"foo.txt"];
    [store append:@"abc"];
    [store append:@"123"];
    
    FileStorage * store2 = [[FileStorage alloc] initWithFilename:@"foo.txt"];
    NSArray * contents = [store2 all];
    XCTAssert([[contents objectAtIndex:0] isEqualToString:@"abc"]);
    XCTAssert([[contents objectAtIndex:1] isEqualToString:@"123"]);
}

@end
