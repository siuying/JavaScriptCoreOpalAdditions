//
//  JSContext+OpalAdditions.h
//  JavaScriptCoreOpalAdditions
//
//  Created by Chong Francis on 13年12月22日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSContext (OpalAdditions)

/**
 Load Opal corelib and compiler into current context.
 */
-(void) loadOpal;

/**
 Compile Ruby into JavaScript.

 @param ruby, the ruby source
 @return compiled javascript, or nil if an error occurred.
 */
-(NSString*) compileRuby:(NSString*)ruby;

/**
 Compile Ruby into JavaScript.
 
 @param ruby, the ruby source
 @param irbMode, enable IRB mode when compiling with Opal
 @return compiled javascript, or nil if an error occurred.
 */
-(NSString*) compileRuby:(NSString *)ruby irbMode:(BOOL)irbMode;

/**
 Compile Ruby into JavaScript, then evaulate it.
 
 @return evaulated value.
 */
-(JSValue *) evaluateRuby:(NSString *)ruby;

/**
 Compile Ruby into JavaScript, then evaulate it.

 @param ruby, the ruby source
 @param irbMode, enable IRB mode when compiling with Opal
 @return evaulated value.
 */
-(JSValue *) evaluateRuby:(NSString *)ruby irbMode:(BOOL)irbMode;

@end
