import XCTest
import SwiftLayout

final class LayoutDSLTests: XCTestCase {
    
    var window: UIView!
    
    var root: UIView = UIView()
    var child: UIView = UIView()
    var button: UIButton = UIButton()
    var label: UILabel = UILabel()
    var red: UIView = UIView()
    var blue: UIView = UIView()
    var green: UIView = UIView()
    var image: UIImageView = UIImageView()
    
    var activation: Set<Activation> = []
    
    override func setUp() {
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150)).identifying("window")
        root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        child = UIView().identifying("child")
        button = UIButton().identifying("button")
        label = UILabel()
        red = UIView()
        blue = UIView()
        image = UIImageView()
    }
    
    override func tearDown() {
        activation = []
    }
}

// MARK: - activation
extension LayoutDSLTests {
    func testActive() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    button
                    label
                    blue {
                        image
                    }
                }
            }
        }
        
        layout.active().store(&activation)
        
        SLTAssertView(view: red, superview: window, subviews: red, blue)
        assertView(red, superview: root, subviews: [button, label, blue])
        assertView(button, superview: red, subviews: [])
        assertView(label, superview: red, subviews: [])
        assertView(blue, superview: red, subviews: [image])
        assertView(image, superview: blue, subviews: [])
    }
    
    func testDeactive() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    button
                    label
                    blue {
                        image
                    }
                }
            }
        }
        
        layout.active().store(&activation)
        
        activation = []
        
        assertView(root, superview: window, subviews: [])
        assertView(red, superview: nil, subviews: [])
        assertView(button, superview: nil, subviews: [])
        assertView(label, superview: nil, subviews: [])
        assertView(blue, superview: nil, subviews: [])
        assertView(image, superview: nil, subviews: [])
    }
    
    func testFinalActive() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    button
                    label
                    blue {
                        image
                    }
                }
            }
        }
        
        layout.finalActive()
        
        assertView(root, superview: window, subviews: [red])
        assertView(red, superview: root, subviews: [button, label, blue])
        assertView(button, superview: red, subviews: [])
        assertView(label, superview: red, subviews: [])
        assertView(blue, superview: red, subviews: [image])
        assertView(image, superview: blue, subviews: [])
    }
    
    func testUpdateLayout() {
        var flag = true
        let parentView = CallCountView()
        let childView_0 = CallCountView()
        let childView_1 = CallCountView()
        
        var activation: Activation?
        
        @LayoutBuilder
        var layout: some Layout {
            parentView {
                if flag {
                    childView_0
                } else {
                    childView_1
                }
            }
        }
        
        context("active") {
            activation = layout.active(forceLayout: true)
            
            assertView(parentView, superview: nil, subviews: [childView_0])
            assertView(childView_0, superview: parentView, subviews: [])
            assertView(childView_1, superview: nil, subviews: [])
            XCTAssertEqual(parentView.addSubviewCallCount(childView_0), 1)
            XCTAssertEqual(parentView.addSubviewCallCount(childView_1), 0)
            XCTAssertEqual(childView_0.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(childView_1.removeFromSuperviewCallCount, 0)
        }
        
        context("update without change") {
            activation = layout.update(fromActivation: activation!, forceLayout: true)
            
            assertView(parentView, superview: nil, subviews: [childView_0])
            assertView(childView_0, superview: parentView, subviews: [])
            assertView(childView_1, superview: nil, subviews: [])
            XCTAssertEqual(parentView.addSubviewCallCount(childView_0), 1)
            XCTAssertEqual(parentView.addSubviewCallCount(childView_1), 0)
            XCTAssertEqual(childView_0.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(childView_1.removeFromSuperviewCallCount, 0)
        }
        
        context("update without change") {
            flag.toggle()
            
            activation = layout.update(fromActivation: activation!, forceLayout: true)
            
            assertView(parentView, superview: nil, subviews: [childView_1])
            assertView(childView_0, superview: nil, subviews: [])
            assertView(childView_1, superview: parentView, subviews: [])
            XCTAssertEqual(parentView.addSubviewCallCount(childView_0), 1)
            XCTAssertEqual(parentView.addSubviewCallCount(childView_1), 1)
            XCTAssertEqual(childView_0.removeFromSuperviewCallCount, 1)
            XCTAssertEqual(childView_1.removeFromSuperviewCallCount, 0)
        }
        
        context("deactive") {
            activation?.deactive()
            activation = nil
            
            assertView(parentView, superview: nil, subviews: [])
            assertView(childView_0, superview: nil, subviews: [])
            assertView(childView_1, superview: nil, subviews: [])
            XCTAssertEqual(parentView.addSubviewCallCount(childView_0), 1)
            XCTAssertEqual(parentView.addSubviewCallCount(childView_1), 1)
            XCTAssertEqual(childView_0.removeFromSuperviewCallCount, 1)
            XCTAssertEqual(childView_1.removeFromSuperviewCallCount, 1)
        }
    }
}

// MARK: - conditional syntax
extension LayoutDSLTests {
    func testIf() {
        var flag = true
        let trueView = UIView()
        let falseView = UIView()
        
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    button
                }
                
                if flag {
                    trueView
                } else {
                    falseView
                }
            }
        }
        
        context("if true") {
            flag = true
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [red, trueView])
            assertView(red, superview: root, subviews: [button])
            assertView(trueView, superview: root, subviews: [])
            assertView(falseView, superview: nil, subviews: [])
        }
        
        context("if false") {
            flag = false
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [red, falseView])
            assertView(red, superview: root, subviews: [button])
            assertView(trueView, superview: nil, subviews: [])
            assertView(falseView, superview: root, subviews: [])
        }
        
    }
    
    func testSwitchCase() {
        enum Test: String, CaseIterable {
            case first
            case second
            case third
        }
        
        let first = UIView()
        let second = UIView()
        let third = UIView()
        
        @LayoutBuilder
        func layout(_ test: Test) -> some Layout {
            root {
                child {
                    switch test {
                    case .first:
                        first
                    case .second:
                        second
                    case .third:
                        third
                    }
                }
            }
        }
        
        context("enum test first") {
            layout(.first).active().store(&activation)
            
            assertView(root, superview: window, subviews: [child])
            assertView(child, superview: root, subviews: [first])
            assertView(first, superview: child, subviews: [])
            assertView(second, superview: nil, subviews: [])
            assertView(third, superview: nil, subviews: [])
        }
        
        context("enum test second") {
            layout(.second).active().store(&activation)
            
            assertView(root, superview: window, subviews: [child])
            assertView(child, superview: root, subviews: [second])
            assertView(first, superview: nil, subviews: [])
            assertView(second, superview: child, subviews: [])
            assertView(third, superview: nil, subviews: [])
        }
        
        context("enum test third") {
            layout(.third).active().store(&activation)
            
            assertView(root, superview: window, subviews: [child])
            assertView(child, superview: root, subviews: [third])
            assertView(first, superview: nil, subviews: [])
            assertView(second, superview: nil, subviews: [])
            assertView(third, superview: child, subviews: [])
        }
    }
    
    func testOptional() {
        var optional: UIView?
        
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    optional
                }
            }
        }
        
        context("view is nil") {
            optional = nil
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [red])
            assertView(red, superview: root, subviews: [])
        }
        
        context("view is optional") {
            optional = UIView()
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [red])
            assertView(red, superview: root, subviews: [optional!])
            assertView(optional!, superview: red, subviews: [])
        }
    }
    
    func testForIn() {
        let view_0 = UIView()
        let view_1 = UIView()
        let view_2 = UIView()
        let view_3 = UIView()
        
        let views = [view_0, view_1, view_2, view_3]
       
        @LayoutBuilder
        var layout: some Layout {
            root {
                for view in views {
                    view
                }
            }
        }
        
        layout.active().store(&activation)
        
        assertView(root, superview: window, subviews: views)
        assertView(view_0, superview: root, subviews: [])
        assertView(view_1, superview: root, subviews: [])
        assertView(view_2, superview: root, subviews: [])
        assertView(view_3, superview: root, subviews: [])
    }
}

