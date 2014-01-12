//
//  OpalAdditions.h
//  JavaScriptCoreOpalAdditions
//
//  Created by Francis Chong on 1/12/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class OpalCore;

@protocol OpalCoreExport <JSExport>

+(void) require:(NSString*)filename;

+(void) puts:(NSString*)message;

@end

@interface OpalCore : NSObject <OpalCoreExport>

@end
