//
//  CounterTests.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Counter.h"

@interface CounterTests : XCTestCase

@end

@implementation CounterTests

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

- (void)testCounterWorks
{
    NSLog(@"hello!~"); 
    Counter * counter = [[Counter alloc] init];
    [counter inc];
    XCTAssert([counter count] == 1);
}

@end
