# XBExtension

[![CI Status](http://img.shields.io/travis/eugene nguyen/XBExtension.svg?style=flat)](https://travis-ci.org/eugene nguyen/XBExtension)
[![Version](https://img.shields.io/cocoapods/v/XBExtension.svg?style=flat)](http://cocoadocs.org/docsets/XBExtension)
[![License](https://img.shields.io/cocoapods/l/XBExtension.svg?style=flat)](http://cocoadocs.org/docsets/XBExtension)
[![Platform](https://img.shields.io/cocoapods/p/XBExtension.svg?style=flat)](http://cocoadocs.org/docsets/XBExtension)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use this extension inside your project, just import

    #import "XBExtension.h"

## How to use

very simple. just use which function that you want

Remember to import umbrella header first

```objective-c
#import <XBExtension.h>
```

1. AppUtil allow you shortened some action.

```objective-c
[XBAppUtil call:@"123456789"];
[XBAppUtil callPromt:@"123456789"];
[XBAppUtil openURL:@"https://github.com/EugeneNguyen/XBExtension"];
```

2. Using XBColor to make things better

```objective-c
XBHexColor(@"abcdef");
XBRGBColor(255, 0, 0);
```



## Installation

XBExtension is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "XBExtension"

## Author

eugene nguyen, xuanbinh91@gmail.com

## License

XBExtension is available under the MIT license. See the LICENSE file for more info.

