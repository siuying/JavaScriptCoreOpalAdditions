# JavaScriptCore OpalAdditions

Extend JavaScriptCore to evaluate Ruby via Opal.

## Usage

```
JSValue* value = [context evaluateRubyScript:@"[1,2,3,4,5].inject{|total, i| total + i }"];
[value toNumber]; // => 15
```

## Installation

To install JavaScriptCoreOpalAdditions throught CocoaPods, add following lines to your Podfile:

```
pod "JavaScriptCoreOpalAdditions"
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

