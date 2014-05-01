# KZNSideMenuViewController
===============


## Feature
![Screenshot](https://raw2.github.com/kenzan8000/KZNSideMenuViewController/master/Screenshot/Screenshot.gif "Screenshot")


## Installation

### CocoaPods
If you are using CocoaPods, then just add KZNSideMenuViewController to you Podfile.
```ruby
pod 'KZNSideMenuViewController', :git => 'https://github.com/kenzan8000/KZNSideMenuViewController.git'
```

### Manually
Simply add the files in the KZNSideMenuViewController directory to your project.


## Example
```objective-c
    sideMenuViewController.leftViewController = leftViewController;
    sideMenuViewController.rightViewController = rightViewController;
```
```objective-c
    if ([sideMenuViewController isPresentSideMenuViewController]) {
        [sideMenuViewController dismissSideMenuViewControllerAnimated:YES];
    }
    else {
        [sideMenuViewController presentSideMenuViewControllerAnimated:YES
                                                                 side:kKZNSideMenuViewControllerSideLeft];
    }
```


## License
Released under the MIT license.
