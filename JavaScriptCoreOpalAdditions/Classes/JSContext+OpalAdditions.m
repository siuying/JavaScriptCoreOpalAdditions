//
//  JSContext+OpalAdditions.m
//  JavaScriptCoreOpalAdditions
//
//  Created by Chong Francis on 13年12月22日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "JSContext+OpalAdditions.h"

@interface JSContext (OpalAdditionsPrivate)
@property (nonatomic, retain) JSValue* opalCompiler;
@end

@implementation JSContext (OpalAdditions)

-(void) loadOpal {
    if ([self[@"Opal"] isUndefined]) {
        NSURL* opalUrl = [[NSBundle mainBundle] URLForResource:@"opal" withExtension:@"js"];
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
    }
}

-(NSString*) compileRuby:(NSString*)ruby {
    if (!ruby) {
        return nil;
    }
    
    if (!self.opalCompiler) {
        [self loadOpal];
        [self setOpalCompiler:[self evaluateScript:@"Opal.compile"]];
    }

    JSValue* compiledScript = [self.opalCompiler callWithArguments:@[ruby]];
    if ([compiledScript isUndefined]) {
        return nil;
    } else {
        return [compiledScript toString];
    }
}

- (JSValue *)evaluateRuby:(NSString *)ruby {
    if (!ruby) {
        return nil;
    }

    NSString* compileScriptString = [self compileRuby:ruby];
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