// MARK: - complex usage
extension LayoutDSLTests {
    func testConfig() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                child.config {
                    $0.backgroundColor = .yellow
                }.sublayout {
                    label.config {
                        $0.text = "test config"
                        $0.textColor = .green
                    }
                }
            }
        }
        
        layout.finalActive()
        
        assertView(root, superview: window, subviews: [child])
        assertView(child, superview: root, subviews: [label])
        assertView(label, superview: child, subviews: [])
        XCTAssertEqual(child.backgroundColor, UIColor.yellow)
        XCTAssertEqual(label.text, "test config")
        XCTAssertEqual(label.textColor, UIColor.green)
    }
    
    func testDuplicateLayoutBuilder() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                red {
                    button
                }.sublayout {
                    label
                }.sublayout {
                    blue {
                        image
                    }
                }
            }
        }
        
        layout.finalActive()
        
        assertView(root, superview: window, subviews: [red])
        assertView(red, superview: root, subviews: [button, label, blue])
        assertView(button, superview: red, subviews: [])
        assertView(label, superview: red, subviews: [])
        assertView(blue, superview: red, subviews: [image])
        assertView(image, superview: blue, subviews: [])
    }
    
    func testSeparatedFromFirstLevel() {
        @LayoutBuilder
        var layout: some Layout {
            root {
                child
                red
                image
            }
            
            child {
                button
                label
            }
            
            red {
                blue
                green
            }
        }
        
        layout.finalActive()
        
        assertView(root, superview: window, subviews: [child, red, image])
        assertView(child, superview: root, subviews: [button, label])
        assertView(red, superview: root, subviews: [blue, green])
        assertView(image, superview: root, subviews: [])
        assertView(button, superview: child, subviews: [])
        assertView(label, superview: child, subviews: [])
        assertView(blue, superview: red, subviews: [])
        assertView(green, superview: red, subviews: [])
    }
}

