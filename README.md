<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)

# requirements

- iOS 13+
- Swift 5.4+

# installation

**SwiftLayout** supply **SPM** only

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "1.7.0"),
],
```

# simple usage

- for pure **UIKit**

```swift
class SampleCell: UITableViewCell {
    
    let firstNameLabel: UILabel = .init()
    let lastNameLabel: UILabel = .init()
    
    func initViews() {
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor),
            lastNameLabel.trailingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor),
            lastNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            lastNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

```

- in **SwiftLayout**

```swift
contentView {
  firstNameLabel.anchors {
    Anchors(.top, .leading, .bottom)
  }
  lastNameLabel.anchors {
    Anchors(.leading, .trailing).equalTo(firstNameLabel, attribute: .trailing)
    Anchors(.top, .bottom)
  }
}.finalActive()
```

*That easy* (thanx bob)

# details

### addSubview

```swift
contentView {
  firstNameLabel
}
```

equal

```swift
contentView.addSubview(firstNameLabel)
```

- contentView is superview
- firstNameLabel in parenthesis is subview

### addSubview one more

```swift
contentView {
  firstNameLabel
  lastNameLabel
  ...
}
```

- subviews in parenthesis currently max to 7 is possible

### autolayout constraint to superview

```swift
contentView {
  firstNameLabel.anchors {
    Anchors(.top)
    // or
    Anchors(.top).equalTo(contentView, attribute: .top, constant: 0.0)
  }
}
```

in UIKit

```swift
NSLayoutConstraint(item: firstNameLabel,
                   attribute: NSLayoutConstraint.Attribute.top,
                   relatedBy: .equal,
                   toItem: contentView,
                   attribute: .top,
                   multiplier: 1.0,
                   constant: 0.0)
```

### subview in subview and anchors

```swift
contentView {
  firstNameContent.anchors {
    Anchors.cap() // leading, top, trailing equal to contentView
  }.sublayout {
    firstNameLabel.anchors {
      Anchors.allSides()
    }
  }
}
```

- using **sublayout** function after **anchors**

### animations

- with UIView animation feature

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
    
    var deactivable: Deactivable?
    
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

# utility

**SwiftLayoutPrinter**

- printing UIView hierarchy and autolayout constraint relationship to SwiftLayout syntax

```swift
contentView.addSubview(firstNameLabel)
```

- You can use SwiftLayoutPrinter in source or debug console

```swift
(lldb) po SwiftLayoutPrinter(contentView)
...
contentView {
  firstNameLabel
}
...
```

*That easy*

# credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([gmlwhdtjd](https://github.com/gmlwhdtjd))
