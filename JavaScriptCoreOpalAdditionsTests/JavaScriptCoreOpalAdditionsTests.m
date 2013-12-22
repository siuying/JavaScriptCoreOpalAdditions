//
//  JavaScriptCoreOpalAdditionsTests.m
//  JavaScriptCoreOpalAdditionsTests
//
//  Created by Chong Francis on 13年12月22日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSContext+OpalAdditions.h"

@interface JavaScriptCoreOpalAdditionsTests : XCTestCase {
    JSContext* context;
}
@end

@interface JSContext (OpalAdditionsPrivate)
@property (nonatomic, retain) JSValue* opalCompiler;
@end

@implementation JavaScriptCoreOpalAdditionsTests

- (void)setUp
{
    [super setUp];
    
    context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"compile error: %@", exception);
    };
}

- (void)tearDown
{
    context.exceptionHandler = nil;
    context = nil;
    [super tearDown];
}

- (void)testEvaluateRubyScript
{
    JSValue* value = [context evaluateRubyScript:@"[1,2,3,4,5].reduce(0){|total, i| total = total + i }"];
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
    [context evaluateRubyScript:userRbScript];

    JSValue* value = [context evaluateRubyScript:@"User.new('Peter').name"];
    XCTAssertFalse([value isUndefined], @"result should not be undefined");
    XCTAssertEqualObjects(@"Peter", [value toString], @"should return user name");
}

- (void)testOpalCompiler
{
    [context evaluateRubyScript:@"[1,2,3,4,5]"];
    XCTAssertNotNil(context.opalCompiler, @"compiler should not be nil");
}

@end
