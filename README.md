# JavaScriptCore OpalAdditions

Extend JavaScriptCore to evaluate Ruby via Opal.

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

