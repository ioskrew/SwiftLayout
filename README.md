<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit & AppKit**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)

```swift
@LayoutBuilder var layout: some Layout {
  self.sl.sublayout {
    leftParenthesis.sl.anchors {
      Anchors.leading.equalToSuper(constant: 16)
      Anchors.centerY
    }
    viewLogo.sl.anchors {
      Anchors.leading.equalTo(leftParenthesis, attribute: .trailing, constant: 20)
      Anchors.centerY.equalToSuper(constant: 30)
      Anchors.size.equalTo(width: 200, height: 200)
    }
    UIImageView().sl.identifying("plus").sl.onActivate { imageView in
      imageView.image = UIImage(systemName: "plus")
      imageView.tintColor = .SLColor
    }.anchors {
      Anchors.center.equalToSuper(yOffset: 30)
      Anchors.size.equalTo(width: 150, height: 150)
    }
    constraintLogo.sl.anchors {
      Anchors.trailing.equalTo(rightParenthesis.leadingAnchor)
      Anchors.centerY.equalTo("plus")
      Anchors.size.equalTo(width: 200, height: 150)
    }
    rightParenthesis.sl.anchors {
      Anchors.trailing.equalToSuper(constant: -16)
      Anchors.centerY
    }
  }
}
```

# Translation

- [Korean](README_ko.md)

# Requirements

**SwiftLayout 5.x** supports multiple Apple platforms:

| Platform | Minimum Version |
| -------- | --------------- |
| iOS      | 15.0+           |
| macOS    | 12.0+           |
| tvOS     | 15.0+           |
| visionOS | 1.0+            |

| Swift version  | SwiftLayout version                                          |
| -------------- | ------------------------------------------------------------ |
| **Swift 6.0+** | **5.x** (current)                                            |
| Swift 5.7      | [2.8.0](https://github.com/ioskrew/SwiftLayout/releases/tag/2.8.0) |
| Swift 5.5      | [2.7.0](https://github.com/ioskrew/SwiftLayout/releases/tag/2.7.0) |

> Note
> - For projects targeting iOS 13–14 or Swift 5.x, use the corresponding 2.x releases linked above.

# Installation

**SwiftLayout** only supports deployments via **SPM(Swift Package Manager)**.

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "5.0.0"),
],
```

# Features

- **Multi-platform support**: Works with UIKit (iOS, tvOS, visionOS) and AppKit (macOS)
- DSL features for `addSubview` and `removeFromSuperview`
- DSL features for `NSLayoutConstraint`, `NSLayoutAnchor` and activation
- Selective updates only when view states change
- Conditional and loop statements like `if else`, `switch case`, `for` in view hierarchy and autolayout constraints
- PropertyWrapper for automatically updating layout
- Various APIs for constraint relationships

# Usage

> [!WARNING]  
> With the update to **Swift6**, most of the interfaces in **SwiftLayout** are now explicitly marked to operate under the **@MainActor**.

## LayoutBuilder

`LayoutBuilder` is a DSL builder for setting up the UIView hierarchy; this allows subviews to be added to the parent view in a simple and visible way.

```swift
@LayoutBuilder var layout: some Layout {
  view.sl.sublayout {
    subview.sl.sublayout {
      subsubview
      subsub2view
    }
  }
}
```

this is like below:

```swift
view.addSubview(subview)
subview.addSubview(subsubview)
subview.addSubview(subsub2view)
```

## AnchorsBuilder

`AnchorsBuilder` is a DSL builder for `Anchors` types that aids in the creation of autolayout constraints between views.
It is mainly used within `anchors`, a method of Layout.

### Anchors

`Anchors` have attributes for NSLayoutConstraint and can creates.

> summary of NSLayoutConstraint
> 
> - first: Item1 and attribute1
> - second: item2 and attribute2
> - relation: relation(=, >=, <=), constant, multiplier

> equation of constraint has following format:
> Item1.attribute1 [= | >= | <= ] multiplier x item2.attribute2 + constant

> Detailed information about NSLayoutConstraint can be found [here](https://developer.apple.com/documentation/uikit/nslayoutconstraint).

- It starts by getting the required properties using static values ​​defined in Anchors.
  
  ```swift
  Anchors.top.bottom
  ```

- You can set up a second item (NSLayoutConstraint.secondItem, secondAttribute) through a relationship method such as equalTo.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.top.equalTo(superview, attribute: .top, constant: 10)
    }
  }
  ```
  
  this is same as following constraint format:
  
  ```
  selfview.top = superview.top + 10
  ```

