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

    NSError* error;
    [context requireRubyWithFilename:filename error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

+(void) puts:(NSString*)message {
    NSLog(@"%@", message);
}

@end
