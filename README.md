<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)



```swift
@LayoutBuilder var layout: some Layout {
  contentView {
    firstNameLabel.anchors {
      Anchors(.leading)
      Anchors.vertical()
    }
    if showMiddleName {
      middleNameLabel.anchors {
        Anchors(.leading).equalTo(firstNameLabel, attribute: .trailing)
				Anchors.veritcal()
      }
    }
    secondNameLabel.anchors {
      if showMiddleName {
        Anchors(.leading).equalTo(middleNameLabel.trailingAnchor)
      } else {
        Anchors(.leading).equalTo(firstNameLabel.trailingAnchor)
      }
      Anchors.vertical()
    }
  }
}
```

<img src="https://user-images.githubusercontent.com/3011832/157275626-c5f5672f-0a4a-4f45-8800-5ea3871c9dac.png" alt="thateasy" style="zoom:25%;" />

# requirements

- iOS 13+
- Swift 5.4+

# installation

**SwiftLayout** supply **SPM** only

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "2.0.0"),
],
```



# usages

## `LayoutBuilder`

**LayoutBuilder** is DSL builder for UIView hierarchy. it presents simple doing add subview to superview. 

```swift
@LayoutBuilder var layout: some Layout {
  view {
    subview {
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

## `AnchorsBuilder`

**AnchorsBuilder** is DSL builder of `Anchors` for making autolayout constraint between views or view itself. most are used within the `anchors` function of Layout.

### `Anchors`

 **Anchors** have attributes for NSLayoutConstraint and can creates.

> summary of NSLayoutConstraint
>
> - first: Item1 and attribute1
> - second: item2 and attribute2
> - relation: relation(=, >=, <=), constant, multiplier
>

equation of constraint has following format:
>Item1.attribute1 [= | >= | <= ] multiplier x item2.attribute2 + constant

you can read details [here](https://developer.apple.com/documentation/uikit/nslayoutconstraint).

- initializing with attributes for first part: variadic(or array) of `NSLayoutConstraint.Attribute`

  ```swift
  Anchors(.top, .bottom, ...)
  ```

- enable to set of second part(item, attribute) through relation functions

  ```swift
  superview {
    selfview.anchors {
  		Anchors(.top).equalTo(superview, attribute: .top, constant: 10)
    }
  }
  ```

  this is same as following constraint format:

  ```
  selfview.top = superview.top + 10
  ```

- second item of Anchors with no relation functions may be its superview

  ```swift
  superview {
    selfview.anchors {
      Anchors(.top, .bottom, ...)
    }
  }
  ```

  this is same as following format exactly:

  ```
  selfview.top = superview.top
  selfview.bottom = superview.bottom
  ...
  ```

  also, you can set extra constraint like this:

  ```swift
  Anchors(.top).setConstraint(10)
  ```

- attributes like width and height can be set for first item(view) self not second item.

  ```swift
  superview {
    selfview.anchors {
      Anchors(.width, .height).equalTo(constraint: 10) // only for selfview
    }
  }
  ```
  
  this same as:
  
  ```
  selfview.width = 10
  selfview.height = 10
  ```

### `LayoutBuilder` + `AnchorsBuilder`

*ah, finally*

now you can combine LayoutBuilder and AnchorsBuilder for add subview and make constraint between views, and make applying to view:

- add subview to selfview after `anchors` needs `sublayout`

  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview {
      selfview.anchors {
        Anchors.allSides()
      }.sublayout {
        subview.anchors {
          Anchors.allSides()
        }
      }
    } 
  }
  ```

- don't want sublayout? separates it.

  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview {
      selfview.anchors {
        Anchors.allSides()
      }
    }
    selfview {
      subview.anchors {
        Anchors.allSides()
      }
    }
  }
  ```

### `active` and `finalActive`

`LayoutBuilder`, `AnchorsBuilder` only contain contexts for actual works. so, for do addSubview and active constraints needs following works:

- you can call `finalActive` of `Layout` for instantly do all stuff in case of no needs to updates.
- `finalActive` return nothing
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview {
      selfview.anchors {
        Anchors(.top)
      }
    }
  }
  
  init() {
  	layout().finalActive()
  }
  ```
  
- you can call `active` of `Layout` if needs using some features for updates.

  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview {
      selfview.anchors {
        if someCondition {
          Anchors(.bottom)
        } else {
        	Anchors(.top)
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

### `Layoutable`

`Layoutable`  is holding position of `SwiftUI.View` in **SwiftLayout** in some viewpoint.

Implementing this protocol, you needs be write following codes:

- `var activation: Activation?`

- `@LayoutBuilder var layout: some Layout { ... }`: @LayoutBuilder may not required.

  ```swift
  class SomeView: UIView, Layoutable {
    var activation: Activation?
    @LayoutBuilder var layout: some Layout {
      self {
        ...
      }
    }
    
    init(frame: CGRect) {
      super.init(frame: frame)
      updateLayout() // call active or update of Layout
    }
  }
  ```

#### `LayoutProperty`

Builders of SwiftLayout is DSL languages, so you can perform if, switch case, for etc.

so, if some states of values affects to layout of view, you need to call `updateLayout` of `Layoutable` in right timing and position:

```swift
var showMiddleName: Bool = false {
  didSet {
    updateLayout()
  }
}

var layout: some Layout {
  self {
    firstNameLabel
    if showMiddleName {
      middleNameLabel
    }
    lastNameLabel
  }
}
```

- if **showMiddleName** is false, **middleNameLabel** is not added to superview or removed from superview.

- you can update automatically by using `LayoutProperty`:

  ```swift
  @LayoutProeprty var showMiddleName: Bool = false // change value call updateLayout of Layoutable
  
  var layout: some Layout {
    self {
      firstNameLabel
      if showMiddleName {
        middleNameLabel
      }
      lastNameLabel
    }
  }
  ```

### animations

you can start animation by updating constraint in `Layoutable`, And the method is as easy as the following:

- just call `updateLayout` in animation block of `UIView`

```swift
final class PreviewView: UIView, LayoutBuilding {
    
    var capTop = true {
        didSet {
          	// start animation for change constraints
            UIView.animate(withDuration: 1.0) {
                self.updateLayout()
            }
        }
    }
    
    let cap = UIButton()
    let shoe = UIButton()
    let title = UILabel()
    
    var top: UIButton { capTop ? cap : shoe }
    var bottom: UIButton { capTop ? shoe : cap }
    
    var activation: Activation?
    
    var layout: some Layout {
        self {
            top.anchors {
                Anchors.cap()
            }
            bottom.anchors {
                Anchors(.top).equalTo(top.bottomAnchor)
                Anchors(.height).equalTo(top)
                Anchors.shoe()
            }
            title.config { label in
                label.text = "Top Title"
                UIView.transition(with: label, duration: 1.0, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
                    label.textColor = self.capTop ? .black : .yellow
                }, completion: nil)
            }.anchors {
                Anchors(.centerX, .centerY).equalTo(top)
            }
            UILabel().config { label in
                label.text = "Bottom Title"
                label.textColor = capTop ? .yellow : .black
            }.identifying("title.bottom").anchors {
                Anchors(.centerX, .centerY).equalTo(bottom)
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
        updateLayout()
    }
    
}
```



[![animation in update layout](https://user-images.githubusercontent.com/3011832/156908073-d4089c26-928f-41d9-961b-8b04d7dcde37.png)](https://user-images.githubusercontent.com/3011832/156908065-8d6bcebd-553b-490b-903b-6e375d4c97a3.mp4)

### **SwiftLayoutPrinter**

for several reasons, you want current view state migration to SwiftLayout. 

- printing UIView hierarchy and autolayout constraint relationship to SwiftLayout syntax

  ```swift
  let contentView: UIView
  let firstNameLabel: UILabel
  contentView.addSubview(firstNameLabel)
  ```

- You can use SwiftLayoutPrinter in source or debug console:

  > (lldb) po SwiftLayoutPrinter(contentView)

  ```swift
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

  > po SwiftLayoutPrinter(someView, tags: [someView: "SomeView"]).print(.nameOnly)

  ```swift
  SomeView {
    root {
      child
      friend
    }
  }
  ```
  
  

<img src="https://user-images.githubusercontent.com/3011832/157275626-c5f5672f-0a4a-4f45-8800-5ea3871c9dac.png" alt="thateasy" style="zoom:25%;" />

# credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([gmlwhdtjd](https://github.com/gmlwhdtjd))
