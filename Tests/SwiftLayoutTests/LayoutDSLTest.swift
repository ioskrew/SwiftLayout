import XCTest
import UIKit
import SwiftLayout

final class LayoutDSLTest: XCTestCase {
    
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
        blue = UIView().viewTag.red
        image = UIImageView().viewTag.image
    }
    
    override func tearDown() {
        deactivable = []
    }
}

extension LayoutDSLTest {
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
        
        XCTAssertEqual(image.superview, blue)
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(label.superview, red)
        XCTAssertEqual(button.superview, red)
        XCTAssertEqual(red.superview, root)
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
        
        XCTAssertEqual(image.superview, nil)
        XCTAssertEqual(blue.superview, nil)
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(button.superview, nil)
        XCTAssertEqual(red.superview, nil)
    }
    
    func testSimple() {
        root {
            red
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
    }
    
    func testSimpleWithViewConfiguration() {
        root {
            UILabel().config { view in
                view.text = "RED"
                view.accessibilityIdentifier = "red"
            }
        }.active().store(&deactivable)
        
        let red = deactivable.viewForIdentifier("red") as? UILabel
        XCTAssertEqual(red?.superview, root)
        XCTAssertEqual(red?.text, "RED")
    }
    
    func testSimpleWithSublayout() {
        root.sublayout{
            red
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
    }
    
    func testTuple() {
        root {
            red
            blue
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)
    }
    
    func testSimpleDepth() {
        root {
            red {
                blue
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, red)
    }
    
    func testSimpleDepthAndTuple() {
        root {
            red {
                blue
                green
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(green.superview, red)
    }
    
    func testSimpleBoundary() {
        root {
            red.anchors {
                Anchors.allSides()
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertEqual(Weakens(root.findConstraints(items: (red, root))), Weakens(Anchors.allSides().constraints(item: red, toItem: root)))
    }
    
    func testDontTouchRootViewByDeactive() {
        let old = UIView().viewTag.old
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        root {
            red.anchors {
                Anchors.allSides()
            }
        }.active().store(&deactivable)
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        
        deactivable = []
        
        XCTAssertEqual(root.superview, old)
    }
    
    func testLayoutIfWithTrueFlag() {
        let flag = true
        
        root {
            red {
                button
            }
            
            if flag {
                label
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, root)
    }
    
    func testLayoutIfWithFalseFlag() {
        let flag = false
        
        root {
            red {
                button
            }
            
            if flag {
                label
                UILabel()
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 1)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, nil)
    }
    
    func testLayoutEitherWithTrueFlag() {
        let flag = true
        
        root {
            red {
                button
            }
            
            if flag {
                label
            } else {
                image
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, root)
        XCTAssertEqual(image.superview, nil)
    }
    
    func testLayoutEitherWithFalseFlag() {
        let flag = false
        
        root {
            red {
                button
            }
            
            if flag {
                label
                UILabel()
            } else {
                image
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(image.superview, root)
    }
    
    func testLayoutWithOptionalViews() {
        let optionalView: UIView? = UIView().viewTag.optionalView
        let nilView: UIView? = nil
        
        root {
            red {
                button
            }
            
            optionalView
            nilView
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(optionalView?.superview, root)
        XCTAssertEqual(nilView?.superview, nil)
    }
    
    func testLayoutWithForIn() {
        let views: [UILabel] = (0..<10).map(\.description).map {
            let label = UILabel()
            label.text = $0.description
            return label
        }
        
        root {
            for view in views {
                view
            }
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, views.count)
        XCTAssertEqual(root.subviews, views)
    }
    
    func testLayoutWithInstantView() {
        root {
            UILabel()
            UIImageView()
        }.active().store(&deactivable)
        
        XCTAssertEqual(root.subviews.count, 2)
    }
    
    func testFeatureCompose() {
        deactivable = []
        root.config({ root in
            root.backgroundColor = .yellow
        }).identifying("root").anchors({ }).sublayout {
            UILabel().config({ label in
                label.text = "hello"
            }).identifying("child").anchors {
                Anchors.allSides()
            }
        }.active().store(&deactivable)
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testFeatureComposeComplex() {
        root.config({ root in
            root.backgroundColor = .yellow
        }).sublayout {
            UILabel().config { label in
                label.text = "HELLO"
            }.identifying("hellolabel").anchors {
                Anchors.cap()
            }.sublayout {
                UIView().identifying("lastview").anchors {
                    Anchors.allSides()
                }
            }
            UIButton().identifying("button").anchors {
                Anchors.shoe()
            }
        }.active().store(&deactivable)
        
        let expect = """
        root {
            hellolabel.anchors {
                Anchors(.top, .leading, .trailing)
            }.sublayout {
                lastview.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
            button.anchors {
                Anchors(.bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
}

// MARK: - LayoutBuilding in LayoutBuilding
extension LayoutDSLTest {
    
    class Child: UIView, LayoutBuilding {
        
        var showName: Bool = false {
            didSet {
                updateLayout()
            }
        }
        lazy var button = UIButton()
        lazy var name = UILabel()
        
        var deactivable: Deactivable?
        var layout: some Layout {
            self {
                if showName {
                    name.anchors {
                        Anchors(.centerX, .centerY)
                    }
                } else {
                    button.anchors {
                        Anchors(.centerX, .centerY)
                    }
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            updateLayout()
        }
    }
    
    class First: UIView, LayoutBuilding {
        
        lazy var label = UILabel()
        lazy var child = Child()
        
        var deactivable: Deactivable?
        var layout: some Layout {
            self {
                label.anchors {
                    Anchors.cap()
                    Anchors(.height).setMultiplier(multiplier)
                }
                child.anchors {
                    Anchors(.top).equalTo(label, attribute: .bottom)
                    Anchors.shoe()
                }
            }
        }
        
        var multiplier: CGFloat = 1.0
        
        convenience init(multiplier: CGFloat) {
            self.init(frame: .zero)
            self.multiplier = multiplier
            updateLayout()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            updateLayout()
        }
    }
    
    
    func testLayoutBuildingInRelation() {
        
        let first = First(multiplier: 0.75)
        
        context("check multiplier setting") {
            
            let printer = SwiftLayoutPrinter(first,
                                             tags: [first: "first"],
                                             options: .automaticIdentifierAssignment)
            let expect = """
            first {
                label.anchors {
                    Anchors(.top, .leading, .trailing)
                    Anchors(.height).setMultiplier(0.75)
                }
                child.anchors {
                    Anchors(.top).equalTo(label, attribute: .bottom)
                    Anchors(.bottom, .leading, .trailing)
                }.sublayout {
                    button.anchors {
                        Anchors(.centerX, .centerY)
                    }
                }
            }
            """.tabbed
            
            XCTAssertEqual(printer.print(), expect)
        }
        
        context("child has name label") {
            first.child.showName.toggle()
            let printer = SwiftLayoutPrinter(first, tags: [first: "first"], options: .automaticIdentifierAssignment)
            let expect = """
            first {
                label.anchors {
                    Anchors(.top, .leading, .trailing)
                    Anchors(.height).setMultiplier(0.75)
                }
                child.anchors {
                    Anchors(.top).equalTo(label, attribute: .bottom)
                    Anchors(.bottom, .leading, .trailing)
                }.sublayout {
                    name.anchors {
                        Anchors(.centerX, .centerY)
                    }
                }
            }
            """.tabbed
            
            XCTAssertEqual(printer.print(), expect)
        }
    }
}
