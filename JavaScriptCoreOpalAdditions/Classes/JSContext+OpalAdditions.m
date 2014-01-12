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
#import "OpalAdditions.h"
#import "ObjectiveSugar.h"

NSString* const JSContextOpalAdditionsErrorDomain = @"JSContextOpalAdditionsErrorDomain";

@interface JSContext (OpalAdditionsPrivate)
@property (nonatomic, retain) JSValue* opalCompiler;
@end

@implementation JSContext (OpalAdditions)

-(void) loadOpal {
    if ([self[@"Opal"] isUndefined]) {
        NSURL* opalUrl = [[NSBundle mainBundle] URLForResource:@"opal-all" withExtension:@"js"];
        NSString* opalJs = [[NSString alloc] initWithContentsOfURL:opalUrl
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
        NSAssert(opalJs != nil, @"cannot load opal-all.js");
        [self evaluateScript:opalJs];
        
        // setup load path
        [self evaluateRuby:@"$LOAD_PATH = []"];
        NSArray* defaultLoadPaths = [OpalAdditions defaultLoadPath];
        [defaultLoadPaths enumerateObjectsUsingBlock:^(NSString* loadPath, NSUInteger idx, BOOL *stop) {
            [self appendOpalLoadPathsWithPath:loadPath];
        }];
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

-(BOOL) requireRubyWithFilename:(NSString*)filename error:(NSError**)error {
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    
    // find filename from loadPaths
    NSArray* loadPaths = [self opalLoadPaths];
    NSArray* possiblePaths = [loadPaths map:^NSString*(NSString* path) {
        if ([filename hasSuffix:@".rb"]) {
            return [path stringByAppendingPathComponent:filename];
        } else {
            return [[path stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"rb"];
        }
    }];
    NSString* fullpath = [possiblePaths find:^BOOL(NSString* path) {
        return [fileManager fileExistsAtPath:path];
    }];

    if (!fullpath) {
        if (error) {
            *error = [NSError errorWithDomain:JSContextOpalAdditionsErrorDomain
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"cannot load such file -- %@", filename]}];
        }
    }
    
    NSString* rubyScript = [[NSString alloc] initWithContentsOfFile:fullpath
                                                           encoding:NSUTF8StringEncoding
                                                              error:error];
    [self evaluateRuby:rubyScript];
    return YES;
}

-(NSArray*) opalLoadPaths {
    return [[self evaluateRuby:@"$LOAD_PATH.to_n"] toArray];
}

-(NSArray*) appendOpalLoadPathsWithPath:(NSString*)path {
    if (!path) {
        [NSException raise:NSInvalidArgumentException format:@"cannot append nil path: %@", path];
    }

    return [[[self evaluateRuby:@"$LOAD_PATH"] invokeMethod:@"$<<" withArguments:@[path]] toArray];
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
