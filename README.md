<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit**

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
      Anchors.size(width: 200, height: 200)
    }
    UIImageView().sl.identifying("plus").sl.config { imageView in
      imageView.image = UIImage(systemName: "plus")
      imageView.tintColor = .SLColor
    }.sl.anchors {
      Anchors.center(offsetY: 30)
      Anchors.size(width: 150, height: 150)
    }
    constraintLogo.sl.anchors {
      Anchors.trailing.equalTo(rightParenthesis.leadingAnchor)
      Anchors.centerY.equalTo("plus")
      Anchors.size(width: 200, height: 150)
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

- iOS 13+

  | Swift version  | SwiftLayout version                                          |
  | -------------- | ------------------------------------------------------------ |
  | **Swift 5.7+** | **2.8.0**                                                    |
  | Swift 5.5      | [2.7.0](https://github.com/ioskrew/SwiftLayout/releases/tag/2.7.0) |
  | Swift 5.4      | [2.5.4](https://github.com/ioskrew/SwiftLayout/releases/tag/2.5.4) |

# Installation

**SwiftLayout** only supports deployments via **SPM(Swift Package Manager)**.

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "2.8.0"),
],
```

# Features

- DSL features for `addSubview` and `removeFromSuperview`
- DSL features for `NSLayoutConstraint`, `NSLayoutAnchor` and activation
- can updates only required in view states.
- using conditional and loop statements like `if else`, `swift case`, `for` in view hierarhcy and autolayout constraints.
- offer propertyWrapper for automatically updating of layout
- offering varierty features for relations of constraints.

# Usage

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
      Anchors.sl.top.bottom
    }
  }
  ```
  
  this can be expressed by the following expression:
  
  ```
  selfview.top = superview.top
  selfview.bottom = superview.bottom
  ...
  ```
  
  also, the constraint and multiplier can be set as follows.
  
  ```swift
  Anchors.top.constant(10)
  Anchors.top.multiplier(10)
  ```

- Width and height become the item itself if you do not set the second item.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.width.height.equalToSuper(constant: 10) // only for selfview
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
        Anchors.allSides()
      }.sublayout {
        subview.anchors {
          Anchors.allSides()
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
        Anchors.allSides()
      }
    }
    selfview.sl.sublayout {
      subview.sl.anchors {
        Anchors.allSides()
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
@LayoutProeprty var showMiddleName: Bool = false // change value call updateLayout of Layoutable

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

You can start animation by updating constraint in `Layoutable`, And the method is as easy as the following

- in the animation block of `UIView`, call `updateLayout` with `forceLayout` parameter set to true.

```swift
final class PreviewView: UIView, Layoutable {
  var capTop = true {
    didSet {
      // start animation for change constraints
      UIView.animate(withDuration: 1.0) {
        self.sl.updateLayout(forceLayout: true)
      }
    }
  }
  // or just use the convenient propertyWrapper like below
  // @AnimatableLayoutProperty(duration: 1.0) var capTop = true

  let cap = UIButton()
  let shoe = UIButton()
  let title = UILabel()

  var top: UIButton { capTop ? cap : shoe }
  var bottom: UIButton { capTop ? shoe : cap }

  var activation: Activation?

  var layout: some Layout {
    self.sl.sublayout {
      top.sl.anchors {
        Anchors.cap()
      }
      bottom.sl.anchors {
        Anchors.top.equalTo(top.bottomAnchor)
        Anchors.height.equalTo(top)
        Anchors.shoe()
      }
      title.sl.config { label in
        label.text = "Top Title"
        UIView.transition(with: label, duration: 1.0, options: [.beginFromCurrentState, .transitionCrossDissolve]) {
          label.textColor = self.capTop ? .black : .yellow
        }
      }.sl.anchors {
        Anchors.center(top)
      }
      UILabel().sl.config { label in
        label.text = "Bottom Title"
        label.textColor = capTop ? .yellow : .black
      }.sl.identifying("title.bottom").sl.anchors {
        Anchors.center(bottom)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initViews()
  }

  func initViews() {
    cap.backgroundColor = .yellow
    shoe.backgroundColor = .black
    cap.addAction(.init(handler: { [weak self] _ in
      self?.capTop.toggle()
    }), for: .touchUpInside)
    shoe.addAction(.init(handler: { [weak self] _ in
      self?.capTop.toggle()
    }), for: .touchUpInside)
    self.accessibilityIdentifier = "root"
    updateIdentifiers(rootObject: self)
    self.sl.updateLayout()
  }
}
```

[![animation in update layout](https://user-images.githubusercontent.com/3011832/189062670-93b3bcef-fdea-458b-b18f-f37cce1ec8ee.png)](https://user-images.githubusercontent.com/3011832/189063286-f106ae90-fea1-464a-a798-3586109dac2f.mp4)

## Other useful features

### `config(_:)` of UIView

You can decorate view in Layout with config function (*and using outside freely*)

```swift
contentView.sublayout {
  nameLabel.sl.config { label in 
    label.text = "Hello"
    label.textColor = .black
  }.sl.anchors {
    Anchors.allSides()
  }
}
```

### `identifying` of `UIView` and `Layout`

You can set `accessibilityIdentifier` and use that instead of the view reference.

```swift
contentView.sl.sublayout {
  nameLabel.sl.identifying("name").sl.anchors {
    Anchors.cap()
  }
  ageLabel.sl.anchors {
    Anchors.top.equalTo("name", attribute: .bottom)
    Anchors.shoe()
  }
}
```

- from a debugging point, if you set identifier, the corresponding string is output together in the description of NSLayoutConstraint.

### Using in `SwiftUI`

implement `Layoutable` on `UIView` or `UIViewController` you can easily using it in `SwiftUI`.

```swift
class ViewUIView: UIView, Layoutable {
  var layout: some Layout { 
    ...
  }
}

...

struct SomeView: View {
  var body: some View {
    VStack {
      ...
	    ViewUIView().sl.swiftUI
      ...
    }
  }
}

struct ViewUIView_Previews: PreviewProvider {
  static var previews: some Previews {
    ViewUIView().sl.swiftUI
  }
}
```



### SwiftLayoutUtil

#### LayoutPrinter

This can be useful when you want to make sure the current layout is configured the way you want it to.

- prints the tree created by the hierarchy of layouts and anchors.
  
  ```swift
  var layout: some Layout {
    root.sl.sublayout {
      child.sl.anchors {
        Anchors.top
        Anchors.leading.trailing
      }
      friend.sl.anchors {
        Anchors.top.equalTo(child, attribute: .bottom)
        Anchors.bottom
        Anchors.leading.trailing
      }
    }
  }
  ```

- you can use LayoutPrinter in source or debug console.
  
  > (lldb)  po import SwiftLayoutUtil; LayoutPrinter(layout).print()
  
  ```
  ViewLayout - view: root
  └─ TupleLayout
     ├─ ViewLayout - view: child
     └─ ViewLayout - view: friend
  ```

- if necessary, you can also print Anchors applied to the layout.
  
  > (lldb)  po import SwiftLayoutUtil; LayoutPrinter(layout, withAnchors: true).print()
  
  ```
  ViewLayout - view: root
  └─ TupleLayout
     ├─ ViewLayout - view: child
     │        .top == superview.top
     │        .leading == superview.leading
     │        .trailing == superview.trailing
     └─ ViewLayout - view: friend
              .top == child.bottom
              .bottom == superview.bottom
              .leading == superview.leading
              .trailing == superview.trailing
  ```

#### ViewPrinter

This can be useful when you want to migrate your current view to SwiftLayout for several reasons.

- printing UIView hierarchy and autolayout constraint relationship to SwiftLayout syntax
  
  ```swift
  let contentView: UIView
  let firstNameLabel: UILabel
  contentView.addSubview(firstNameLabel)
  ```

- you can use ViewPrinter in source or debug console.
  
  > (lldb) po import SwiftLayoutUtil; ViewPrinter(contentView).print()
  
  ```swift
  // If there is no separate identification setting, the view is displayed in the form of addressValue:View type.
  0x01234567890:UIView {
    0x01234567891:UILabel
  }
  ```

- printing labels for view by name of view property is very convenient.
  
  ```swift
  class SomeView {
    let root: UIView // subview of SomeView
    let child: UIView // subview of root
    let friend: UIView // subview of root
  }
  let someView = SomeView()
  ```
  
  > (lldb) po import SwiftLayoutUtil; ViewPrinter(someView, tags: [someView: "SomeView"]).updateIdentifiers().print()
  
  ```swift
  SomeView {
    root.sl.sublayout {
      child.sl.anchors {
        Anchors.top
        Anchors.leading.trailing
      }
      friend.sl.anchors {
        Anchors.top.equalTo(child, attribute: .bottom)
        Anchors.bottom
        Anchors.leading.trailing
      }
    }
  }
  ```

# Credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([@gmlwhdtjd](https://github.com/gmlwhdtjd))
- della-padula([@della-padula](https://github.com/della-padula))
