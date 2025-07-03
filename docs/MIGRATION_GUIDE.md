# AutoLayout to SwiftLayout Migration Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Quick Start](#quick-start)
3. [Basic Migration Patterns](migration/basic-migration.md)
4. [Advanced Migration Patterns](migration/advanced-migration.md)
5. [Complex Hierarchies & Constraints](migration/complex-hierarchies.md)
6. [Real-world Examples](migration/real-world-examples.md)
7. [Best Practices](migration/best-practices.md)
8. [Troubleshooting](migration/troubleshooting.md)

## Introduction

This guide provides practical examples and patterns for migrating from traditional AutoLayout code to SwiftLayout DSL. It focuses on real-world migration scenarios and common transformation patterns.

For comprehensive SwiftLayout documentation and basic usage, see the [README.md](../README.md).

### Migration Benefits

- **Reduced Code**: Transform verbose AutoLayout code into concise DSL expressions
- **Better Maintainability**: Declarative syntax makes layout intent clearer
- **Type Safety**: Catch constraint errors at compile time
- **Swift Integration**: Use Swift's control flow naturally in layouts
- **Easier Testing**: More predictable layout structure for unit tests

## Quick Start

### Installation
SwiftLayout is already included in your project. No additional setup required.

### Basic Migration Example

**AutoLayout:**
```swift
view.translatesAutoresizingMaskIntoConstraints = false
superview.addSubview(view)
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
    view.widthAnchor.constraint(equalToConstant: 200),
    view.heightAnchor.constraint(equalToConstant: 100)
])
```

**SwiftLayout DSL:**
```swift
@LayoutBuilder
var layout: some Layout {
    superview.sl.sublayout {
        view.sl.anchors {
            Anchors.top.equalToSuper(constant: 20)
            Anchors.leading.equalToSuper(constant: 16)
            Anchors.size.equalTo(width: 200, height: 100)
        }
    }
}
layout.finalActive()
```

### Key Migration Concepts

1. **Constraint Declaration**: From imperative NSLayoutConstraint to declarative Anchors
2. **View Hierarchy**: From addSubview() calls to @LayoutBuilder structure
3. **Activation**: From NSLayoutConstraint.activate() to SwiftLayout's activation system
4. **Updates**: From constraint property changes to SwiftLayout's update mechanism

## Next Steps

- **[Basic Migration Patterns](migration/basic-migration.md)**: Simple constraint conversions, view hierarchies, common layouts
- **[Advanced Migration Patterns](migration/advanced-migration.md)**: Dynamic layouts, conditional constraints, composition
- **[Complex Hierarchies & Constraints](migration/complex-hierarchies.md)**: Deep nesting, priority, multiplier usage
- **[Real-world Examples](migration/real-world-examples.md)**: Complete app component migrations
- **[Best Practices](migration/best-practices.md)**: Testing strategies, performance tips, migration process
- **[Troubleshooting](migration/troubleshooting.md)**: Common issues and solutions

For additional examples and test cases, refer to the [SwiftLayout repository](https://github.com/ioskrew/SwiftLayout).