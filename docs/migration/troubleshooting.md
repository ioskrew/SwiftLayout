# Troubleshooting

This document provides solutions to common issues encountered when migrating to or using SwiftLayout.

## Table of Contents
1. [Layout Not Updating](#layout-not-updating)
2. [Constraint Conflicts](#constraint-conflicts)
3. [Performance Issues](#performance-issues)
4. [View Hierarchy Problems](#view-hierarchy-problems)
5. [Memory Issues](#memory-issues)
6. [Debugging Tools](#debugging-tools)

## Layout Not Updating

### Problem: Layout doesn't update when properties change

**Symptoms:**
- Views don't move when @LayoutProperty changes
- Manual layout updates don't take effect
- Views appear in wrong positions

**Solutions:**

1. **Check Layout Activation**
   ```swift
   // Wrong: Layout not activated
   override func viewDidLoad() {
       super.viewDidLoad()
       let _ = layout // Layout created but not active
   }
   
   // Correct: Activate the layout
   override func viewDidLoad() {
       super.viewDidLoad()
       sl.updateLayout() // Activates and manages layout
   }
   ```

2. **Verify @LayoutProperty Usage**
   ```swift
   // Wrong: Regular property doesn't trigger updates
   var isExpanded: Bool = false {
       didSet {
           // Manual update required
           sl.updateLayout()
       }
   }
   
   // Correct: @LayoutProperty automatically triggers updates
   @LayoutProperty var isExpanded: Bool = false
   ```

3. **Force Layout Update**
   ```swift
   func updateWithAnimation() {
       UIView.animate(withDuration: 0.3) {
           self.isExpanded = true
           self.sl.updateLayout(forceLayout: true)
       }
   }
   ```

### Problem: Views don't appear at all

**Solutions:**

1. **Check View Hierarchy**
   ```swift
   // Ensure parent view is properly added to hierarchy
   override func viewDidLoad() {
       super.viewDidLoad()
       view.addSubview(containerView) // Parent must be in hierarchy
       sl.updateLayout()
   }
   ```

2. **Verify Constraints**
   ```swift
   // Ensure views have sufficient constraints
   childView.sl.anchors {
       Anchors.center.equalToSuper()
       Anchors.size.equalTo(width: 100, height: 100) // Size required
   }
   ```

## Constraint Conflicts

### Problem: Console shows constraint conflict warnings

**Symptoms:**
- "Unable to simultaneously satisfy constraints" errors
- Views appear in unexpected sizes or positions
- Console spam with constraint warnings

**Solutions:**

1. **Use Priorities to Resolve Conflicts**
   ```swift
   view.sl.anchors {
       // Conflicting constraints with different priorities
       Anchors.width.equalTo(constant: 200)
           .priority(.defaultHigh)
       Anchors.width.lessThanOrEqualTo(constant: 150)
           .priority(.required)
   }
   ```

2. **Remove Redundant Constraints**
   ```swift
   // Wrong: Over-constraining
   view.sl.anchors {
       Anchors.width.equalTo(constant: 100)
       Anchors.width.equalTo(constant: 200) // Conflict!
   }
   
   // Correct: One constraint per attribute
   view.sl.anchors {
       Anchors.width.equalTo(constant: 100)
   }
   ```

3. **Use Inequality Constraints**
   ```swift
   // Allow flexibility with inequalities
   view.sl.anchors {
       Anchors.width.greaterThanOrEqualTo(constant: 100)
       Anchors.width.lessThanOrEqualTo(constant: 300)
       Anchors.width.equalTo(constant: 200)
           .priority(.defaultHigh)
   }
   ```

### Problem: Views with intrinsic content size issues

**Solutions:**

1. **Set Content Priorities**
   ```swift
   label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
   label.setContentCompressionResistancePriority(.required, for: .horizontal)
   
   label.sl.anchors {
       // Let intrinsic size work
       Anchors.leading.equalToSuper()
       Anchors.centerY.equalToSuper()
   }
   ```

## Performance Issues

### Problem: Slow layout updates or animation lag

**Symptoms:**
- Choppy animations
- Delayed layout updates
- High CPU usage during layout

**Solutions:**

1. **Batch Property Updates**
   ```swift
   // Wrong: Multiple individual updates
   func updateProperties() {
       property1 = value1
       property2 = value2
       property3 = value3
   }
   
   // Correct: Batch updates
   func updateProperties() {
       UIView.performWithoutAnimation {
           property1 = value1
           property2 = value2
           property3 = value3
       }
   }
   ```

2. **Use Appropriate Activation Method**
   ```swift
   // For static layouts
   override func viewDidLoad() {
       super.viewDidLoad()
       staticLayout.finalActive()
   }
   
   // For dynamic layouts
   override func viewDidLoad() {
       super.viewDidLoad()
       activation = dynamicLayout.active()
   }
   
   func updateLayout() {
       activation = dynamicLayout.update(fromActivation: activation)
   }
   ```

3. **Optimize Complex Layouts**
   ```swift
   // Cache expensive layout calculations
   class OptimizedView: UIView, Layoutable {
       private lazy var complexLayout: some Layout = {
           createComplexLayout()
       }()
       
       @LayoutBuilder
       var layout: some Layout {
           self.sl.sublayout {
               if shouldShowComplex {
                   complexLayout
               } else {
                   simpleLayout
               }
           }
       }
   }
   ```

## View Hierarchy Problems

### Problem: Views not appearing in sublayout

**Solutions:**

1. **Check Sublayout Structure**
   ```swift
   // Wrong: Missing sublayout
   view.sl.anchors {
       Anchors.allSides.equalToSuper()
   }
   childView.sl.anchors { ... } // Not in hierarchy!
   
   // Correct: Use sublayout
   view.sl.sublayout {
       childView.sl.anchors { ... }
   }
   ```

2. **Verify Parent-Child Relationships**
   ```swift
   @LayoutBuilder
   var layout: some Layout {
       parentView.sl.sublayout {
           // All children must be defined here
           child1.sl.anchors { ... }
           child2.sl.anchors { ... }
       }
   }
   ```

### Problem: Incorrect view ordering (z-index)

**Solutions:**

1. **Control View Order in Sublayout**
   ```swift
   container.sl.sublayout {
       backgroundView.sl.anchors { ... } // Added first (back)
       foregroundView.sl.anchors { ... } // Added last (front)
   }
   ```

2. **Use bringSubviewToFront if needed**
   ```swift
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       view.bringSubviewToFront(overlayView)
   }
   ```

## Memory Issues

### Problem: Memory leaks or retain cycles

**Symptoms:**
- Memory usage grows over time
- Views not deallocating
- Instruments shows retained objects

**Solutions:**

1. **Use Weak References in Closures**
   ```swift
   // Wrong: Strong reference cycle
   view.sl.onActivate { view in
       view.backgroundColor = self.backgroundColor
   }
   
   // Correct: Weak reference
   view.sl.onActivate { [weak self] view in
       view.backgroundColor = self?.backgroundColor
   }
   ```

2. **Properly Deactivate Layouts**
   ```swift
   class MyViewController: UIViewController, Layoutable {
       var activation: Activation?
       
       deinit {
           activation?.deactivate()
       }
   }
   ```

3. **Avoid Capturing Self Unnecessarily**
   ```swift
   // Consider if self is actually needed
   @LayoutBuilder
   var layout: some Layout {
       containerView.sl.sublayout {
           createStaticLayout() // No self reference needed
       }
   }
   ```

## Debugging Tools

### 1. Console Debugging

```swift
#if DEBUG
extension Layoutable where Self: UIView {
    func debugConstraints() {
        print("=== Constraint Debug ===")
        print("View: \(type(of: self))")
        
        if let activation = activation {
            for constraint in activation.constraints {
                print("Constraint: \(constraint)")
                print("Priority: \(constraint.priority)")
                print("Active: \(constraint.isActive)")
            }
        }
    }
}
#endif
```

### 2. Visual Debugging

```swift
#if DEBUG
extension UIView {
    func highlightBounds() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
        backgroundColor = UIColor.blue.withAlphaComponent(0.1)
    }
    
    func showConstraintDebugInfo() {
        // Add debug labels showing constraint info
    }
}
#endif
```

### 3. Runtime Inspection

```swift
#if DEBUG
func inspectLayoutState() {
    po(view.subviews)
    po(view.constraints)
    po(activation?.constraints)
}
#endif
```

### 4. Constraint Validation

```swift
#if DEBUG
func validateLayoutIntegrity() {
    guard let activation = activation else {
        print("⚠️ No activation found")
        return
    }
    
    let constraints = activation.constraints
    
    // Check for suspicious constraints
    for constraint in constraints {
        if constraint.priority.rawValue < 250 {
            print("⚠️ Very low priority constraint: \(constraint)")
        }
        
        if constraint.multiplier == 0 {
            print("⚠️ Zero multiplier constraint: \(constraint)")
        }
    }
}
#endif
```

## Common Error Messages

### "Layout not activated"
- **Cause**: Layout created but not activated
- **Solution**: Call `sl.updateLayout()` or `layout.finalActive()`

### "View not in hierarchy"
- **Cause**: Trying to layout view before adding to superview
- **Solution**: Ensure parent view is in view hierarchy

### "Circular constraint dependency"
- **Cause**: Constraints create circular references
- **Solution**: Review constraint relationships, use priorities

### "Ambiguous layout"
- **Cause**: Insufficient constraints to determine position/size
- **Solution**: Add missing constraints for position and size

## Summary

Most SwiftLayout issues can be resolved by:

1. **Ensuring proper activation**: Use `sl.updateLayout()` or `finalActive()`
2. **Managing priorities**: Resolve conflicts with appropriate priorities
3. **Organizing hierarchy**: Use `sublayout` correctly
4. **Avoiding retain cycles**: Use weak references in closures
5. **Debugging systematically**: Use provided debugging tools

For additional help, refer to the [SwiftLayout repository](https://github.com/ioskrew/SwiftLayout) or check existing issues and documentation.