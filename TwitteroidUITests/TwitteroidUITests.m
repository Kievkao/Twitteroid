//
//  TwitteroidUITests.m
//  TwitteroidUITests
//
//  Created by Andrii Kravchenko on 4/27/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TwitteroidUITests : XCTestCase

@end

@implementation TwitteroidUITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
}

@end
