//
//  OpalAdditions.m
//  JavaScriptCoreOpalAdditions
//
//  Created by Francis Chong on 1/12/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OpalAdditions.h"

static NSArray* _defaultLoadPaths;

@implementation OpalAdditions

+(NSArray*) defaultLoadPath {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLoadPaths = @[[[NSBundle bundleForClass:[self class]] pathForResource:@"stdlib" ofType:nil]];
    });
    return _defaultLoadPaths;
}

+(JSValue*) hashWithDictionary:(NSDictionary*)dictionary context:(JSContext*)context {
    return [[context evaluateScript:@"Opal.hash2"] callWithArguments:@[dictionary.allKeys, dictionary]];
}

@end
