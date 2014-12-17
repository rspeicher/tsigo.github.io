---
title: Using Objective-C CocoaPods libraries with Swift
categories: swift xcode cocoa
---

I recently started experimenting with the [Swift] language and one of its
selling points is that it can take advantage of the myriad Objective-C libraries
already written.

### CocoaPods

[CocoaPods] is an Objective-C (and currently *only* Objective-C) dependency
manager. It's a nice convenient way to bring external libraries into your
project, but using it to bring a dependency into a Swift project took a little
bit of doing, so I thought I'd explain how I got it working.

I wanted to use the [FontAwesomeIconFactory] pod in a Swift-only project. First
I'll add it to my `Podfile` as per the instructions:

```ruby
platform :ios, '8.0'

pod 'FontAwesomeIconFactory'
```

Then run `pod install` and let it do its thing. Now let's open the project in
XCode with `open ExampleSwiftProject.xcworkspace`.

### The Bridging Header

[Apple's documentation] for using Swift and Objective-C in the same project
briefly mentions creating an **Objective-C bridging header** file. Create one by
right-clicking the project in the **Project Navigator**, and going to **New
File**. Select **Source** under **iOS** (or **OS X** depending on your project
type), and finally **Header File**. For the sake of following Apple's suggested
naming convention, name the file `ExampleSwiftProject-Bridging-Header.h`.

The newly created file has some boilerplate code in it. We need to modify it to
include FontAwesomeIconFactory's headers to expose its methods to our Swift
code:

```objective-c
// ExampleSwiftProject-Bridging-Header.h

#ifndef ExampleSwiftProject_ExampleSwiftProject_Bridging_Header_h
#define ExampleSwiftProject_ExampleSwiftProject_Bridging_Header_h

#import "NIKFontAwesomeIconFactory.h"
#import "NIKFontAwesomeIconFactory+iOS.h"

#endif
```

Now we need to tell the compiler that this bridge exists. Select the project in
the **Project Navigator**, select **Build Settings** at the top and, to make
things simple, type "bridging" into the search bar. Double-click the blank field
corresponding to **Objective-C Bridging Header** and enter the name of the file
we created above *relative to the project root*. In our case, this should be
`ExampleSwiftProject-Bridging-Header.h`

<p class="text-center"><img src="http://fat.gfycat.com/CharmingLegalErmine.gif" alt="Bridging
Header"/></p>

Now build and... huh, 17 errors?

<p class="text-center"><img src="/assets/2014-11-06-errors.png" alt="Compile
Errors"/></p>

Looking at the errors in the **Issue Navigator**, we see all kinds of complaints
about "Unknown type name `UIColor`", `NSArray`, `NSObject`, and so on. These are
built-in UIKit and Foundation classes, so what gives?

Well, in this case the FontAwesomeIconFactory library's author took for granted
that any project including his library would already be including the necessary
headers for a basic Objective-C program. But we're a Swift program! Let's just
give it the headers it needs back in our bridging header file:

```objective-c
// ExampleSwiftProject-Bridging-Header.h

#ifndef ExampleSwiftProject_ExampleSwiftProject_Bridging_Header_h
#define ExampleSwiftProject_ExampleSwiftProject_Bridging_Header_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIKFontAwesomeIconFactory.h"
#import "NIKFontAwesomeIconFactory+iOS.h"

#endif
```

Now the compiler's happy. Let's put an icon on a button!

```swift
// Controllers/ExampleTableViewController.swift

import UIKit

class ExampleTableViewController: UITableViewController {
    @IBOutlet weak var randomButton: UIBarButtonItem!

    override func viewDidLoad() {
        let factory = NIKFontAwesomeIconFactory.barButtonItemIconFactory()
        randomButton.title = ""
        randomButton.image = factory.createImageForIcon(NIKFontAwesomeIconRandom)
    }
}
```

I never got very deep into Objective-C, but I'm really liking what I've seen of
Swift so far and I'm looking forward to using it more in the future.

[Swift]: https://developer.apple.com/swift/
[CocoaPods]: http://cocoapods.org/
[FontAwesomeIconFactory]: http://nschum.github.io/FontAwesomeIconFactory/
[Apple's documentation]: https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html