- Attributes in Anchors that do not have a relation function in the child can be configured to match the parent item
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.top.bottom
    }
  }
  ```
  
  this can be expressed by the following expression:
  
  ```
  selfview.top = superview.top
  selfview.bottom = superview.bottom
  ...
  ```
  
  also, the multiplier can be set as follows.
  
  ```swift
  Anchors.top.multiplier(10)
  ```

- Width and height become the item itself if you do not set the second item.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.width.height.equalTo(constant: 10) // only for selfview
    }
  }
  ```
  
  this represents the following expression.
  
  ```
  selfview.width = 10
  selfview.height = 10
  ```

## LayoutBuilder + AnchorsBuilder

### *ah, finally*

`LayoutBuilder` and `AnchorsBuilder` can now be used together to add subviews, create autolayouts, and apply them to views.

- A `sublayout` method is required to add subviews after invoking an `anchors` method.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.allSides
      }.sublayout {
        subview.sl.anchors {
          Anchors.allSides
        }
      }
    } 
  }
  ```

- Is your hierarchy too complex? Just separates it.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.allSides
      }
    }
    selfview.sl.sublayout {
      subview.sl.anchors {
        Anchors.allSides
      }
    }
  }
  ```

### active and finalActive

The `Layout` types created with `LayoutBuilder` and `AnchorsBuilder` only contain information to actually work.  
For the application of addSubview and constraint, the method below must be called:

- you can call `finalActive` of `Layout` for instantly do all stuff in case of no needs to updates.

- `finalActive` return nothing after addSubview and active constraints instantly.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.top
      }
    }
  }
  
  init() {
    layout().finalActive()
  }
  ```

- you can call `active` of `Layout` if needs using some features for updates.  
  Returns `Activation`, an object containing information needed for update.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        if someCondition {
          Anchors.bottom
        } else {
          Anchors.top
        }
      }
    }
  }
  
  var activation: Activation
  
  init() {
    activation = layout().active()
  }
  
  func someUpdate() {
    activation = layout().update(fromActivation: activation)
  }
  ```

### Layoutable

In **SwiftLayout**, `Layoutable` plays a role similar to that of `View` in **SwiftUI**.

For implementing `Layoutable`, you needs be write following codes

- `var activation: Activation?`

- `@LayoutBuilder var layout: some Layout { ... }`: @LayoutBuilder may not required.
  
  ```swift
  class SomeView: UIView, Layoutable {
    var activation: Activation?
    @LayoutBuilder var layout: some Layout {
      self.sl.sublayout {
        ...
      }
    }
  
    init(frame: CGRect) {
      super.init(frame: frame)
      self.sl.updateLayout() // call active or update of Layout
    }
  }
  ```

### LayoutProperty

Builders of SwiftLayout is DSL languages, so you can perform if, switch case, for etc.

However, in order to reflect the state change in the layout of the view, you must directly call the `updateLayout` method of the `sl` property provided by `Layoutable` when necessary.

```swift
var showMiddleName: Bool = false {
  didSet {
    self.sl.updateLayout()
  }
}

var layout: some Layout {
  self.sl.sublayout {
    firstNameLabel
    if showMiddleName {
      middleNameLabel
    }
    lastNameLabel
  }
}
```

If `showMiddleName` is false, `middleNameLabel` is not added to the super view, and if it is already added, it is removed from the super view.

In this case, you can update automatically by using `LayoutProperty`:

```swift
@LayoutProperty var showMiddleName: Bool = false // change value call updateLayout of Layoutable

var layout: some Layout {
  self.sl.sublayout {
    firstNameLabel
    if showMiddleName {
      middleNameLabel
    }
    lastNameLabel
  }
}
```

### Animations

You can animate constraint changes in `Layoutable` by calling `updateLayout` with `forceLayout: true` inside a `UIView.animate` block:

```swift
final class AnimatedView: UIView, Layoutable {
  var activation: Activation?
  var isExpanded = false {
    didSet {
      UIView.animate(withDuration: 0.3) {
        self.sl.updateLayout(forceLayout: true)
      }
    }
  }
  // or use the convenient property wrapper:
  // @AnimatableLayoutProperty(duration: 0.3) var isExpanded = false

  let contentView = UIView()

  var layout: some Layout {
    self.sl.sublayout {
      contentView.sl.anchors {
        Anchors.top.horizontal.equalToSuper()
        Anchors.height.equalTo(constant: isExpanded ? 200 : 50)
      }
    }
  }
}
```

## Other useful features

### `onActivate(_:)` of UIView

You can use the onActivate function in a layout to decorate and modify the view. 
The closure passed to the onActivate function is called during the activation process.