// MARK: - GroupLayout
extension LayoutDSLTests {
    func testGroupLayout() {
        let group1_1 = UIView()
        let group1_2 = UIView()
        let group1_3 = UIView()
        let group2_1 = UIView()
        let group2_2 = UIView()
        
        @LayoutBuilder
        var layout: some Layout {
            root {
                GroupLayout {
                    group1_1
                    group1_2
                    group1_3
                }
                GroupLayout {
                    group2_1
                    group2_2
                }
            }
        }
        
        layout.finalActive()
        
        assertView(root, superview: window, subviews: [group1_1, group1_2, group1_3, group2_1, group2_2])
        assertView(group1_1, superview: root, subviews: [])
        assertView(group1_2, superview: root, subviews: [])
        assertView(group1_3, superview: root, subviews: [])
        assertView(group2_1, superview: root, subviews: [])
        assertView(group2_2, superview: root, subviews: [])
    }
}

// MARK: - ModularLayout
extension LayoutDSLTests {
    struct Module1: ModularLayout {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        
        @LayoutBuilder var layout: some Layout {
            view1 {
                view2
            }
            
            view3
        }
    }
    
    struct Module2: ModularLayout {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        
        @LayoutBuilder var layout: some Layout {
            view1
            
            view2 {
                view3
            }
        }
    }
    
    func testModularLayout() {
        let module1: Module1 = Module1()
        var module2: Module2?
        
        @LayoutBuilder
        var layout: some Layout {
            root {
                module1
                module2
            }
        }
        
        context("module2 is nil") {
            module2 = nil
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [module1.view1, module1.view3])
            assertView(module1.view1, superview: root, subviews: [module1.view2])
            assertView(module1.view2, superview: module1.view1, subviews: [])
            assertView(module1.view3, superview: root, subviews: [])
        }
        
        context("module2 is optional") {
            module2 = Module2()
            layout.active().store(&activation)
            
            assertView(root, superview: window, subviews: [module1.view1, module1.view3, module2!.view1, module2!.view2])
            assertView(module1.view1, superview: root, subviews: [module1.view2])
            assertView(module1.view2, superview: module1.view1, subviews: [])
            assertView(module1.view3, superview: root, subviews: [])
            assertView(module2!.view1, superview: root, subviews: [])
            assertView(module2!.view2, superview: root, subviews: [module2!.view3])
            assertView(module2!.view3, superview: module2!.view2, subviews: [])
        }
    }
}
