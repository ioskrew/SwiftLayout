import XCTest
import UIKit
import SwiftLayout

/// test cases for DSL syntax
final class LayoutDSLTests: XCTestCase {
    
    var root: UIView = UIView().viewTag.root
    var child: UIView = UIView().viewTag.child
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var red: UIView = UIView().viewTag.red
    var blue: UIView = UIView().viewTag.blue
    var green: UIView = UIView().viewTag.green
    var image: UIImageView = UIImageView().viewTag.image
    
    var deactivable: Set<AnyDeactivable> = []
    
    override func setUp() {
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        button = UIButton().viewTag.button
        label = UILabel().viewTag.label
        red = UIView().viewTag.red
        blue = UIView().viewTag.blue
        image = UIImageView().viewTag.image
    }
    
    override func tearDown() {
        deactivable = []
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
        }.active().store(&deactivable)
        
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
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
        }.active().store(&deactivable)
        
        deactivable = []
        
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
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
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
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
        }.active().store(&deactivable)
        
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
    
    private final class TestView: UIView, LayoutBuilding {
        lazy var red = UIView().viewTag.red
        lazy var blue = UIView().viewTag.blue
        lazy var green = UIView().viewTag.green
        
        var deactivable: Deactivable?
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
        .store(&deactivable)
        
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
        
        XCTAssertEqual(SwiftLayoutPrinter(container.root).print(), expect)
        
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
                deactivable = []
                layout(test).active().store(&deactivable)
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
                    view.identifying("optional")
                }
            }
        }
        
        context("view is nil") {
            deactivable = []
            layout(nil).active().store(&deactivable)
            XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
            root {
                red
            }
            """.tabbed)
        }
        
        context("view is optional") {
            deactivable = []
            layout(UIView()).active().store(&deactivable)
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
        
        layout().active().store(&deactivable)
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            view_0
            view_1
            view_2
        }
        """.tabbed)
    }
    
}

// MARK: GroupLayout

extension LayoutDSLTests {
    func testGroupLayout() {
        let group1_1 = UIView().viewTag.group1_1
        let group1_2 = UIView().viewTag.group1_2
        let group2_1 = UIView().viewTag.group2_1
        let group2_2 = UIView().viewTag.group2_2
        
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
