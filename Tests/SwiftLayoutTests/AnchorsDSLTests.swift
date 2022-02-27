import XCTest
import UIKit
import SwiftLayout

/// test cases for constraint DSL syntax
final class AnchorsDSLTests: XCTestCase {
        
    var root: UIView = UIView().viewTag.root
    var red: UIView = UIView().viewTag.red
    var blue: UIView = UIView().viewTag.blue
    
    var deactivable: Deactivable?
    
    override func setUp() {
        root = UIView().viewTag.root
        red = UIView().viewTag.red
        blue = UIView().viewTag.red
    }
    
    override func tearDown() {
        deactivable = nil
    }
}

extension AnchorsDSLTests {
    func testAnchors() {
        deactivable = root {
            red.anchors {
                Anchors(.top, .leading, .bottom)
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
    
    func testLayoutAfterAnchors() {
        deactivable = root {
            red.anchors {
                Anchors.allSides()
            }.sublayout {
                blue.anchors {
                    Anchors(.centerX, .centerY)
                }
            }
        }.active()
        
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(red.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (blue, red), attributes: (.centerX, .centerX)).first)
        XCTAssertNotNil(root.findConstraints(items: (blue, red), attributes: (.centerY, .centerY)).first)
    }
    
    func testAnchorsEitherTrue() {
        let toggle = true
        
        deactivable = root {
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
        
        deactivable = root {
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

        deactivable = root {
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

        deactivable = root.anchors {
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
        deactivable = root {
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
        deactivable = root.anchors {
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
        deactivable = root.anchors {
            Anchors.allSides("label")
        }.sublayout {
            UILabel().identifying("label")
        }.active()
        
        let label = deactivable?.viewForIdentifier("label")
        
        XCTAssertEqual(root.subviews, [label])
        XCTAssertEqual(label?.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing] {
            XCTAssertNotNil(root.findConstraints(items: (root, label), attributes: (attr, attr)).first)
        }
    }
}

extension AnchorsDSLTests {
    func testAnchorsOfDimensionToItem1() {
        root {
            red.anchors {
                Anchors.allSides()
            }
        }.finalActive()
        
        XCTAssertEqual(root.constraints.count, 4)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(red.bounds.size, .init(width: 100, height: 100))
    }
    
    func testAnchorsOfDimensionToItem2() {
        deactivable = root {
            red.anchors {
                Anchors(.bottom, .trailing)
                Anchors(.width, .height).equalTo(constant: 30)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 2)
        XCTAssertEqual(red.constraints.count, 2)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(red.frame, .init(x: 70, y: 70, width: 30, height: 30))
    }
    
    func testConvenience() {
        deactivable = root {
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
        deactivable = root {
            red.anchors {
                Anchors(.top).equalTo(root.topAnchor)
                Anchors(.leading).equalTo(root.leadingAnchor)
                Anchors(.trailing).equalTo(root.trailingAnchor).setConstant(-14.0)
                Anchors(.bottom).equalTo(root.bottomAnchor)
                Anchors(.width).equalTo(root.widthAnchor)
                Anchors(.height).equalTo(root.heightAnchor)
                Anchors(.centerX).equalTo(root.centerXAnchor)
                Anchors(.centerY).equalTo(root.centerYAnchor)
            }
        }.active()
        
        let expect = """
        root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .width, .height, .centerX, .centerY)
                Anchors(.trailing).equalTo(constant: -14.0)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testAnchorsGreaterThanOrEqualToUILayoutAnchor() {
        
        deactivable = root {
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
        
        deactivable = root {
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
