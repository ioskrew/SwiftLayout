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

- updateLayout(animated: true) calling frame animations
- in addition to - using **setAnimationHandler** for animation of each views

```swift
final class SampleView: UIView, LayoutBuilding {
    enum Show {
        case showYellow
        case showBlack
        case showAll
    }
    var deactivable: Deactivable?
    lazy var yellow = UIView()
    lazy var black = UIView()
    var show: Show = .showAll {
        didSet {
            updateLayout(animated: true) // call animations
        }
    }
    
    var layout: some Layout {
        self {
            switch show {
            case .showYellow:
                yellow.anchors {
                    Anchors.allSides()
                }
                black.setAnimationHandler({ view in
                    view.alpha = 0.0 // animation for black view in update layout
                }).anchors {
                    Anchors(.height).equalTo(constant: 0.0)
                    Anchors.shoe()
                }
            case .showBlack:
                yellow.setAnimationHandler({ view in
                    view.alpha = 0.0
                }).anchors {
                    Anchors(.height).equalTo(constant: 0.0)
                    Anchors.cap()
                }
                black.anchors {
                    Anchors.allSides()
                }
            case .showAll:
                yellow.setAnimationHandler({ view in
                    view.alpha = 1.0
                }).anchors {
                    Anchors.cap()
                    Anchors(.bottom).equalTo(black, attribute: .top)
                    Anchors(.height).equalTo(black)
                }
                black.setAnimationHandler({ view in
                    view.alpha = 1.0
                }).anchors {
                    Anchors.shoe()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func initViews() {
        yellow.backgroundColor = .yellow
        black.backgroundColor = .darkGray
        updateLayout(.automaticIdentifierAssignment)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggle)))
    }
    
    @objc
    func toggle() {
        switch show {
        case .showYellow:
            self.show = .showAll
        case .showBlack:
            self.show = .showAll
        case .showAll:
            self.show = Bool.random() ? .showYellow : .showBlack
        }
    }
    
}
```

[![animation in update layout](https://user-images.githubusercontent.com/3011832/155874823-e71cb9fb-8573-4241-9d30-d0bf28c0445a.png)](https://user-images.githubusercontent.com/3011832/155874757-f8ff8074-1f47-4c77-9f2a-d62358603457.mp4)

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
