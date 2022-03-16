import XCTest
import SwiftLayout
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// test cases for constraint DSL syntax
final class AnchorsDSLTests: XCTestCase {
        
    var root: SLView = SLView().viewTag.root
    var red: SLView = SLView().viewTag.red
    var blue: SLView = SLView().viewTag.blue
    
    var constant: CGFloat = 0.0
    
    var activation: Activation?
    
    override func setUp() {
        root = SLView(frame: .init(x: 0, y: 0, width: 120, height: 120)).viewTag.root
        red = SLView().viewTag.red
        blue = SLView().viewTag.blue
        constant = CGFloat.random(in: -5...5)
        continueAfterFailure = false
    }
    
    override func tearDown() {
        activation = nil
    }
    
    var constantDescription: String {
        if constant < 0 {
            return "- \(abs(constant).description)"
        } else if constant > 0 {
            return "+ \(abs(constant).description)"
        } else {
            return ""
        }
    }
    
}

extension AnchorsDSLTests {
    func testAnchorsEqualToSuperview() {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing, .left, .right, .centerX, .centerY, .width, .height, .firstBaseline, .lastBaseline]
        for attribute in attributes {
            context("anchor for \(attribute.description) \(constantDescription)") {
                root {
                    red.anchors {
                        Anchors(attribute).setConstant(constant)
                    }
                }.finalActive()
                
                XCTAssertEqual(root.constraints.shortDescription, """
                red.\(attribute.description) == root.\(attribute.description) \(constantDescription)
                """)
            }
        }
        
