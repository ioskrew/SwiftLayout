import XCTest
import SwiftLayout

/// test cases for DSL syntax
final class LayoutDSLTests: XCTestCase {
    
    var window: UIView!
    
    var root: UIView = UIView().viewTag.root
    var child: UIView = UIView().viewTag.child
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var red: UIView = UIView().viewTag.red
    var blue: UIView = UIView().viewTag.blue
    var green: UIView = UIView().viewTag.green
    var image: UIImageView = UIImageView().viewTag.image
    
    var activation: Set<Activation> = []
    
    override func setUp() {
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        child = UIView().viewTag.child
        button = UIButton().viewTag.button
        label = UILabel().viewTag.label
        red = UIView().viewTag.red
        blue = UIView().viewTag.blue
        image = UIImageView().viewTag.image
    }
    
    override func tearDown() {
        activation = []
    }
}

// MARK: - normal syntax
extension LayoutDSLTests {
    func testActive() {
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }.active().store(&activation)
        
        let expect = """
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(options: .onlyIdentifier), expect)
    }
    
    func testDeactive() {
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }.active().store(&activation)
        
        activation = []
        
        let expect = """
        root
        """
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testFinalActive() {
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }.finalActive()
        
        let expect = """
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(options: .onlyIdentifier), expect)
    }
    
    func testDuplicateLayoutBuilder() {
        root {
            red {
                button
                label
            }.sublayout {
                blue {
                    image
                }
            }
        }.finalActive()
        
        let expect = """
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(options: .onlyIdentifier), expect)
    }
    
    func testAllSides() {
        root {
            red.anchors {
                Anchors.allSides()
            }.sublayout {
                blue.anchors {
                    Anchors.allSides(offset: 8)
                }.sublayout {
                    green.anchors {
                        Anchors.allSides(blue, offset: 16)
                    }
                }
            }
        }.active().store(&activation)
        
        let expect = """
        oot {
            red.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                blue.anchors {
                    Anchors.top.equalToSuper(constant: 8.0)
                    Anchors.bottom.equalToSuper(constant: -8.0)
                    Anchors.leading.equalToSuper(constant: 8.0)
                    Anchors.trailing.equalToSuper(constant: -8.0)
                }.sublayout {
                    green.anchors {
                        Anchors.top.equalToSuper(constant: 16.0)
                        Anchors.bottom.equalToSuper(constant: -16.0)
                        Anchors.leading.equalToSuper(constant: 16.0)
                        Anchors.trailing.equalToSuper(constant: -16.0)
                    }
                }
            }
        }
        """
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect.tabbed)
    }
    
}

// MARK: - layouts in same first level
extension LayoutDSLTests {
    
    func testLayoutsSameFirstLevel() {
        let root = TestView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        root.sl.updateLayout()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                blue.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                    Anchors(.height).equalTo(constant: 44.0)
                }.sublayout {
                    green.anchors {
                        Anchors(.top, .bottom, .leading, .trailing)
                        Anchors(.width).equalTo(constant: 88.0)
                    }
                }
            }
        }
        """
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect.tabbed)
    }
    
    private final class TestView: UIView, Layoutable {
        lazy var red = UIView().viewTag.red
        lazy var blue = UIView().viewTag.blue
        lazy var green = UIView().viewTag.green
        
        var activation: Activation? 
        @LayoutBuilder
        var layout: some Layout {
            self {
                red.anchors {
                    Anchors.allSides()
                }.sublayout {
                    blue.anchors {
                        Anchors.allSides()
                    }.sublayout {
                        green.anchors {
                            Anchors.allSides()
                        }
                    }
                }
            }
            blue.anchors {
                Anchors.height.equalTo(constant: 44.0)
            }
            green.anchors {
                Anchors.width.equalTo(constant: 88.0)
            }
        }
    }
}


// MARK: - layouts in same first level
extension LayoutDSLTests {
    
