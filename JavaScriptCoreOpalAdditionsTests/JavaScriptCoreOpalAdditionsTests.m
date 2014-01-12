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
#import "IGAppDelegate.h"

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
    context.exceptionHandler = ^(JSContext *errorContext, JSValue *exception) {
        NSLog(@"compile error: %@", exception);
        errorContext.exception = exception;
    };
}

- (void)tearDown
{
    context.exceptionHandler = nil;
    context = nil;
    [super tearDown];
}

- (void)testLoadOpal
{
    [context loadOpal];
    XCTAssertNotNil(context[@"Opal"], @"load opal");
    XCTAssertFalse([context[@"Opal"] isUndefined], @"load opal");
    XCTAssertNotNil(context[@"Opal.compile"], @"load opal compiler");
    XCTAssertFalse([context[@"Opal"][@"compile"] isUndefined], @"load opal");
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

- (void)testCompileRuby {
    NSString* javaScript = [context compileRuby:@"1 + 1"];
    XCTAssertNotNil(javaScript, @"compiled script cannot be nil");
    XCTAssertNil(context.exception, @"exception should not be nil");

    javaScript = [context compileRuby:@"1 as["];
    XCTAssertNil(javaScript, @"retrun nil on compile error");
    XCTAssertNotNil(context.exception, @"exception should not be nil");
}

- (void)testOpalCompiler
{
    [context evaluateRuby:@"[1,2,3,4,5]"];
    XCTAssertNotNil(context.opalCompiler, @"compiler should not be nil");
}

- (void)testOpalCompilerIrbMode
{
    NSString* js = [context compileRuby:@"i = 1" irbMode:YES];
    XCTAssertTrue([js rangeOfString:@"irb_vars"].location != NSNotFound, @"js contains IRB");
}


- (void)testOpalRequire
{
    NSError* error;
    JSValue* singleton = [context evaluateRuby:@"Singleton"];
    XCTAssertTrue([singleton isUndefined], @"Singleton class is undefined");

    [context requireRubyWithFilename:@"singleton" error:&error];
    XCTAssertNil(error, @"should not have error");

    singleton = [context evaluateRuby:@"Singleton"];
    XCTAssertEqualObjects(@"Singleton", [singleton toString], @"Singleton class should have been defined");
    
    [context requireRubyWithFilename:@"erb.rb" error:&error];
    JSValue* erb = [context evaluateRuby:@"ERB"];
    XCTAssertEqualObjects(@"ERB", [erb toString], @"erb class should have been defined by require erb.rb");
}

@end
