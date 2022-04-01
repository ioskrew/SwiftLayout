import XCTest
import SwiftLayout
import SwiftLayoutUtil

/// test cases for DSL syntax
final class LayoutDSLTests: XCTestCase {
    
    var window: UIView!
    
    var root: UIView = UIView().identifying("root")
    var child: UIView = UIView().identifying("child")
    var button: UIButton = UIButton().identifying("button")
    var label: UILabel = UILabel().identifying("label")
    var red: UIView = UIView().identifying("red")
    var blue: UIView = UIView().identifying("blue")
    var green: UIView = UIView().identifying("green")
    var image: UIImageView = UIImageView().identifying("image")
    
    var activation: Set<Activation> = []
    
    override func setUp() {
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        child = UIView().identifying("child")
        button = UIButton().identifying("button")
        label = UILabel().identifying("label")
        red = UIView().identifying("red")
        blue = UIView().identifying("blue")
        image = UIImageView().identifying("image")
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
        
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, expect)
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
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
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
        
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, expect)
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
        
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, expect)
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
        root {
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
        
        XCTAssertEqual(ViewPrinter(root).description, expect.tabbed)
    }
    
}

// MARK: - layouts in same first level
extension LayoutDSLTests {
    
    func testLayoutsSameFirstLevel() {
        let root = TestView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        root.sl.updateLayout()
        
        let expect = """
        root {
            red.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                blue.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                    Anchors.height.equalTo(constant: 44.0)
                }.sublayout {
                    green.anchors {
                        Anchors.top.bottom
                        Anchors.leading.trailing
                        Anchors.width.equalTo(constant: 88.0)
                    }
                }
            }
        }
        """
        XCTAssertEqual(ViewPrinter(root).description, expect.tabbed)
    }
    
    private final class TestView: UIView, Layoutable {
        lazy var red = UIView().identifying("red")
        lazy var blue = UIView().identifying("blue")
        lazy var green = UIView().identifying("green")
        
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
        
        XCTAssertEqual(
            ViewPrinter(container.root, options: .onlyIdentifier)
                .updateIdentifiers(rootObject: container)
                .description,
            expect
        )
        
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
                    UIView().identifying("true")
                } else {
                    UIView().identifying("false")
                }
            }
        }
        
        context("if true") {
            root = UIView().identifying("root")
            layout(true).finalActive()
            XCTAssertEqual(ViewPrinter(root).description, """
            root {
                red {
                    button
                }
                true
            }
            """.tabbed)
        }
        
        context("if false") {
            root = UIView().identifying("root")
            layout(false).finalActive()
            XCTAssertEqual(ViewPrinter(root).description, """
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
                        UIView().identifying("first")
                    case .second:
                        UIView().identifying("second")
                    case .third:
                        UIView().identifying("third")
                    }
                }
            }
        }
        
        for test in Test.allCases {
            context("enum Test.\(test)") {
                activation = []
                layout(test).active().store(&activation)
                XCTAssertEqual(ViewPrinter(root).description, """
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
            XCTAssertEqual(ViewPrinter(root).description, """
            root {
                red
            }
            """.tabbed)
        }
        
        context("view is optional") {
            activation = []
            layout(UIView()).active().store(&activation)
            XCTAssertEqual(ViewPrinter(root).description, """
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
        XCTAssertEqual(ViewPrinter(root).description, """
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
        let view = LayoutView().identifying("view")
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        
        var activation = view.layout.active(forceLayout: true)
        
        XCTAssertEqual(view.child.bounds.size, CGSize(width: 90, height: 90))
        XCTAssertEqual(ViewPrinter(view).description, """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                child.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
        }
        """.tabbed)
        
        activation = view.layout.update(fromActivation: activation, forceLayout: true)

        XCTAssertEqual(view.root.count(view.child), 1)
        XCTAssertEqual(view.root.count(view.friend), 0)
        XCTAssertEqual(ViewPrinter(view).description, """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                child.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
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
        XCTAssertEqual(ViewPrinter(view).description, """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                friend.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
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
        
        let root = MockView().identifying("root")
        let child = UIView().identifying("child")
        let friend = UILabel().identifying("friend")
        
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
        let group1_1 = UIView().identifying("group1_1")
        let group1_2 = UIView().identifying("group1_2")
        let group1_3 = UIView().identifying("group1_3")
        let group2_1 = UIView().identifying("group2_1")
        let group2_2 = UIView().identifying("group2_2")
        
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
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root {
            group1_1.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
            group1_2.anchors {
                Anchors.top.equalTo(group1_1, attribute: .bottom)
                Anchors.leading.trailing
            }
            group1_3.anchors {
                Anchors.top.equalTo(group1_1, attribute: .bottom)
                Anchors.leading.equalToSuper(constant: 8.0)
                Anchors.trailing.equalToSuper(constant: -8.0)
            }
            group2_1.anchors {
                Anchors.top.equalTo(group1_3, attribute: .bottom)
                Anchors.leading.equalToSuper(constant: 12.0)
                Anchors.trailing.equalToSuper(constant: -12.0)
            }
            group2_2.anchors {
                Anchors.top.equalTo(group2_2, attribute: .bottom)
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed)
    }
}

// MARK: - ModularLayout

extension LayoutDSLTests {
    struct Module1: ModularLayout {
        let module1view1 = UIView().identifying("module1view1")
        let module1view2 = UIView().identifying("module1view2")
        let module1view3 = UIView().identifying("module1view3")
        
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
        let module2view1 = UIView().identifying("module2view1")
        let module2view2 = UIView().identifying("module2view2")
        let module2view3 = UIView().identifying("module2view3")
        
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
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root {
            module1view1.anchors {
                Anchors.top
                Anchors.leading
                Anchors.width.height.equalToSuper().multiplier(0.5)
            }.sublayout {
                module1view2.anchors {
                    Anchors.leading
                    Anchors.width.height.equalTo(constant: 50.0)
                    Anchors.centerY
                }
            }
            module1view3.anchors {
                Anchors.bottom
                Anchors.leading
                Anchors.height.equalTo(constant: 20.0)
            }
            module2view1.anchors {
                Anchors.top
                Anchors.trailing
                Anchors.width.height.equalToSuper().multiplier(0.5)
            }.sublayout {
                module2view2.anchors {
                    Anchors.trailing
                    Anchors.width.height.equalTo(constant: 50.0)
                    Anchors.centerY
                }
            }
            module2view3.anchors {
                Anchors.bottom
                Anchors.trailing
                Anchors.height.equalTo(constant: 20.0)
            }
        }
        """.tabbed)
    }
}