        #if canImport(UIKit)
        context("anchor for ") {
            let attributes: [NSLayoutConstraint.Attribute] = [.topMargin, .bottomMargin, .leadingMargin, .trailingMargin, .leftMargin, .rightMargin, .centerXWithinMargins, .centerYWithinMargins]
            for attribute in attributes {
                context("\(attribute.description)  \(constantDescription)") {
                    root {
                        red.anchors {
                            Anchors(attribute).setConstant(constant)
                        }
                    }.finalActive()
                    XCTAssertEqual(root.constraints.shortDescription, """
                    red.\(attribute) == root.\(attribute) \(constantDescription)
                    root.bottom == root.layoutMarginsGuide.bottom + 8.0
                    root.layoutMarginsGuide.left == root.left + 8.0
                    root.right == root.layoutMarginsGuide.right + 8.0
                    root.layoutMarginsGuide.top == root.top + 8.0
                    """)
                }
            }
        }
        #endif
    }
    
    func testAnchorsGreaterThanOrEqualToSuperview() {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing, .left, .right, .centerX, .centerY, .firstBaseline, .lastBaseline]
        for attribute in attributes {
            context("anchor for \(attribute.description) \(constantDescription)") {
                root {
                    red.anchors {
                        Anchors(attribute).greaterThanOrEqualTo(constant: constant)
                    }
                }.finalActive()
                
                XCTAssertEqual(root.constraints.shortDescription, """
                red.\(attribute.description) >= root.\(attribute.description) \(constantDescription)
                """)
            }
        }
        
        context("anchor for width and height") {
            root {
                red.anchors {
                    Anchors(.width, .height).greaterThanOrEqualTo(root, constant: constant)
                }
            }.finalActive()
            
            XCTAssertEqual(root.constraints.shortDescription, """
            red.width >= root.width \(constantDescription)
            red.height >= root.height \(constantDescription)
            """)
        }
        
        #if canImport(UIKit)
        context("anchor for ") {
            let attributes: [NSLayoutConstraint.Attribute] = [.topMargin, .bottomMargin, .leadingMargin, .trailingMargin, .leftMargin, .rightMargin, .centerXWithinMargins, .centerYWithinMargins]
            for attribute in attributes {
                context(attribute.description) {
                    root {
                        red.anchors {
                            Anchors(attribute).greaterThanOrEqualTo().setConstant(constant)
                        }
                    }.finalActive()
                    XCTAssertEqual(root.constraints.shortDescription, """
                    red.\(attribute) >= root.\(attribute) \(constantDescription)
                    root.bottom == root.layoutMarginsGuide.bottom + 8.0
                    root.layoutMarginsGuide.left == root.left + 8.0
                    root.right == root.layoutMarginsGuide.right + 8.0
                    root.layoutMarginsGuide.top == root.top + 8.0
                    """)
                }
            }
        }
        #endif
    }
    
    func testAnchorsLessThanOrEqualToSuperview() {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing, .left, .right, .centerX, .centerY, .firstBaseline, .lastBaseline]
        for attribute in attributes {
            context("anchor for \(attribute.description)") {
                root {
                    red.anchors {
                        Anchors(attribute).lessThanOrEqualTo().setConstant(constant)
                    }
                }.finalActive()
                
                XCTAssertEqual(root.constraints.shortDescription, """
                red.\(attribute.description) <= root.\(attribute.description) \(constantDescription)
                """)
            }
        }
        
        context("anchor for width and height") {
            root {
                red.anchors {
                    Anchors(.width, .height).lessThanOrEqualTo(root, constant: constant)
                }
            }.finalActive()
            
            XCTAssertEqual(root.constraints.shortDescription, """
            red.width <= root.width \(constantDescription)
            red.height <= root.height \(constantDescription)
            """)
        }
        
        #if canImport(UIKit)
        context("anchor for ") {
            let attributes: [NSLayoutConstraint.Attribute] = [.topMargin, .bottomMargin, .leadingMargin, .trailingMargin, .leftMargin, .rightMargin, .centerXWithinMargins, .centerYWithinMargins]
            for attribute in attributes {
                context(attribute.description) {
                    root {
                        red.anchors {
                            Anchors(attribute).lessThanOrEqualTo().setConstant(constant)
                        }
                    }.finalActive()
                    XCTAssertEqual(root.constraints.shortDescription, """
                    red.\(attribute) <= root.\(attribute) \(constantDescription)
                    root.bottom == root.layoutMarginsGuide.bottom + 8.0
                    root.layoutMarginsGuide.left == root.left + 8.0
                    root.right == root.layoutMarginsGuide.right + 8.0
                    root.layoutMarginsGuide.top == root.top + 8.0
                    """)
                }
            }
        }
        #endif
    }
    
    func testAnchorsInSublayout() {
        root {
            red.anchors {
                Anchors.allSides()
            }.sublayout {
                blue.anchors {
                    Anchors(.centerX, .centerY)
                }
            }
        }.finalActive()
        
        XCTAssertEqual(root.constraints.shortDescription, """
        red.top == root.top
        red.bottom == root.bottom
        red.leading == root.leading
        red.trailing == root.trailing
        """)
        XCTAssertEqual(red.constraints.shortDescription, """
        blue.centerX == red.centerX
        blue.centerY == red.centerY
        """)
    }
    
    func testAnchorsEitherTrue() {
        let toggle = true
        
        activation = root {
            red.anchors {
                if toggle {
                    Anchors.cap()
                    Anchors(.bottom).equalTo(blue, attribute: .top)
                } else {
                    Anchors.shoe()
                    Anchors(.top).equalTo(blue, attribute: .bottom)
                }
            }
            blue.anchors {
                if toggle {
                    Anchors.shoe()
                } else {
                    Anchors.cap()
                }
            }
        }.active()
        
        XCTAssertEqual(root.subviews, [red, blue])
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)

        XCTAssertEqual(root.constraints.count, 7)

        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.top, .top)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.trailing, .trailing)).count, 1)

        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.bottom, .bottom)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.trailing, .trailing)).count, 1)
    }
    
    func testAnchorsEitherFalse() {
        let toggle = false
        
        activation = root {
            red.anchors {
                if toggle {
                    Anchors.cap()
                    Anchors(.bottom).equalTo(blue, attribute: .top)
                } else {
                    Anchors.shoe()
                    Anchors(.top).equalTo(blue, attribute: .bottom)
                }
            }
            blue.anchors {
                if toggle {
                    Anchors.shoe()
                } else {
                    Anchors.cap()
                }
            }
        }.active()
        
        XCTAssertEqual(root.subviews, [red, blue])
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)

        XCTAssertEqual(root.constraints.count, 7)

        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.top, .top)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.trailing, .trailing)).count, 1)

        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.bottom, .bottom)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.trailing, .trailing)).count, 1)
    }
    
    func testOptionalAnchors() {
        let optionalAnchor: Anchors? = Anchors(.trailing).equalTo(blue, attribute: .leading)
        let nilAnchor: Anchors? = nil

        activation = root {
            red.anchors {
                Anchors(.top, .leading, .bottom)
                optionalAnchor
            }
            blue.anchors {
                Anchors(.top, .trailing, .bottom)
                nilAnchor
            }
        }.active()

        XCTAssertEqual(root.subviews, [red, blue])
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)

        // root takes all constraints
        XCTAssertEqual(root.constraints.count, 7)

        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (red, blue), attributes: (.trailing, .leading)).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (blue, root), attributes: (attr, attr)).first)
        }
    }
    
    func testAnchorsWithForIn() {
        let attributes: [NSLayoutConstraint.Attribute] = [
            .top,
            .bottom,
            .leading,
            .trailing
        ]

        activation = root.anchors {
            for attr in attributes {
                Anchors(attr).equalTo(red)
            }
        }.sublayout {
            red
        }.active()
        
        XCTAssertEqual(root.subviews, [red])
        XCTAssertEqual(red.superview, root)
        
        for attr in attributes {
            XCTAssertNotNil(root.findConstraints(items: (root, red), attributes: (attr, attr)).first)
        }
    }
    
    func testAnchorsFromSeperately() {
        activation = root {
            red.anchors {
                Anchors.cap()
            }
            blue.anchors {
                Anchors.shoe()
            }
            red.anchors {
                Anchors(.bottom).equalTo(blue, attribute: .top)
            }
        }.active()
        
        XCTAssertEqual(root.subviews, [red, blue])
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)
        
        XCTAssertEqual(root.constraints.count, 7)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (red, blue), attributes: (.bottom, .top)).first)
        for attr in [NSLayoutConstraint.Attribute.leading, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (blue, root), attributes: (attr, attr)).first)
        }
    }
    
    func testAnchorsFromLayoutGuide() {
        activation = root.anchors {
            Anchors.allSides(red.safeAreaLayoutGuide)
        }.sublayout {
            red
        }.active()
        
        XCTAssertEqual(root.subviews, [red])
        XCTAssertEqual(red.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing] {
            XCTAssertNotNil(root.findConstraints(items: (root, red.safeAreaLayoutGuide), attributes: (attr, attr)).first)
        }
    }
    
    func testAnchorsFromIdentifier() {
        activation = root.anchors {
            Anchors.allSides("label")
        }.sublayout {
            UILabel().identifying("label")
        }.active()
        
        let label = activation?.viewForIdentifier("label")
        
        XCTAssertEqual(root.subviews, [label])
        XCTAssertEqual(label?.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing] {
            XCTAssertNotNil(root.findConstraints(items: (root, label), attributes: (attr, attr)).first)
        }
    }
    
    func testDuplicateAnchorBuilder() {
        activation = root {
            red.anchors {
                Anchors(.top, .leading, .bottom)
            }.anchors {
                Anchors(.trailing).equalTo(blue, attribute: .leading)
            }
            blue.anchors {
                Anchors(.top, .trailing, .bottom)
            }
        }.active()
        
        XCTAssertEqual(root.subviews, [red, blue])
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)
        
        // root takes all constraints
        XCTAssertEqual(root.constraints.count, 7)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (red, blue), attributes: (.trailing, .leading)).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (blue, root), attributes: (attr, attr)).first)
        }
    }
}

