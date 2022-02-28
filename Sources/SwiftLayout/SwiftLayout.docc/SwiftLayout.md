# ``SwiftLayout``

DSL library for unite UIView and AutoLayout constraints

## overview

SwiftLayout provides methods of handle UIView hierarchy and autolayout constraint in consistency DSL syntax.

```swift
superview {
    subview.anchors {
        Anchors(.top, .bottom, .leading, .trailing) // .equalTo(superview)
    }
}

// instead of

superview.addSubview(subview)
NSLayoutConstraint.activate([
    subview.topAnchor.constraint(equalTo: superview.topAnchor),
    subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
    subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
])
```

## topics

### GettingStarted
