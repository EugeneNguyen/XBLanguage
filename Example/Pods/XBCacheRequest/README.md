# XBCacheRequest

[![CI Status](http://img.shields.io/travis/eugenenguyen/XBCacheRequest.svg?style=flat)](https://travis-ci.org/eugenenguyen/XBCacheRequest)
[![Version](https://img.shields.io/cocoapods/v/XBCacheRequest.svg?style=flat)](http://cocoadocs.org/docsets/XBCacheRequest)
[![License](https://img.shields.io/cocoapods/l/XBCacheRequest.svg?style=flat)](http://cocoadocs.org/docsets/XBCacheRequest)
[![Platform](https://img.shields.io/cocoapods/p/XBCacheRequest.svg?style=flat)](http://cocoadocs.org/docsets/XBCacheRequest)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XBCacheRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod "XBCacheRequest"

## Getting Started

####1. Import the most important header

```objective-c
#import <XBCacheRequest.h>
```

####2. Start your request
```objective-c
XBCacheRequest *request = XBCacheRequest(@"http://123.com/abc");
[request setDataPost:[@{@"foo": @"bar",
@"veryfoor": @"bartoo"} mutableCopy]];
[request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error) {
if (error)
{
// handle error
}
else
{
// handle response
}
}];
```

####3. You can also disable cache system by adding

```objective-c
request.disableCache = YES;
```

####4. And can set default host for the whole project just by

```objective-c
[[XBCacheRequestManager sharedInstance] setHost:@"http://example.com"];
// and normally user request without host
XBCacheRequest *request = XBCacheRequest(@"abc");
// but even can work with another host
XBCacheRequest *request = XBCacheRequest(@"http://123.com/abc");

```

## Author

eugenenguyen, xuanbinh91@gmail.com

## License

XBCacheRequest is available under the MIT license. See the LICENSE file for more info.