    func testUpdateIdentifiers() {
        let rootView = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        let container = TestViewContainer()
        container.root.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(container.root)
        
        container.root {
            container.red {
                container.button
                container.label
                container.blue {
                    container.image
                }
            }
        }
        .updateIdentifiers(rootObject: container)
        .active()
        .store(&activation)
        
        let expect = """
        root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(container.root).print(options: .onlyIdentifier), expect)
        
        XCTAssertEqual(container.root.accessibilityIdentifier, "root")
        XCTAssertEqual(container.red.accessibilityIdentifier, "red")
        XCTAssertEqual(container.button.accessibilityIdentifier, "button")
        XCTAssertEqual(container.label.accessibilityIdentifier, "label")
        XCTAssertEqual(container.blue.accessibilityIdentifier, "blue")
        XCTAssertEqual(container.image.accessibilityIdentifier, "image")
    }
    
    // This can be a UIViewController or a UIView.
    private final class TestViewContainer {
        let root = UIView()
        let red = UIView()
        let blue = UIView()
        let button = UIButton()
        let label = UILabel()
        let image = UIImageView()
    }
}

// MARK: - conditional syntax
extension LayoutDSLTests {
    func testIF() {
        @LayoutBuilder
        func layout(_ flag: Bool) -> some Layout {
            root {
                red {
                    button
                }
                
                if flag {
                    UIView().viewTag.true
                } else {
                    UIView().viewTag.false
                }
            }
        }
        
        context("if true") {
            root = UIView().viewTag.root
            layout(true).finalActive()
            XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
            root {
                red {
                    button
                }
                true
            }
            """.tabbed)
        }
        
        context("if false") {
            root = UIView().viewTag.root
            layout(false).finalActive()
            XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
            root {
                red {
                    button
                }
                false
            }
            """.tabbed)
        }
        
    }
    
    func testSwitchCase() {
        enum Test: String, CaseIterable {
            case first
            case second
            case third
        }
        @LayoutBuilder
        func layout(_ test: Test) -> some Layout {
            root {
                child {
                    switch test {
                    case .first:
                        UIView().viewTag.first
                    case .second:
                        UIView().viewTag.second
                    case .third:
                        UIView().viewTag.third
                    }
                }
            }
        }
        
        for test in Test.allCases {
            context("enum Test.\(test)") {
                activation = []
                layout(test).active().store(&activation)
                XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
                root {
                    child {
                        \(test)
                    }
                }
                """.tabbed)
            }
        }
    }
    
    func testLayoutWithOptionalViews() {
        
        @LayoutBuilder
        func layout(_ view: UIView?) -> some Layout {
            root {
                red {
                    view?.identifying("optional")
                }
            }
        }
        
        context("view is nil") {
            activation = []
            layout(nil).active().store(&activation)
            XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
            root {
                red
            }
            """.tabbed)
        }
        
        context("view is optional") {
            activation = []
            layout(UIView()).active().store(&activation)
            XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
            root {
                red {
                    optional
                }
            }
            """.tabbed)
        }
    }
    
    func testLayoutWithForIn() {
       
        @LayoutBuilder
        func layout() -> some Layout {
            root {
                for index in 0..<3 {
                    UIView().identifying("view_\(index)")
                }
            }
        }
        
        layout().active().store(&activation)
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            view_0
            view_1
            view_2
        }
        """.tabbed)
    }
    
}

extension LayoutDSLTests {
    func testUpdateLayout() {
        let view = LayoutView().viewTag.view
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        
        var activation = view.layout.active(forceLayout: true)
        
        XCTAssertEqual(view.child.bounds.size, CGSize(width: 90, height: 90))
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                child.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
        }
        """.tabbed)
        
        activation = view.layout.update(fromActivation: activation, forceLayout: true)

        XCTAssertEqual(view.root.count(view.child), 1)
        XCTAssertEqual(view.root.count(view.friend), 0)
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                child.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
        }
        """.tabbed)

        view.flag.toggle()
        activation = view.layout.update(fromActivation: activation, forceLayout: true)
        
        XCTAssertEqual(view.root.count(view.child), 1)
        XCTAssertEqual(view.root.count(view.friend), 1)
        XCTAssertEqual(view.friend.superview, view.root)
        XCTAssertEqual(view.root.bounds.size, .init(width: 90, height: 90))
        XCTAssertEqual(view.friend.bounds.size, .init(width: 90, height: 90))
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                friend.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
        }
        """.tabbed)
    }
    
    class MockView: UIView {
        var addSubviewCounts: [UIView: Int] = [:]
        
        func count(_ view: UIView) -> Int {
            addSubviewCounts[view] ?? 0
        }
        
        override func addSubview(_ view: UIView) {
            if let count = addSubviewCounts[view] {
                addSubviewCounts[view] = count + 1
            } else {
                addSubviewCounts[view] = 1
            }
            super.addSubview(view)
        }
    }
    
    class LayoutView: UIView {
        var flag = true
        
        let root = MockView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UILabel().viewTag.friend
        
        var activation: Activation?
        
        var layout: some Layout {
            self {
                root.anchors({
                    Anchors.allSides()
                }).sublayout {
                    if flag {
                        child.anchors {
                            Anchors.allSides()
                        }
                    } else {
                        friend.anchors {
                            Anchors.allSides()
                        }
                    }
                }
            }
        }
    }
}