```swift
contentView.sl.sublayout {
  nameLabel.sl.onActivate { label in 
    label.text = "Hello"
    label.textColor = .black
  }.anchors {
    Anchors.allSides
  }
}
```

### `identifying` of `UIView` and `Layout`

You can set `accessibilityIdentifier` and use that instead of the view reference.

```swift
contentView.sl.sublayout {
  nameLabel.sl.identifying("name").anchors {
    Anchors.cap
  }
  ageLabel.sl.anchors {
    Anchors.top.equalTo("name", attribute: .bottom)
    Anchors.shoe
  }
}
```

- from a debugging point, if you set identifier, the corresponding string is output together in the description of NSLayoutConstraint.

### Updating Constraints Dynamically

You can tag constraints with an identifier and update their `constant` or `priority` at runtime using `ConstraintUpdater`.

```swift
class MyView: UIView, Layoutable {
  var activation: Activation?

  var layout: some Layout {
    self.sl.sublayout {
      headerView.sl.anchors {
        Anchors.top.equalToSuper(constant: 20).identifier("headerTop")
        Anchors.horizontal.equalToSuper()
        Anchors.height.equalTo(constant: 100).identifier("headerHeight")
      }
    }
  }

  func expandHeader() {
    // Update a single constraint
    activation?.anchors("headerHeight").update(constant: 200)

    // Update with priority
    activation?.anchors("headerTop").update(constant: 0, priority: .required)
  }
}
```

You can also filter constraints by attribute when multiple constraints share the same identifier:

```swift
// Update only the width constraint among "size" identified constraints
activation?.anchors("size", attribute: .width).update(constant: 300)

// Or use a custom predicate
activation?.anchors("insets", predicate: { $0.constant > 0 }).update(constant: 20)
```

### Working with `UIVisualEffectView`

SwiftLayout automatically handles `UIVisualEffectView` by adding subviews to its `contentView`:

```swift
@LayoutBuilder var layout: some Layout {
  self.sl.sublayout {
    blurView.sl.sublayout {  // UIVisualEffectView
      // These views are automatically added to blurView.contentView
      titleLabel.sl.anchors {
        Anchors.center.equalToSuper()
      }
      iconView.sl.anchors {
        Anchors.bottom.equalTo(titleLabel, attribute: .top, constant: -10)
        Anchors.centerX.equalToSuper()
      }
    }
  }
}
```

Layout guides are also supported inside `UIVisualEffectView`:

```swift
blurView.sl.sublayout {
  UILayoutGuide().sl.identifying("contentGuide").sl.anchors {
    Anchors.allSides.equalToSuper(constant: 20)
  }
  label.sl.anchors {
    Anchors.center.equalTo("contentGuide")
  }
}
```

### Working with `UILayoutGuide`

SwiftLayout provides full support for `UILayoutGuide` with the same syntax as UIView, making it easy to create flexible layouts without adding extra views to the hierarchy.

```swift
@LayoutBuilder var layout: some Layout {
  containerView.sl.sublayout {
    // Create and configure a layout guide
    UILayoutGuide().sl.identifying("centerGuide").sl.anchors {
      Anchors.centerX.centerY.equalToSuper()
      Anchors.width.height.equalTo(constant: 200)
    }
    
    // Position views relative to the layout guide
    titleLabel.sl.anchors {
      Anchors.centerX.equalTo("centerGuide")
      Anchors.bottom.equalTo("centerGuide", attribute: .top, constant: -10)
    }
    
    imageView.sl.anchors {
      Anchors.center.equalTo("centerGuide")
      Anchors.size.equalTo(width: 100, height: 100)
    }
    
    descriptionLabel.sl.anchors {
      Anchors.centerX.equalTo("centerGuide")
      Anchors.top.equalTo("centerGuide", attribute: .bottom, constant: 10)
    }
  }
}
```

### Using in `SwiftUI`

Implement `Layoutable` on your view or view controller to easily use it in SwiftUI.

**iOS/tvOS/visionOS (UIKit)**:
```swift
class MyUIView: UIView, Layoutable {
  var activation: Activation?
  var layout: some Layout {
    self.sl.sublayout { ... }
  }
}

struct ContentView: View {
  var body: some View {
    MyUIView().sl.swiftUI
  }
}
```

**macOS (AppKit)**:
```swift
class MyNSView: NSView, Layoutable {
  var activation: Activation?
  var layout: some Layout {
    self.sl.sublayout { ... }
  }
}

struct ContentView: View {
  var body: some View {
    MyNSView().sl.swiftUI
  }
}
```

# Credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([@gmlwhdtjd](https://github.com/gmlwhdtjd))
- della-padula([@della-padula](https://github.com/della-padula))
