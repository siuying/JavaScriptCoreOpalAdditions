//
//  OpalAdditions.h
//  JavaScriptCoreOpalAdditions
//
//  Created by Francis Chong on 1/12/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface OpalAdditions : NSObject

+(NSArray*) defaultLoadPath;

/**
 Create a Hash object from a NSDictionary
 */
+(JSValue*) hashWithDictionary:(NSDictionary*)dictionary context:(JSContext*)context;

@end