// MARK: GroupLayout

extension LayoutDSLTests {
    func testGroupLayout() {
        let group1_1 = UIView().viewTag.group1_1
        let group1_2 = UIView().viewTag.group1_2
        let group1_3 = UIView().viewTag.group1_3
        let group2_1 = UIView().viewTag.group2_1
        let group2_2 = UIView().viewTag.group2_2
        
        root {
            GroupLayout {
                group1_1.anchors {
                    Anchors.cap()
                }
                group1_2.anchors {
                    Anchors.top.equalTo(group1_1, attribute: .bottom)
                    Anchors.horizontal(root)
                }
                group1_3.anchors {
                    Anchors.top.equalTo(group1_1, attribute: .bottom)
                    Anchors.horizontal(root, offset: 8.0)
                }
            }
            GroupLayout {
                group2_1.anchors {
                    Anchors.top.equalTo(group1_3, attribute: .bottom)
                    Anchors.horizontal(offset: 12)
                }
                group2_2.anchors {
                    Anchors.top.equalTo(group2_2, attribute: .bottom)
                    Anchors.shoe()
                }
            }
        }.finalActive()
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            group1_1.anchors {
                Anchors(.top, .leading, .trailing)
            }
            group1_2.anchors {
                Anchors(.top).equalTo(group1_1, attribute: .bottom)
                Anchors(.leading, .trailing)
            }
            group1_3.anchors {
                Anchors(.top).equalTo(group1_1, attribute: .bottom)
                Anchors(.leading).equalTo(constant: 8.0)
                Anchors(.trailing).equalTo(constant: -8.0)
            }
            group2_1.anchors {
                Anchors(.top).equalTo(group1_3, attribute: .bottom)
                Anchors(.leading).equalTo(constant: 12.0)
                Anchors(.trailing).equalTo(constant: -12.0)
            }
            group2_2.anchors {
                Anchors(.bottom, .leading, .trailing)
                Anchors(.top).equalTo(group2_2, attribute: .bottom)
            }
        }
        """.tabbed)
    }
}

// MARK: - ModularLayout

extension LayoutDSLTests {
    struct Module1: ModularLayout {
        let module1view1 = UIView().viewTag.module1view1
        let module1view2 = UIView().viewTag.module1view2
        let module1view3 = UIView().viewTag.module1view3
        
        @LayoutBuilder var layout: some Layout {
            module1view1.anchors {
                Anchors.leading
                Anchors.top
                Anchors.height.width.multiplier(0.5)
            }.sublayout {
                module1view2.anchors {
                    Anchors.centerY
                    Anchors.leading
                    Anchors.size(width: 50, height: 50)
                }
            }
            
            module1view3.anchors {
                Anchors.height.equalTo(constant: 20)
                Anchors.leading
                Anchors.bottom
            }
        }
    }
    
    struct Module2: ModularLayout {
        let module2view1 = UIView().viewTag.module2view1
        let module2view2 = UIView().viewTag.module2view2
        let module2view3 = UIView().viewTag.module2view3
        
        @LayoutBuilder var layout: some Layout {
            module2view1.anchors {
                Anchors.top
                Anchors.trailing
                Anchors.height.width.multiplier(0.5)
            }.sublayout {
                module2view2.anchors {
                    Anchors.centerY
                    Anchors.trailing
                    Anchors.size(width: 50, height: 50)
                }
            }
            
            module2view3.anchors {
                Anchors.height.equalTo(constant: 20)
                Anchors.bottom
                Anchors.trailing
            }
        }
    }
    
    func testModularLayout() {
        root {
            Module1()
            Module2()
        }.finalActive()
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            module1view1.anchors {
                Anchors(.top, .leading)
                Anchors(.width, .height).setMultiplier(0.5)
            }.sublayout {
                module1view2.anchors {
                    Anchors(.leading, .centerY)
                    Anchors(.width, .height).equalTo(constant: 50.0)
                }
            }
            module1view3.anchors {
                Anchors(.bottom, .leading)
                Anchors(.height).equalTo(constant: 20.0)
            }
            module2view1.anchors {
                Anchors(.top, .trailing)
                Anchors(.width, .height).setMultiplier(0.5)
            }.sublayout {
                module2view2.anchors {
                    Anchors(.trailing, .centerY)
                    Anchors(.width, .height).equalTo(constant: 50.0)
                }
            }
            module2view3.anchors {
                Anchors(.bottom, .trailing)
                Anchors(.height).equalTo(constant: 20.0)
            }
        }
        """.tabbed)
    }
}
