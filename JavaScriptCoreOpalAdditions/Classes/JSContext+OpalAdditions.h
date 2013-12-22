//
//  JSContext+OpalAdditions.h
//  JavaScriptCoreOpalAdditions
//
//  Created by Chong Francis on 13年12月22日.
//  Copyright (c) 2013年 Ignition Soft. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSContext (OpalAdditions)

-(JSValue *) evaluateRubyScript:(NSString *)script;

@end
