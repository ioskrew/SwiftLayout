<img src="https://user-images.githubusercontent.com/3011832/153903060-9049ebc5-4a6f-4050-98f0-1ebdd3c97da8.svg" alt="SwiftLayout Logo" height="70" />

# SwiftLayout

DSL library that implements hierarchy of views and constraints declaratively

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)



## overview

- no more needs using add subview
- no more directly create NSLayoutConstraint or using NSLayoutAnchor
  - *alright, sometimes may be you needs that. ok. you can use it in Layout*
- relation between view become blackboxing, enable to structured by conditions, always views and constraints be coupled, not separated.

## requirements

- iOS 13+
- Swift 5.4+

## installation

**SwiftLayout** supply **SPM** only

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "1.1.0"),
],
```

## usage

### superview and subviews

DSL by @resultBuilder make easy allow relation of superview and subviews and autolayout constraints declaratively.

```swift
let root: UIView
let red: UIView
let blue: UIView

// root.addSubview(red)
root {
  red
}

// root.addSubview(red)
// root.addSubview(blue)
root {
  red
  blue
}

// root.addSubview(red)
// red.addSubview(blue)
root {
  red {
    blue
  }
}
```

### constraints

**Anchors** is declarative model of relation of constraints.

- hiding attributes, is treated as having same attribute between two views. 
- if only use **Anchors(...)**, that will make constraints with superview to second items.

```swift
let root: UIView
let red: UIView

root {
  red.anchors {
    // top, leading, trailing, bottom of red constraint attributes is equal to superview(root)
    // 4 constraints of red firstItem and root secondItem are made by below codes.
    Anchors(.top, .leading, .trailing, .bottom)
    // or more specifically
    Anchors(.top, .leading, .trailing, .bottom).equalTo(root)
    // or individually
    Anchors(.top) // Anchors(.top).equalTo(root) or Anchors(.top).equalTo(root, attribute: .top)
    Anchors(.leading) // Anchors(.top).equalTo(root)
    Anchors(.traliling) // Anchors(.top).equalTo(root)
    Anchors(.equal) // Anchors(.top).equalTo(root)
  }
}
```

also you can make custom **Anchors** property

```swift
let root: UIView
let red: UIView

extension Anchors {
  static var boundary: Anchors { .init(.top, .leading, .trailing, .bottom) }
}

root {
  red.anchors {
    Anchors.boundary // top and leading and trailing and bottom constraints of red has equal relation to same attributes of root view.
  }
}

// or be able root view to red view relations like below

root.anchors {
  Anchors.boundary.equalTo(red)
}.subviews { // subviews should be in LayoutBuilder in subviews function after anchors.
  red
}

// two DSL declaration bring same result.
```

do you want red is up blue is down and same height? 

good you can write like this.

```swift
let root: UIView
let red: UIView
let blue: UIView
root {
  red.anchors {
    Anchors(.top, .leading, .trailing)
  }
  blue.anchors {
    Anchors(.leading, .trailing, .bottom)
    Anchors(.top).equalTo(red, attribute: .bottom)
    Anchors(.height).equalTo(red) // or Anchors(.height).equalTo(red, attribute: .height)
  }
}
```

### view identifier

Sometimes for a few reasons, you want the object may want to create a view directly, without containing the property of the view. 

in this case, **Anchors** cannot have constraint with variable name. so you can allow string label to view.

```swift
root {
  RedLabel().identifiying("red").anchors {
    Anchors.cap
  }
  blue.anchors {
    Anchors.shoe
    Anchors(.top).equalTo("red", attribute: .bottom)
    Anchors(.height).equalTo("red")
  }
}
```

you can also get view from **Deactivable**.

```swift
let deactivable = root {
  UILabel().identifying("red")
}.active()

let label = deactivable.viewForIdentifier("red") as? UILabel
```

### updating

layouts can use conditional blocks.

```swift
let showRed = true
root {
  if showRed {
    red
  } else {
    blue
  }
}
```

### finally

```swift
root {
  red.anchors {
    Anchors.boundary
  }
}
```

in this time, DSL declaration is just structure of views and constraints. none of this added to superview or active of constraints.

you must call **active()** function for complete all this. and result of Deactivable should has retained.

```swift
final class ViewController: UIViewController {

  let red = UIView()

  var deactivable: Deactivable?

  override func viewDidLoad() {
    super.viewDidLoad()
    deactivable = view { // view is that of ViewController
      red.anchors {
        Anchors.boundary // boundary is custom property in samples.
      }     
    }.active()
  }
}
```

release deactivable or call of deactivate?.deactive() make release all subviews and constraints.

protocol **LayoutBuilding** make easy to updating.

```swift
final class ViewController: UIViewController, LayoutBuilding {

  var showRed: Bool = true
  let red: UIView
  let blue: UIView


  var deactivable: Deactivable?

  var layout: some Layout {
    view {
      if showRed {
        red
      } else {
        blue
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateLayout() // updateLayout is procedure for active and call some apis
    // or you can animation by below
    updateLayout(animated: true)
  }
}
```

- call animationDisable() make that blocks to escape from animations.
  
  ```swift
  root {
    red.anchors {
      Anchors.boundary
    }.animationDisable()
  }
  ```

## preview

**SwiftLayout** also providing an simple solution for preview of **SwiftUI**.

If your view or view controller implement protocol of **LayoutBuilding**. you write like below.

```swift
class ViewController: UIViewController, LayoutBuilding {...}

extension View[Controller]: LayoutView[Controller]Representable {} // more than this is not required.

struct ViewController_Previews: PreviewProvider {
  static var previews: some View {
    ViewController() // and enable preview features like previewDevice
  }
}
```

### more features

- greater than or equal, less than or equal
- UILayoutGuide also possible assign to item

```swift
root {
  red.anchors {
    Anchors.boundary.eqaulTo(root.safeAreaLayoutGuide)
  }
}
```
