# Toast-Swift

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/6eeb888f65db4c168435e739cb7c84e3)](https://www.codacy.com/gh/BastiaanJansen/Toast-Swift/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=BastiaanJansen/Toast-Swift&amp;utm_campaign=Badge_Grade)
![](https://img.shields.io/github/license/BastiaanJansen/Toast-Swift)
![](https://img.shields.io/github/issues/BastiaanJansen/Toast-Swift)

A Swift Toast view - iOS 14 style - built with UIKit. 🍞

<img src="Screenshots/Grid.png">

## Installation

### Swift Package Manager
You can use The Swift Package Manager to install Toast-Swift by adding the description to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/BastiaanJansen/toast-swift", from: "1.0.4")
]
```

### CocoaPods
```swift
pod "ToastViewSwift"
```

## Usage
To create a simple text based toast:
```swift
let toast = Toast.text("Safari pasted from Notes")
toast.show()
```

Or add a subtitle:
```swift
let toast = Toast.text("Safari pasted from Notes", subtitle: "A few seconds ago")
toast.show()
```

If you want to add an icon, use the `default` method to construct a toast:
```swift
let toast = Toast.default(
    image: UIImage(systemname: "airpodspro")!,
    title: "Airpods Pro",
    subtitle: "Connected"
)
toast.show()
```

Want to use a different layout, but still use the Apple style? Create your own view and inject it into the `AppleToastView` class when creating a custom toast:
```swift
let customView: UIView = // Custom view

let appleToastView = AppleToastView(child: customView)

let toast = Toast.custom(view: appleToastView)
toast.show()
```

The `show` method accepts several optional parameters. `haptic` of type `UINotificationFeedbackGenerator.FeedbackType` to use haptics and `after` of type `TimeInterval` to show the toast after a certain amount of time:
```swift
toast.show(haptic: .success, after: 1)
```

### Configuration options    
The `text`, `default` and `custom` methods support custom configuration options. The following options are available:
|      Name        | Description                                                                                     |       Type      | Default |
|:----------------:|-------------------------------------------------------------------------------------------------|:---------------:|:-------:|
|    `autoHide`    | When set to true, the toast will automatically close itself after display time has elapsed.     |      `Bool`     |  `true` |
|   `displayTime`  | The duration the toast will be displayed before it will close when autoHide set to true.        |  `TimeInterval` |   `4`   |
|  `animationTime` | Duration of the show and close animation.                                                       |  `TimeInterval` |  `0.2`  |
|    `attachTo`    | The view which the toast view will be attached to.                                              |     `UIView`    |  `nil`  |


```swift
let config = ToastConfiguration(
    autoHide: true,
    displayTime: 5,
    animationTime: 0.2
)

let toast = toast.text("Safari pasted from Notes", config: config)
```

### Custom toast view
Don't like the default Apple'ish style? No problem, it is also possible to use a custom toast view with the `custom` method. Firstly, create a class that confirms to the `ToastView` protocol:
```swift
class CustomToastView : UIView, ToastView {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    func createView(for toast: Toast) {
        // View is added to superview, create and style layout and add constraints
    }
}
```
Use your custom view with the `custom` construct method on `Toast`:
```swift
let customToastView: ToastView = CustomToastView(text: "Safari pasted from Notes")

let toast = Toast.custom(view: customToastView)
toast.show()
```

## Licence
Toast-Swift is available under the MIT licence. See the LICENCE for more info.

[![Stargazers repo roster for @BastiaanJansen/Toast-Swift](https://reporoster.com/stars/BastiaanJansen/Toast-Swift)](https://github.com/BastiaanJansen/Toast-Swift/stargazers)
