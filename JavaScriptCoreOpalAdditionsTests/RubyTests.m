//
//  RubyTests.m
//  JavaScriptCoreOpalAdditions
//
//  Created by Francis Chong on 1/12/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <JavaScriptCore/JavaScriptCore.h>
#import "JSContext+OpalAdditions.h"

@interface RubyTests : XCTestCase {
    JSContext* context;
}
@end

@implementation RubyTests

- (void)setUp
{
    [super setUp];
    
    context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *errorContext, JSValue *exception) {
        NSLog(@"compile error: %@", exception);
        errorContext.exception = exception;
    };
}
- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


- (void)testEvaluateRubyScript
{
    JSValue* value = [context evaluateRuby:@"[1,2,3,4,5].inject{|total, i| total + i }"];
    XCTAssertFalse([value isUndefined], @"result should not be undefined");
    XCTAssertEqualObjects(@(15), [value toNumber], @"should eval ruby script");
}

- (void)testEvaluateRubyClass
{
    NSURL* userUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"user" withExtension:@"rb"];
    NSString* userRbScript = [[NSString alloc] initWithContentsOfURL:userUrl
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
    XCTAssertNotNil(userRbScript, @"should read script file user.rb");
    [context evaluateRuby:userRbScript];
    
    JSValue* value = [context evaluateRuby:@"User.new('Peter').name"];
    XCTAssertFalse([value isUndefined], @"result should not be undefined");
    XCTAssertEqualObjects(@"Peter", [value toString], @"should return user name");
}

-(void) testRequrieFromRuby {
    JSValue* singleton = [context evaluateRuby:@"Singleton"];
    XCTAssertTrue([singleton isUndefined], @"Singleton class is undefined");

    [context evaluateRuby:@"require 'singleton'"];
    singleton = [context evaluateRuby:@"Singleton"];
    XCTAssertEqualObjects(@"Singleton", [singleton toString], @"Singleton class should have been defined");
}

@end
