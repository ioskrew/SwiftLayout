import XCTest
import UIKit
import SwiftLayout

final class AnchorsDSLTest: XCTestCase {
        
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

extension AnchorsDSLTest {
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
                Anchors.boundary
            }.subviews {
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
                    Anchors.cap
                    Anchors(.bottom).equalTo(blue, attribute: .top)
                } else {
                    Anchors.shoe
                    Anchors(.top).equalTo(blue, attribute: .bottom)
                }
            }
            blue.anchors {
                if toggle {
                    Anchors.shoe
                } else {
                    Anchors.cap
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
                    Anchors.cap
                    Anchors(.bottom).equalTo(blue, attribute: .top)
                } else {
                    Anchors.shoe
                    Anchors(.top).equalTo(blue, attribute: .bottom)
                }
            }
            blue.anchors {
                if toggle {
                    Anchors.shoe
                } else {
                    Anchors.cap
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
    
    func testAnchorsWithOptionalNSLayoutAnchor() {
        let optionalConstraint: NSLayoutConstraint? = red.trailingAnchor.constraint(equalTo: blue.leadingAnchor)
        let nilConstraint: NSLayoutConstraint? = nil

        deactivable = root {
            red.anchors {
                Anchors(.top, .leading, .bottom)
                optionalConstraint
            }
            blue.anchors {
                Anchors(.top, .trailing, .bottom)
                nilConstraint
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
        }.subviews {
            red
        }.active()
        
        XCTAssertEqual(root.subviews, [red])
        XCTAssertEqual(red.superview, root)
        
        for attr in attributes {
            XCTAssertNotNil(root.findConstraints(items: (root, red), attributes: (attr, attr)).first)
        }
    }
    
    func testAnchorsFromNSLayoutAnchor() {
        deactivable = root {
            red.anchors {
                Anchors.cap
                red.bottomAnchor.constraint(equalTo: blue.topAnchor)
            }
            blue.anchors {
                Anchors.shoe
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
            Anchors.boundary.equalTo(red.safeAreaLayoutGuide)
        }.subviews {
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
            Anchors.boundary.equalTo("label")
        }.subviews {
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

extension AnchorsDSLTest {
    func testAnchorsOfDimensionToItem1() {
        deactivable = root {
            red.anchors {
                Anchors(.top, .leading)
                Anchors(.width, .height)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 4)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(red.bounds.size, .init(width: 100, height: 100))
    }
    
    func testAnchorsOfDimensionToItem2() {
        deactivable = root {
            red.anchors {
                Anchors(.top, .leading)
                Anchors(.width, .height).equalTo(constant: 80)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 2)
        XCTAssertEqual(red.constraints.count, 2)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(red.bounds.size, .init(width: 80, height: 80))
    }
    
    func testAnchorsOfDimensionToItem3() {
        deactivable = root {
            red.anchors {
                Anchors(.top, .trailing, .bottom)
                Anchors(.width, .height).equalTo(constant: 80)
            }
            blue.anchors {
                Anchors(.trailing).equalTo(red, attribute: .leading)
                Anchors(.top, .bottom)
                Anchors(.width, .height).equalTo(constant: 80)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 6)
        XCTAssertEqual(red.constraints.count, 2)
        XCTAssertEqual(blue.constraints.count, 2)
        
        root.frame = .init(origin: .zero, size: .init(width: 200, height: 80))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(red.frame.origin, .init(x: 120, y: 0))
        XCTAssertEqual(blue.bounds.size, .init(width: 80, height: 80))
        
        XCTAssertEqual(blue.frame.origin, .init(x: 40, y: 0))
        XCTAssertEqual(red.bounds.size, .init(width: 80, height: 80))
    }
    
    func testAnchorsOfDimensionToItem4() {
        deactivable = root {
            red.anchors {
                Anchors(.top, .leading).equalTo(constant: 20)
                Anchors(.trailing, .bottom).equalTo(constant: -20)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 4)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        print(root.constraints)
        XCTAssertEqual(red.frame.size, .init(width: 60, height: 60))
    }
}
