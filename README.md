# Toast-Swift

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/91d3addee9e94a0cad9436601d4a4e1e)](https://www.codacy.com/gh/BastiaanJansen/Toast-Swift/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=BastiaanJansen/Toast-Swift&amp;utm_campaign=Badge_Grade)
![](https://img.shields.io/github/license/BastiaanJansen/Toast-Swift)
![](https://img.shields.io/github/issues/BastiaanJansen/Toast-Swift)

A Swift Toast view - iOS 14 style - built with UIKit. 🍞

<div align="center">
  <div>
    <img src="Screenshots/Text.png" width="250px">
    <img src="Screenshots/Airpods-Pro.png" width="250px">
    <img src="Screenshots/Airpods-Max.png" width="250px">
  </div>

  <div>
    <img src="Screenshots/Text-Dark.png" width="250px">
    <img src="Screenshots/Airpods-Pro-Dark.png" width="250px">
    <img src="Screenshots/Airpods-Max-Dark.png" width="250px">
  </div>
</div>

## Installation

### Swift Package Manager
You can use The Swift Package Manager to install Toast-Swift by adding the description to your Package.swift file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR PROJECT NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/BastiaanJansen/Toast-Swift", from: "1.0.0")
    ]
)
```

Next, add Toast-Swift to your targets dependencies:
```swift
.target(
    name: "YOUR PROJECT NAME",
    dependencies: [
        "Toast",
    ]
),
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

### Custom toast view
Don't like the default Apple'ish style? No problem, it is also possible to use a custom toast view with the `custom` method. Firstly, create a class that confirms to the `ToastView` protocol:
```swift
class CustomToastView : UIView, ToastView {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    func viewDidLoad() {
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

The `show` method accepts several optional parameters. `haptic` of type `UINotificationFeedbackGenerator.FeedbackType` to use haptics and `after` of type `TimeInterval` to show the toast after a certain amount of time:
```swift
toast.show(haptic: .success, after: 1)
```

### Configuration options    
The `text`, `default` and `custom` methods support custom configuration options. The following options are available:

|      Name      |       Type      | Default |
|:--------------:|:---------------:|:-------:|
|    autoHide    |      `Bool`     |  `true` |
|   displayTime  |  `TimeInterval` |   `4`   |
|  swipeUpToHide |      `Bool`     |  `true` |
|  animationTime |  `TimeInterval` |  `0.2`  |
| removeFromView | `Bool`          | `false` |
|      view      |     `UIView`    |  `nil`  |
|      onTap     | `(Toast) -> ()` |  `nil`  |


```swift
let config = ToastConfiguration(
    autoHide: true,
    displayTime: 5,
    swipeUpToHide: true,
    animationTime: 0.2,
    removeFromView: true, // When enabled, you can only call .show() once. After the toast is closed, it will be removed from the view.
    onTap: { toast in
      toast.close()
    }
)

let toast = toast.text("Safari pasted from Notes", config: config)
```
