import XCTest
import SwiftLayout

/// test cases for DSL syntax
final class LayoutDSLTests: XCTestCase {
    
    var root: SLView = SLView().viewTag.root
    var child: SLView = SLView().viewTag.child
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var red: SLView = SLView().viewTag.red
    var blue: SLView = SLView().viewTag.blue
    var green: SLView = SLView().viewTag.green
    var image: UIImageView = UIImageView().viewTag.image
    
    var activation: Set<Activation> = []
    
    override func setUp() {
        root = SLView().viewTag.root
        child = SLView().viewTag.child
        button = UIButton().viewTag.button
        label = UILabel().viewTag.label
        red = SLView().viewTag.red
        blue = SLView().viewTag.blue
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(printOnlyIdentifier: true), expect)
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(printOnlyIdentifier: true), expect)
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(printOnlyIdentifier: true), expect)
    }
    
    func testAllSides() {
        root {
            red.anchors {
                Anchors.allSides()
            }.sublayout {
                blue.anchors {
                    Anchors.allSides()
                }
            }
        }.active().store(&activation)
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                blue.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
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
        root.updateLayout()
        
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
    
    private final class TestView: SLView, Layoutable {
        lazy var red = SLView().viewTag.red
        lazy var blue = SLView().viewTag.blue
        lazy var green = SLView().viewTag.green
        
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
                Anchors(.height).equalTo(constant: 44.0)
            }
            green.anchors {
                Anchors(.width).equalTo(constant: 88.0)
            }
        }
    }
}


// MARK: - layouts in same first level
extension LayoutDSLTests {
    
    func testUpdateIdentifiers() {
        let container = TestViewContainer()
        
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
        
        XCTAssertEqual(SwiftLayoutPrinter(container.root).print(printOnlyIdentifier: true), expect)
        
        XCTAssertEqual(container.root.slIdentifier, "root")
        XCTAssertEqual(container.red.slIdentifier, "red")
        XCTAssertEqual(container.button.slIdentifier, "button")
        XCTAssertEqual(container.label.slIdentifier, "label")
        XCTAssertEqual(container.blue.slIdentifier, "blue")
        XCTAssertEqual(container.image.slIdentifier, "image")
    }
    
    // This can be a SLViewController or a SLView.
    private final class TestViewContainer {
        let root = SLView()
        let red = SLView()
        let blue = SLView()
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
                    SLView().viewTag.true
                } else {
                    SLView().viewTag.false
                }
            }
        }
        
        context("if true") {
            root = SLView().viewTag.root
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
            root = SLView().viewTag.root
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
                        SLView().viewTag.first
                    case .second:
                        SLView().viewTag.second
                    case .third:
                        SLView().viewTag.third
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
        func layout(_ view: SLView?) -> some Layout {
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
            layout(SLView()).active().store(&activation)
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
                    SLView().identifying("view_\(index)")
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
        
        var activation = view.layout.active()
        
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
        
        activation = view.layout.update(fromActivation: activation)

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
        activation = view.layout.update(fromActivation: activation)
        
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
    
    class MockView: SLView {
        var addSubviewCounts: [SLView: Int] = [:]
        
        func count(_ view: SLView) -> Int {
            addSubviewCounts[view] ?? 0
        }
        
        override func addSubview(_ view: SLView) {
            if let count = addSubviewCounts[view] {
                addSubviewCounts[view] = count + 1
            } else {
                addSubviewCounts[view] = 1
            }
            super.addSubview(view)
        }
    }
    
    class LayoutView: SLView {
        var flag = true
        
        let root = MockView().viewTag.root
        let child = SLView().viewTag.child
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
        let group1_1 = SLView().viewTag.group1_1
        let group1_2 = SLView().viewTag.group1_2
        let group2_1 = SLView().viewTag.group2_1
        let group2_2 = SLView().viewTag.group2_2
        
        root {
            GroupLayout {
                group1_1.anchors {
                    Anchors.cap()
                }
                group1_2.anchors {
                    Anchors(.top).equalTo(group1_1, attribute: .bottom)
                    Anchors.horizontal()
                }
            }
            GroupLayout {
                group2_1.anchors {
                    Anchors(.top).equalTo(group1_2, attribute: .bottom)
                    Anchors.horizontal()
                }
                group2_2.anchors {
                    Anchors(.top).equalTo(group2_2, attribute: .bottom)
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
            group2_1.anchors {
                Anchors(.top).equalTo(group1_2, attribute: .bottom)
                Anchors(.leading, .trailing)
            }
            group2_2.anchors {
                Anchors(.bottom, .leading, .trailing)
                Anchors(.top).equalTo(group2_2, attribute: .bottom)
            }
        }
        """.tabbed)
    }
}
