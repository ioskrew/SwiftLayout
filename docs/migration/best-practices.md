# Best Practices

This document outlines best practices for migrating from AutoLayout to SwiftLayout and maintaining SwiftLayout-based projects.

## Table of Contents
1. [Migration Process](#migration-process)
2. [Code Organization](#code-organization)
3. [Performance Optimization](#performance-optimization)
4. [Testing Strategies](#testing-strategies)
5. [Common Pitfalls](#common-pitfalls)

## Migration Process

### Step-by-Step Approach

1. **Analyze Current Layout**
   - Document existing constraint relationships
   - Identify dynamic behaviors
   - Note any complex constraint logic

2. **Start with Leaf Views**
   - Begin with simple, standalone views
   - Gradually work up to container views
   - Test each component thoroughly

3. **Incremental Migration**
   ```swift
   // Phase 1: Migrate simple views
   class SimpleView: UIView, Layoutable {
       var activation: Activation?
       
       @LayoutBuilder
       var layout: some Layout {
           // Start with basic constraints
       }
   }
   
   // Phase 2: Add complex behaviors
   // Phase 3: Optimize and refine
   ```

4. **Maintain Compatibility**
   - Keep both implementations during transition
   - Use feature flags if needed
   - Ensure visual parity

### Migration Checklist

- [ ] Remove `translatesAutoresizingMaskIntoConstraints = false`
- [ ] Convert `addSubview()` to `sublayout`
- [ ] Replace `NSLayoutConstraint` with `Anchors`
- [ ] Update activation logic
- [ ] Test on all device sizes
- [ ] Verify dynamic behaviors
- [ ] Performance testing

## Code Organization

### 1. View Structure

```swift
class WellOrganizedView: UIView, Layoutable {
    var activation: Activation?
    
    // MARK: - UI Components
    private let headerView = HeaderView()
    private let contentView = ContentView()
    private let footerView = FooterView()
    
    // MARK: - Layout Properties
    @LayoutProperty var isExpanded = false
    @LayoutProperty var contentHeight: CGFloat = 200
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        sl.updateLayout()
    }
    
    // MARK: - Layout
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            createMainLayout()
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        // Configure views
    }
    
    @LayoutBuilder
    private func createMainLayout() -> some Layout {
        // Layout implementation
    }
}
```

### 2. Modular Layouts

```swift
// Separate layout concerns into extensions
extension DashboardViewController {
    @LayoutBuilder
    var headerLayout: some Layout {
        // Header-specific layout
    }
    
    @LayoutBuilder
    var contentLayout: some Layout {
        // Content-specific layout
    }
}

// Reusable layout components
struct LayoutComponents {
    @LayoutBuilder
    static func standardButton(_ button: UIButton) -> some Layout {
        button.sl.anchors {
            Anchors.height.equalTo(constant: 44)
            Anchors.horizontal.equalToSuper(constant: 20)
        }
    }
}
```

### 3. Naming Conventions

```swift
// Clear, descriptive names for layout methods
@LayoutBuilder
func createNavigationBarLayout() -> some Layout { }

@LayoutBuilder
func createContentGridLayout() -> some Layout { }

@LayoutBuilder
func createFloatingActionButtonLayout() -> some Layout { }
```

## Performance Optimization

### 1. Minimize Layout Updates

```swift
// Bad: Multiple updates
func updateMultipleProperties() {
    property1 = value1
    sl.updateLayout()
    property2 = value2
    sl.updateLayout()
    property3 = value3
    sl.updateLayout()
}

// Good: Batch updates
func updateMultipleProperties() {
    UIView.performWithoutAnimation {
        property1 = value1
        property2 = value2
        property3 = value3
        sl.updateLayout()
    }
}
```

### 2. Use Appropriate Activation

```swift
// Static layouts: Use finalActive()
override func viewDidLoad() {
    super.viewDidLoad()
    staticLayout.finalActive()
}

// Dynamic layouts: Use active() with updates
override func viewDidLoad() {
    super.viewDidLoad()
    activation = dynamicLayout.active()
}

func updateLayout() {
    activation = dynamicLayout.update(fromActivation: activation)
}
```

### 3. Lazy Layout Creation

```swift
class PerformantView: UIView, Layoutable {
    var activation: Activation?
    
    // Create complex layouts lazily
    private lazy var complexSectionLayout: some Layout = {
        createComplexSection()
    }()
    
    @LayoutBuilder
    var layout: some Layout {
        self.sl.sublayout {
            if shouldShowComplexSection {
                complexSectionLayout
            }
        }
    }
}
```

## Testing Strategies

### 1. Unit Testing Layouts

```swift
class LayoutTests: XCTestCase {
    func testBasicLayout() {
        // Arrange
        let view = TestView()
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        
        // Act
        superview.addSubview(view)
        view.sl.updateLayout()
        superview.layoutIfNeeded()
        
        // Assert
        XCTAssertEqual(view.frame.width, 200)
        XCTAssertEqual(view.frame.height, 100)
        XCTAssertEqual(view.frame.origin.x, 87.5) // Centered
    }
    
    func testDynamicLayout() {
        // Test @LayoutProperty updates
        let view = DynamicView()
        view.isExpanded = false
        view.sl.updateLayout()
        
        let collapsedHeight = view.frame.height
        
        view.isExpanded = true
        view.sl.updateLayout()
        
        let expandedHeight = view.frame.height
        
        XCTAssertGreaterThan(expandedHeight, collapsedHeight)
    }
}
```

### 2. Snapshot Testing

```swift
func testViewAppearance() {
    let view = ComplexView()
    view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
    view.sl.updateLayout()
    view.layoutIfNeeded()
    
    // Compare with reference image
    assertSnapshot(matching: view, as: .image)
}
```

### 3. Layout Debugging

```swift
#if DEBUG
extension Layoutable where Self: UIView {
    func debugLayout() {
        print("=== Layout Debug ===")
        print("View: \(type(of: self))")
        print("Frame: \(frame)")
        print("Constraints count: \(constraints.count)")
        
        if let activation = activation {
            print("Active constraints: \(activation.constraints.count)")
        }
    }
}
#endif
```

## Common Pitfalls

### 1. Forgetting to Activate Layouts

```swift
// Wrong: Layout created but not activated
override func viewDidLoad() {
    super.viewDidLoad()
    let _ = layout // Layout not activated!
}

// Correct: Activate the layout
override func viewDidLoad() {
    super.viewDidLoad()
    sl.updateLayout() // or layout.finalActive()
}
```

### 2. Mixing Approaches

```swift
// Wrong: Mixing AutoLayout and SwiftLayout
view.sl.anchors { 
    Anchors.top.equalToSuper()
}
// Don't also use:
NSLayoutConstraint.activate([...])

// Correct: Use one approach consistently
```

### 3. Incorrect View Hierarchy

```swift
// Wrong: Adding subviews manually
view.addSubview(childView)
childView.sl.anchors { ... }

// Correct: Use sublayout
view.sl.sublayout {
    childView.sl.anchors { ... }
}
```

### 4. Memory Leaks

```swift
// Wrong: Strong reference in closure
view.sl.onActivate { view in
    view.backgroundColor = self.currentColor // Retains self
}

// Correct: Use weak reference
view.sl.onActivate { [weak self] view in
    view.backgroundColor = self?.currentColor
}
```

### 5. Performance Issues

```swift
// Wrong: Creating new layouts repeatedly
override func layoutSubviews() {
    super.layoutSubviews()
    createNewLayout().active() // Creates new constraints each time
}

// Correct: Update existing layout
override func layoutSubviews() {
    super.layoutSubviews()
    // Layout updates automatically with @LayoutProperty
}
```

## Summary

Following these best practices will help you:

1. **Migrate Smoothly**: Incremental, tested migration process
2. **Write Clean Code**: Well-organized, maintainable layouts
3. **Optimize Performance**: Efficient constraint management
4. **Test Effectively**: Comprehensive testing strategies
5. **Avoid Problems**: Common pitfalls and solutions

For troubleshooting specific issues, see [Troubleshooting](troubleshooting.md).