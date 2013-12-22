//
//  JSContext+OpalAdditions.m
//  JavaScriptCoreOpalAdditions
//
//  Created by Chong Francis on 13年12月22日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import "JSContext+OpalAdditions.h"
#import <objc/objc-runtime.h>

@interface JSContext (OpalAdditionsPrivate)
@property (nonatomic, retain) JSValue* opalCompiler;
@end

@implementation JSContext (OpalAdditions)

- (JSValue *)evaluateRubyScript:(NSString *)rubyScript {
    if (!rubyScript) {
        return nil;
    }

    if (!self.opalCompiler) {
        NSURL* opalUrl = [[NSBundle mainBundle] URLForResource:@"opal" withExtension:@"js"];
        NSLog(@"opalUrl = %@", opalUrl);
        NSString* opalJs = [[NSString alloc] initWithContentsOfURL:opalUrl
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
        NSAssert(opalJs != nil, @"cannot load opal.js");

        NSURL* opalParserUrl = [[NSBundle mainBundle] URLForResource:@"opal-parser" withExtension:@"js"];
        NSString* opalParserJs = [[NSString alloc] initWithContentsOfURL:opalParserUrl
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
        NSAssert(opalParserJs != nil, @"cannot load opal-parser.js");
        [self evaluateScript:opalJs];
        [self evaluateScript:opalParserJs];
        self.opalCompiler = [self evaluateScript:@"Opal.compile"];
    }
    
    JSValue* compiledScript = [self.opalCompiler callWithArguments:@[rubyScript]];
    NSString* compileScriptString = [compiledScript toString];
    return [self evaluateScript:compileScriptString];
}

#pragma mark - Getter and Setters

- (JSValue*)opalCompiler {
    return objc_getAssociatedObject(self, @selector(opalCompiler));
}

- (void)setOpalCompiler:(JSValue*)opalCompiler {
    objc_setAssociatedObject(self, @selector(opalCompiler), opalCompiler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
