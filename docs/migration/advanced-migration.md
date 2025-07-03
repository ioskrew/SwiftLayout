# Advanced Migration Patterns

This document covers advanced patterns for migrating complex AutoLayout implementations to SwiftLayout DSL.

## Table of Contents
1. [Dynamic Layouts](#dynamic-layouts)
2. [Conditional Layouts](#conditional-layouts)
3. [Layout Composition](#layout-composition)
4. [Priority and Inequality Constraints](#priority-and-inequality-constraints)
5. [Using Identifiers](#using-identifiers)

## Dynamic Layouts

### Using @LayoutProperty for Dynamic Updates

**AutoLayout:**
```swift
var heightConstraint: NSLayoutConstraint!

// Initial setup
heightConstraint = view.heightAnchor.constraint(equalToConstant: 100)
heightConstraint.isActive = true

// Update
heightConstraint.constant = 200
UIView.animate(withDuration: 0.3) {
    self.view.layoutIfNeeded()
}
```

**SwiftLayout DSL:**
```swift
class MyView: UIView, Layoutable {
    var activation: Activation?
    
    @LayoutProperty var viewHeight: CGFloat = 100
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            childView.sl.anchors {
                Anchors.center.equalToSuper()
                Anchors.width.equalTo(constant: 200)
                Anchors.height.equalTo(constant: viewHeight)
            }
        }
    }
    
    func updateHeight(to newHeight: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.viewHeight = newHeight
            self.sl.updateLayout(forceLayout: true)
        }
    }
}
```

### Manual Layout Updates

```swift
class DynamicViewController: UIViewController, Layoutable {
    var activation: Activation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activation = layout.active()
    }
    
    func updateLayout() {
        activation = layout.update(fromActivation: activation)
    }
}
```

## Conditional Layouts

### State-Based Layouts

```swift
class AdaptiveView: UIView, Layoutable {
    var activation: Activation?
    
    @LayoutProperty var isExpanded = false
    @LayoutProperty var showDetails = false
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            mainContent.sl.anchors {
                Anchors.top.equalToSuper()
                Anchors.horizontal.equalToSuper()
                
                if isExpanded {
                    Anchors.height.equalTo(constant: 300)
                } else {
                    Anchors.height.equalTo(constant: 100)
                }
            }
            
            if showDetails {
                detailView.sl.anchors {
                    Anchors.top.equalTo(mainContent, attribute: .bottom, constant: 10)
                    Anchors.horizontal.equalToSuper()
                    Anchors.bottom.equalToSuper()
                }
            }
        }
    }
}
```

### Device-Specific Layouts

```swift
@LayoutBuilder
var layout: some Layout {
    view.sl.sublayout {
        if UIDevice.current.userInterfaceIdiom == .pad {
            createIPadLayout()
        } else {
            createIPhoneLayout()
        }
    }
}
```

## Layout Composition

### Reusable Layout Components

```swift
class ComplexView: UIView, Layoutable {
    var activation: Activation?
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            headerLayout
            bodyLayout
            footerLayout
        }
    }
    
    @LayoutBuilder
    var headerLayout: some Layout {
        headerContainer.sl.anchors {
            Anchors.cap.equalToSuper()
            Anchors.height.equalTo(constant: 60)
        }.sublayout {
            titleLabel.sl.anchors {
                Anchors.center.equalToSuper()
            }
        }
    }
    
    @LayoutBuilder
    var bodyLayout: some Layout {
        bodyContainer.sl.anchors {
            Anchors.top.equalTo(headerContainer, attribute: .bottom)
            Anchors.horizontal.equalToSuper()
            Anchors.bottom.equalTo(footerContainer, attribute: .top)
        }
    }
    
    @LayoutBuilder
    var footerLayout: some Layout {
        footerContainer.sl.anchors {
            Anchors.shoe.equalToSuper()
            Anchors.height.equalTo(constant: 50)
        }
    }
}
```

### Function-Based Layout Creation

```swift
@LayoutBuilder
func createButtonLayout(button: UIButton, position: Int) -> some Layout {
    button.sl.anchors {
        Anchors.centerY.equalToSuper()
        Anchors.width.equalToSuper().multiplier(0.3)
        Anchors.height.equalTo(constant: 44)
        
        switch position {
        case 0:
            Anchors.leading.equalToSuper(constant: 20)
        case 1:
            Anchors.centerX.equalToSuper()
        default:
            Anchors.trailing.equalToSuper(constant: -20)
        }
    }
}

@LayoutBuilder
var layout: some Layout {
    view.sl.sublayout {
        createButtonLayout(button: button1, position: 0)
        createButtonLayout(button: button2, position: 1)
        createButtonLayout(button: button3, position: 2)
    }
}
```

## Priority and Inequality Constraints

### Basic Priority Usage

```swift
view.sl.anchors {
    // Required constraint
    Anchors.width.greaterThanOrEqualTo(constant: 100)
        .priority(.required)
    
    // High priority preferred size
    Anchors.width.equalTo(constant: 200)
        .priority(.defaultHigh)
    
    // Low priority maximum size
    Anchors.width.lessThanOrEqualTo(constant: 300)
        .priority(.defaultLow)
}
```

### Content Hugging and Compression Resistance

```swift
label.sl.anchors {
    Anchors.leading.equalToSuper(constant: 20)
    Anchors.trailing.lessThanOrEqualToSuper(constant: -20)
        .priority(.init(999))
}

// Set content priorities programmatically
label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
label.setContentCompressionResistancePriority(.required, for: .horizontal)
```

### Aspect Ratio with Priority

```swift
imageView.sl.anchors {
    Anchors.top.equalToSuper()
    Anchors.horizontal.equalToSuper()
    
    // Aspect ratio with high priority
    Anchors.height.equalTo(imageView, attribute: .width)
        .multiplier(9.0/16.0)
        .priority(.init(999))
    
    // Maximum height constraint
    Anchors.height.lessThanOrEqualTo(constant: 300)
        .priority(.required)
}
```

## Using Identifiers

### Setting Identifiers for Debugging

```swift
@LayoutBuilder
var layout: some Layout {
    containerView.sl.sublayout {
        UILabel().sl.identifying("headerTitle").anchors {
            Anchors.cap.equalToSuper()
        }
        
        UIImageView().sl.identifying("profileImage").anchors {
            Anchors.top.equalTo("headerTitle", attribute: .bottom, constant: 20)
            Anchors.centerX.equalToSuper()
            Anchors.size.equalTo(width: 100, height: 100)
        }
        
        UILabel().sl.identifying("username").anchors {
            Anchors.top.equalTo("profileImage", attribute: .bottom, constant: 10)
            Anchors.centerX.equalToSuper()
        }
    }
}
```

### Benefits of Identifiers

1. **Debugging**: Identifiers appear in constraint debug output
2. **Testing**: Easy to find views in UI tests
3. **Reference**: Can reference views by identifier in constraints

## Summary

Advanced migration patterns enable you to:

1. Create dynamic, responsive layouts with `@LayoutProperty`
2. Build conditional layouts based on state or device
3. Compose complex layouts from reusable components
4. Fine-tune constraint behavior with priorities
5. Debug layouts effectively with identifiers

For handling complex view hierarchies and constraint management, see [Complex Hierarchies & Constraints](complex-hierarchies.md).