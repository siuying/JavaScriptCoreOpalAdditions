//
//  OpalAdditions.m
//  JavaScriptCoreOpalAdditions
//
//  Created by Francis Chong on 1/12/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "OpalCore.h"
#import "JSContext+OpalAdditions.h"

@implementation OpalCore

#pragma mark - JSExport

+(void) require:(NSString*)filename {
    JSContext* context = [JSContext currentContext];
    if (!context) {
        NSLog(@"error: require should only be called inside a JSContext");
        [NSException raise:NSInternalInconsistencyException format:@"require should only be called inside a JSContext"];
    }

    NSError* error = nil;
    [context requireRubyWithFilename:filename error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

+(void) puts:(NSString*)message {
    NSLog(@"%@", message);
}

+(NSBundle*) opalBundle {
    static dispatch_once_t onceToken;
    static NSBundle* _opalBundle;
    dispatch_once(&onceToken, ^{
        NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"Opal" ofType:@"bundle"];
        _opalBundle = [NSBundle bundleWithPath:resourceBundlePath];
    });
    return _opalBundle;
}

/**
 Return the default loadpaths
 */
+(NSArray*) defaultLoadPaths {
    NSString* opalPath = [[OpalCore opalBundle] bundlePath];
    if (opalPath == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"cannot find opal bundle!"];
    }
    return @[opalPath];
}

@end
