# Basic Migration Patterns

This document covers fundamental patterns for migrating from AutoLayout to SwiftLayout DSL.

## Table of Contents
1. [Simple Constraint Conversion](#simple-constraint-conversion)
2. [View Hierarchy Setup](#view-hierarchy-setup)
3. [Common Layout Patterns](#common-layout-patterns)
4. [Anchor Combinations](#anchor-combinations)

## Simple Constraint Conversion

### Single View Constraints

**AutoLayout:**
```swift
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
    view.widthAnchor.constraint(equalToConstant: 200),
    view.heightAnchor.constraint(equalToConstant: 100)
])
```

**SwiftLayout DSL:**
```swift
view.sl.anchors {
    Anchors.top.equalToSuper(constant: 20)
    Anchors.leading.equalToSuper(constant: 16)
    Anchors.size.equalTo(width: 200, height: 100)
}
```

## View Hierarchy Setup

### Basic Hierarchy

**AutoLayout:**
```swift
parentView.addSubview(containerView)
containerView.addSubview(titleLabel)
containerView.addSubview(subtitleLabel)
containerView.addSubview(imageView)
```

**SwiftLayout DSL:**
```swift
@LayoutBuilder
var layout: some Layout {
    parentView.sl.sublayout {
        containerView.sl.sublayout {
            titleLabel
            subtitleLabel
            imageView
        }
    }
}
```

### Constraint Activation

**AutoLayout:**
```swift
let constraints = [
    view.widthAnchor.constraint(equalToConstant: 100),
    view.heightAnchor.constraint(equalToConstant: 100)
]
NSLayoutConstraint.activate(constraints)
```

**SwiftLayout DSL:**
```swift
// One-time activation
layout.finalActive()

// Or with update capability
var activation: Activation?
activation = layout.active()

// Later updates
activation = layout.update(fromActivation: activation)
```

## Common Layout Patterns

### 1. Centering Views

**AutoLayout:**
```swift
NSLayoutConstraint.activate([
    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
    view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
    view.widthAnchor.constraint(equalToConstant: 100),
    view.heightAnchor.constraint(equalToConstant: 100)
])
```

**SwiftLayout DSL:**
```swift
view.sl.anchors {
    Anchors.center.equalToSuper()
    Anchors.size.equalTo(width: 100, height: 100)
}
```

### 2. Full-Width/Height Layouts

**AutoLayout:**
```swift
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor),
    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
])
```

**SwiftLayout DSL:**
```swift
view.sl.anchors {
    Anchors.allSides.equalToSuper()
}
```

### 3. Margins and Safe Area

**AutoLayout:**
```swift
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
    view.trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor)
])
```

**SwiftLayout DSL:**
```swift
view.sl.anchors {
    Anchors.top.equalTo(superview.safeAreaLayoutGuide, constant: 20)
    Anchors.leading.equalTo(superview.layoutMarginsGuide)
    Anchors.trailing.equalTo(superview.layoutMarginsGuide)
}
```

### 4. Relative Positioning

**AutoLayout:**
```swift
NSLayoutConstraint.activate([
    secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 10),
    secondView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
    secondView.widthAnchor.constraint(equalTo: firstView.widthAnchor)
])
```

**SwiftLayout DSL:**
```swift
secondView.sl.anchors {
    Anchors.top.equalTo(firstView, attribute: .bottom, constant: 10)
    Anchors.leading.equalTo(firstView)
    Anchors.width.equalTo(firstView)
}
```

## Anchor Combinations

SwiftLayout provides convenient anchor combinations for common patterns:

### Available Anchor Combinations

- `Anchors.allSides`: top, bottom, leading, trailing
- `Anchors.horizontal`: leading, trailing
- `Anchors.vertical`: top, bottom
- `Anchors.center`: centerX, centerY
- `Anchors.size`: width, height
- `Anchors.cap`: top, leading, trailing (header-like layout)
- `Anchors.shoe`: bottom, leading, trailing (footer-like layout)

### Usage Example

```swift
// Header view
headerView.sl.anchors {
    Anchors.cap.equalToSuper()
    Anchors.height.equalTo(constant: 60)
}

// Content view
contentView.sl.anchors {
    Anchors.top.equalTo(headerView, attribute: .bottom)
    Anchors.horizontal.equalToSuper()
    Anchors.bottom.equalTo(footerView, attribute: .top)
}

// Footer view
footerView.sl.anchors {
    Anchors.shoe.equalToSuper()
    Anchors.height.equalTo(constant: 50)
}
```

## Summary

These basic patterns form the foundation for migrating AutoLayout code to SwiftLayout. The key benefits are:

1. **Cleaner Syntax**: Less boilerplate code
2. **Better Organization**: Clear separation of hierarchy and constraints
3. **Type Safety**: Compile-time constraint validation
4. **Convenience Methods**: Built-in anchor combinations for common patterns

For more complex scenarios, see [Advanced Migration Patterns](advanced-migration.md).