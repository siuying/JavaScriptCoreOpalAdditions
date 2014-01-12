# JavaScriptCore OpalAdditions

Ruby for Objective-C, via Opal and JavaScriptCore.

## Usage

### Evaulate Ruby in JavaScriptCore JSContext

```
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSContext+OpalAdditions.h"

JSValue* value = [context evaluateRuby:@"[1,2,3,4,5].inject{|total, i| total + i }"];
[value toNumber]; // => 15
```

### How require works

Opal works by compile Ruby into JavaScript. When running on JavaScriptCore however,
you don't want to load everything into the context unless you needed.

OpalAdditions modify Opal to allow require dynamically. You may require a ruby file
in Objective-C or Ruby in runtime.

```
// require with Ruby
[context evaluateRuby:@"require 'singleton'"];

or 

// require with Objective-C
[context requireRubyWithFilename:@"singleton" error:nil];
```

OpalAdditions will search the filename from LOAD_PATH.

### Add your custom gems to LOAD_PATH

You can add more path to LOAD_PATH to load your custom gems:

```
// Add load path
NSString* newPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"gems" ofType:nil];
[context appendOpalLoadPathsWithPath:newPath];

// load addition gems
[context requireRubyWithFilename:@"my_awesome_gems" error:nil];
```

You might want to add your gem path as "Folder Reference" instead of regular "Group".

## Installation

To install JavaScriptCoreOpalAdditions throught CocoaPods, add following lines to your Podfile:

```
pod "JavaScriptCoreOpalAdditions", '~> 0.2.4'

```

## Development

Install Pods for Objective-C libraries

1. pod install

Download submodule for opal, and build necessary files:

1. git submodule update --init
2. bundle install
3. bundle exec rake

## Dependencies

- JavaScriptCore (iOS 7.0+)
- Ruby (to compile opal)

