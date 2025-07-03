# Complex Hierarchies & Constraints

This document covers patterns for managing deeply nested view hierarchies and complex constraint relationships with priorities and multipliers.

## Table of Contents
1. [Deep View Hierarchies](#deep-view-hierarchies)
2. [Priority Management](#priority-management)
3. [Multiplier Usage](#multiplier-usage)
4. [Constraint Organization Strategies](#constraint-organization-strategies)
5. [Performance Optimization](#performance-optimization)

## Deep View Hierarchies

### Example: 4+ Level Nested Structure

```swift
class ComplexViewController: UIViewController, Layoutable {
    var activation: Activation?
    
    @LayoutBuilder
    var layout: some Layout {
        view.sl.sublayout {
            // Level 1: Main container
            mainContainer.sl.anchors {
                Anchors.allSides.equalTo(view.safeAreaLayoutGuide)
            }.sublayout {
                // Level 2: Section containers
                headerSection.sl.anchors {
                    Anchors.cap.equalToSuper()
                    Anchors.height.equalTo(constant: 150)
                }.sublayout {
                    // Level 3: Header components
                    logoContainer.sl.anchors {
                        Anchors.leading.equalToSuper(constant: 20)
                        Anchors.centerY.equalToSuper()
                        Anchors.size.equalTo(width: 60, height: 60)
                    }.sublayout {
                        // Level 4: Logo details
                        logoImageView.sl.anchors {
                            Anchors.allSides.equalToSuper()
                        }
                        
                        badgeView.sl.anchors {
                            Anchors.top.equalToSuper(constant: -5)
                            Anchors.trailing.equalToSuper(constant: 5)
                            Anchors.size.equalTo(width: 20, height: 20)
                        }
                    }
                    
                    titleStackView.sl.anchors {
                        Anchors.leading.equalTo(logoContainer, attribute: .trailing, constant: 15)
                        Anchors.trailing.equalToSuper(constant: -20)
                        Anchors.centerY.equalToSuper()
                    }
                }
                
                contentSection.sl.anchors {
                    Anchors.top.equalTo(headerSection, attribute: .bottom)
                    Anchors.horizontal.equalToSuper()
                    Anchors.bottom.equalToSuper()
                }.sublayout {
                    createContentLayout()
                }
            }
        }
    }
}
```

### Managing Complex Hierarchies

1. **Use Structured Properties**:
```swift
struct HeaderViews {
    let container = UIView()
    let logo = UIImageView()
    let title = UILabel()
    let subtitle = UILabel()
}

struct ContentViews {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let sections: [UIView] = (0..<5).map { _ in UIView() }
}

let header = HeaderViews()
let content = ContentViews()
```

2. **Separate Layout Logic**:
```swift
@LayoutBuilder
var headerLayout: some Layout {
    header.container.sl.sublayout {
        // Header-specific layout
    }
}

@LayoutBuilder
var contentLayout: some Layout {
    content.scrollView.sl.sublayout {
        // Content-specific layout
    }
}
```

## Priority Management

### Priority Constants

```swift
extension UILayoutPriority {
    static let almostRequired = UILayoutPriority(999)
    static let highPriority = UILayoutPriority(750)
    static let mediumPriority = UILayoutPriority(500)
    static let lowPriority = UILayoutPriority(250)
}
```

### Conflict Resolution with Priorities

```swift
@LayoutBuilder
func createAdaptiveLayout() -> some Layout {
    containerView.sl.sublayout {
        contentView.sl.anchors {
            // Required constraints for structure
            Anchors.center.equalToSuper()
                .priority(.required)
            
            // Preferred size with high priority
            Anchors.width.equalTo(constant: 300)
                .priority(.highPriority)
            
            // Minimum size requirement
            Anchors.width.greaterThanOrEqualTo(constant: 200)
                .priority(.required)
            
            // Maximum size limit
            Anchors.width.lessThanOrEqualToSuper(constant: -40)
                .priority(.almostRequired)
            
            // Flexible height with aspect ratio
            Anchors.height.equalTo(contentView, attribute: .width)
                .multiplier(0.75)
                .priority(.mediumPriority)
        }
    }
}
```

### Dynamic Priority Adjustment

```swift
class ResponsiveView: UIView, Layoutable {
    var activation: Activation?
    
    @LayoutProperty var isCompact: Bool = false
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            contentView.sl.anchors {
                if isCompact {
                    // Compact layout with different priorities
                    Anchors.width.equalToSuper(constant: -32)
                        .priority(.required)
                    Anchors.height.greaterThanOrEqualTo(constant: 200)
                        .priority(.highPriority)
                } else {
                    // Regular layout
                    Anchors.width.equalToSuper()
                        .multiplier(0.8)
                        .priority(.highPriority)
                    Anchors.width.lessThanOrEqualTo(constant: 600)
                        .priority(.required)
                }
            }
        }
    }
}
```

## Multiplier Usage

### Proportional Layouts

```swift
@LayoutBuilder
func createProportionalGrid() -> some Layout {
    gridContainer.sl.sublayout {
        // Three columns with equal width
        leftColumn.sl.anchors {
            Anchors.leading.equalToSuper()
            Anchors.width.equalToSuper()
                .multiplier(1.0/3.0)
                .priority(.almostRequired)
            Anchors.vertical.equalToSuper()
        }
        
        centerColumn.sl.anchors {
            Anchors.leading.equalTo(leftColumn, attribute: .trailing)
            Anchors.width.equalTo(leftColumn)
                .priority(.almostRequired)
            Anchors.vertical.equalToSuper()
        }
        
        rightColumn.sl.anchors {
            Anchors.leading.equalTo(centerColumn, attribute: .trailing)
            Anchors.trailing.equalToSuper()
            Anchors.width.equalTo(leftColumn)
                .priority(.almostRequired)
            Anchors.vertical.equalToSuper()
        }
    }
}
```

### Aspect Ratios

```swift
imageView.sl.anchors {
    // 16:9 aspect ratio
    Anchors.height.equalTo(imageView, attribute: .width)
        .multiplier(9.0/16.0)
        .priority(.almostRequired)
}

// Square view
avatarView.sl.anchors {
    Anchors.height.equalTo(avatarView, attribute: .width)
        .multiplier(1.0)
        .priority(.required)
}
```

### Relative Sizing

```swift
// Child view takes 80% of parent width
childView.sl.anchors {
    Anchors.centerX.equalToSuper()
    Anchors.width.equalToSuper()
        .multiplier(0.8)
        .priority(.highPriority)
}

// Sidebar takes 25% of screen width
sidebarView.sl.anchors {
    Anchors.leading.equalToSuper()
    Anchors.width.equalToSuper()
        .multiplier(0.25)
        .priority(.almostRequired)
    Anchors.width.greaterThanOrEqualTo(constant: 200)
        .priority(.required)
}
```

## Constraint Organization Strategies

### 1. Logical Grouping

```swift
@LayoutBuilder
var layout: some Layout {
    view.sl.sublayout {
        structuralConstraints
        sizingConstraints
        positioningConstraints
    }
}

@LayoutBuilder
var structuralConstraints: some Layout {
    // Core layout structure
}

@LayoutBuilder
var sizingConstraints: some Layout {
    // Size-related constraints
}

@LayoutBuilder
var positioningConstraints: some Layout {
    // Position-related constraints
}
```

### 2. Component-Based Organization

```swift
class DashboardView: UIView, Layoutable {
    var activation: Activation?
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            HeaderComponent(views: headerViews).layout
            SidebarComponent(views: sidebarViews).layout
            ContentComponent(views: contentViews).layout
        }
    }
}

struct HeaderComponent {
    let views: HeaderViews
    
    @LayoutBuilder
    var layout: some Layout {
        views.container.sl.sublayout {
            // Header-specific layout
        }
    }
}
```

## Performance Optimization

### 1. Lazy Layout Creation

```swift
class OptimizedView: UIView, Layoutable {
    var activation: Activation?
    
    // Cache complex calculations
    private lazy var complexLayout: some Layout = {
        createComplexLayout()
    }()
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            if shouldShowComplexLayout {
                complexLayout
            } else {
                simpleLayout
            }
        }
    }
}
```

### 2. Batch Updates

```swift
func updateMultipleProperties() {
    UIView.performWithoutAnimation {
        // Update all properties at once
        isExpanded = true
        showDetails = true
        contentHeight = 500
        
        // Single layout update
        sl.updateLayout()
    }
}
```

### 3. Constraint Caching

```swift
class CachedLayoutView: UIView, Layoutable {
    var activation: Activation?
    private var layoutCache: [String: Layout] = [:]
    
    @LayoutBuilder
    func cachedLayout(key: String, creator: () -> Layout) -> some Layout {
        if let cached = layoutCache[key] {
            return cached
        }
        let newLayout = creator()
        layoutCache[key] = newLayout
        return newLayout
    }
}
```

## Debugging Tips

### 1. Use Identifiers

```swift
complexView.sl.identifying("complex.main").sublayout {
    headerView.sl.identifying("complex.header")
    contentView.sl.identifying("complex.content")
}
```

### 2. Constraint Validation

```swift
#if DEBUG
func validateConstraints() {
    let constraints = activation?.constraints ?? []
    for constraint in constraints {
        if constraint.priority.rawValue < 250 {
            print("⚠️ Low priority constraint: \(constraint)")
        }
    }
}
#endif
```

## Summary

Managing complex hierarchies requires:

1. **Organization**: Structure your views and layouts logically
2. **Priority Management**: Use priorities to resolve conflicts
3. **Multipliers**: Create proportional, responsive layouts
4. **Performance**: Optimize for complex scenarios
5. **Debugging**: Use identifiers and validation tools

For real-world examples of these patterns in action, see [Real-world Examples](real-world-examples.md).