extension AnchorsDSLTests {
    func testAnchorsOfDimensionToItem1() {
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root {
            red.anchors {
                Anchors.allSides()
            }
        }.finalActive()
        
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertEqual(red.bounds.size, .init(width: 100, height: 100))
    }
    
    func testAnchorsOfDimensionToItem2() {
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        activation = root {
            red.anchors {
                #if canImport(UIKit)
                Anchors(.bottom, .trailing)
                #elseif canImport(AppKit)
                Anchors(.top, .trailing)
                #endif
                Anchors(.width, .height).equalTo(constant: 30)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 2)
        XCTAssertEqual(red.constraints.count, 2)
        XCTAssertEqual(red.frame, .init(x: 70, y: 70, width: 30, height: 30))
    }
    
    func testConvenience() {
        activation = root {
            red.anchors {
                Anchors.allSides(root)
            }
        }.active()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
}

// MARK: - Anchors from UILayoutAnchor
extension AnchorsDSLTests {
    
    func testAnchorsEqualToUILayoutAnchor() {
        activation = root {
            red.anchors {
                Anchors(.top).equalTo(root.topAnchor)
                Anchors(.leading).equalTo(root.leadingAnchor)
                Anchors(.trailing).equalTo(root.trailingAnchor).setConstant(-14.0)
                Anchors(.bottom).equalTo(root.bottomAnchor)
                Anchors(.height).equalTo(root.heightAnchor)
                Anchors(.centerY).equalTo(root.centerYAnchor)
            }
        }.active()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .height, .centerY)
                Anchors(.trailing).equalTo(constant: -14.0)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testAnchorsGreaterThanOrEqualToUILayoutAnchor() {
        
        activation = root {
            red.anchors {
                Anchors(.top).greaterThanOrEqualTo(root.topAnchor)
                Anchors(.leading).greaterThanOrEqualTo(root.leadingAnchor)
                Anchors(.trailing).greaterThanOrEqualTo(root.trailingAnchor)
                Anchors(.bottom).greaterThanOrEqualTo(root.bottomAnchor).setConstant(13.0)
                Anchors(.width).greaterThanOrEqualTo(root.widthAnchor)
                Anchors(.height).greaterThanOrEqualTo(root.heightAnchor)
                Anchors(.centerX).greaterThanOrEqualTo(root.centerXAnchor)
                Anchors(.centerY).greaterThanOrEqualTo(root.centerYAnchor)
            }
        }.active()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .leading, .trailing, .width, .height, .centerX, .centerY).greaterThanOrEqualTo()
                Anchors(.bottom).greaterThanOrEqualTo(constant: 13.0)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testAnchorsLessThanOrEqualToUILayoutAnchor() {
        
        activation = root {
            red.anchors {
                Anchors(.top).lessThanOrEqualTo(root.topAnchor)
                Anchors(.leading).lessThanOrEqualTo(root.leadingAnchor)
                Anchors(.trailing).lessThanOrEqualTo(root.trailingAnchor)
                Anchors(.bottom).lessThanOrEqualTo(root.bottomAnchor)
                Anchors(.width).lessThanOrEqualTo(root.widthAnchor)
                Anchors(.height).lessThanOrEqualTo(root.heightAnchor).setConstant(12.0)
                Anchors(.centerX).lessThanOrEqualTo(root.centerXAnchor)
                Anchors(.centerY).lessThanOrEqualTo(root.centerYAnchor)
            }
        }.active()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .trailing, .width, .centerX, .centerY).lessThanOrEqualTo()
                Anchors(.height).lessThanOrEqualTo(constant: 12.0)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
}
