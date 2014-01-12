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
    return [self compileRuby:ruby irbMode:NO];
}

-(NSString*) compileRuby:(NSString *)ruby irbMode:(BOOL)irbMode {
    if (!ruby) {
        return nil;
    }

    JSValue* compiler = [self opalCompiler];
    JSValue* compiledScript;

    if (irbMode) {
        JSValue* compilerOption = [self hashWithDictionary:@{@"irb": @(irbMode)}];
        compiledScript = [compiler invokeMethod:@"$compile" withArguments:@[ruby, compilerOption]];
    } else {
        compiledScript = [compiler invokeMethod:@"$compile" withArguments:@[ruby]];
    }

    if ([compiledScript isUndefined]) {
        return nil;
    } else {
        return [compiledScript toString];
    }
}

- (JSValue *)evaluateRuby:(NSString *)ruby {
    return [self evaluateRuby:ruby irbMode:NO];
}

-(JSValue *) evaluateRuby:(NSString *)ruby irbMode:(BOOL)irbMode {
    if (!ruby) {
        return nil;
    }
    
    NSString* compileScriptString = [self compileRuby:ruby irbMode:irbMode];
    if (compileScriptString) {
        return [self evaluateScript:compileScriptString];
    } else {
        return nil;
    }
}

#pragma mark - Getter and Setters

- (JSValue*)opalCompiler {
    JSValue* compiler = objc_getAssociatedObject(self, @selector(opalCompiler));
    if (!compiler) {
        [self loadOpal];

        compiler = [self evaluateScript:@"Opal.Opal.Compiler.$new()"];
        [self setOpalCompiler:compiler];
    }
    return compiler;
}

- (void)setOpalCompiler:(JSValue*)opalCompiler {
    objc_setAssociatedObject(self, @selector(opalCompiler), opalCompiler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private

/**
 Return a opal Hash with a NSDictionary.

 Important: Opal must have been loaded (with [context loadOpal]) before calling this!
 */
-(JSValue*) hashWithDictionary:(NSDictionary*)dictionary {
    return [[self evaluateScript:@"Opal.hash2"] callWithArguments:@[dictionary.allKeys, dictionary]];
}

@end
