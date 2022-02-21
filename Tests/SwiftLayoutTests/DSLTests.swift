//
//  DSLIntentionTests.swift
//  
//
//  Created by oozoofrog on 2022/02/08.
//

import Foundation
import XCTest
import SwiftLayout
import UIKit
import SwiftUI

///
/// 이 테스트 케이스에서는 구현이 아닌 인터페이스 혹은
/// 구현을 테스트 합니다.
final class DSLTests: XCTestCase {
    
    var deactivable: Deactivable?
    
    var view: LayoutHostingView!
    var root: UIView!
    var red: UIView!
    var blue: UIView!
    var green: UIView!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        root = UIView().viewTag.root
        red = UIView().viewTag.red
        blue = UIView().viewTag.blue
        green = UIView().viewTag.green
    }
    
    override func tearDownWithError() throws {
    }
    
    
    func testSimple() {
        deactivable = root {
            red
        }.active()
        
        XCTAssertEqual(red.superview, root)
    }
    
    func testSimpleWithSublayout() {
        deactivable = root.subviews({
            red
        }).active()
        
        XCTAssertEqual(red.superview, root)
    }
    
    func testTuple() {
        deactivable = root {
            red
            blue
        }.active()
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, root)
    }
    
    func testSimpleDepth() {
        deactivable = root {
            red {
                blue
            }
        }.active()
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, red)
    }
    
    func testSimpleDepthAndTuple() {
        deactivable = root {
            red {
                blue
                green
            }
        }.active()
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(green.superview, red)
    }
    
    func testSimpleBoundary() {
        deactivable = root {
            red.anchors {
                Anchors.boundary
            }
        }.active()
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertEqual(root.findConstraints(items: (red, root)).weakens, Anchors.boundary.constraints(item: red, toItem: root).weakens)
    }
    
    func testDontTouchRootViewByDeactivation() {
        let old = UIView().viewTag.old
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        view = LayoutHostingView(root {
            red.anchors {
                Anchors.boundary
            }
        })
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        view.deactivable?.deactive()
        
        XCTAssertEqual(root.superview, old)
    }
    
    func testAnchors() {
     
        deactivable = root {
            red.anchors {
                Anchors.boundary
            }
        }.active()
        
        XCTAssertEqual(red.superview, root)
        for attribute in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            let reds = root.findConstraints(items: (red, root),
                                            attributes: (attribute, attribute))
            XCTAssertEqual(reds.count, 1, reds.debugDescription)
        }
    }
    
    func testLayoutAfterAnchors() {
        view = LayoutHostingView(root {
            red.anchors {
                Anchors.boundary
            }.subviews {
                blue.anchors {
                    Anchors.boundary
                }
            }
        })
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(blue.superview, red)
        for attribute in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            let reds = root.findConstraints(items: (red, root),
                                            attributes: (attribute, attribute))
            XCTAssertEqual(reds.count, 1, reds.debugDescription)
            
            let blues = root.findConstraints(items: (blue, red),
                                             attributes: (attribute, attribute))
            XCTAssertEqual(blues.count, 1, blues.debugDescription)
        }
    }
    
    func testAnchorsEitherTrue() {
        
        let toggle = true
        view = LayoutHostingView(root {
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
        })

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
        view = LayoutHostingView(root {
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
        })

        XCTAssertEqual(root.constraints.count, 7)

        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.top, .top)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (blue, root), attributes: (.trailing, .trailing)).count, 1)

        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.bottom, .bottom)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.leading, .leading)).count, 1)
        XCTAssertEqual(root.findConstraints(items: (red, root), attributes: (.trailing, .trailing)).count, 1)
    }
    
    func testConstraintDSL() {
        view = LayoutHostingView(root {
            red.anchors {
                Anchors(.top, .leading, .bottom)
                Anchors(.trailing).equalTo(blue, attribute: .leading)
            }
            blue.anchors {
                Anchors(.top, .trailing, .bottom)
            }
        })
        
        // root가 constraint를 다 가져감
        XCTAssertEqual(root.constraints.count, 7)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (red, blue), attributes: (.trailing, .leading)).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (blue, root), attributes: (attr, attr)).first)
        }
    }
    
    func testLayoutInConstraint() {
        view = LayoutHostingView(root {
            red.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.subviews {
                blue.anchors {
                    Anchors(.centerX, .centerY)
                }
            }
        })
        
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(red.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (blue, red), attributes: (.centerX, .centerX)).first)
        XCTAssertNotNil(root.findConstraints(items: (blue, red), attributes: (.centerY, .centerY)).first)
    }
    
    func testViewLayout() {
        view = LayoutHostingView(root {
            red.anchors {
                Anchors.boundary
            }
        })
        
        root.frame = .init(origin: .zero, size: .init(width: 30, height: 30))
        root.setNeedsLayout()
        root.layoutIfNeeded()

        XCTAssertEqual(root.frame, .init(x: 0, y: 0, width: 30, height: 30))
        XCTAssertEqual(red.frame, .init(x: 0, y: 0, width: 30, height: 30))
    }
    
    func testInitViewInLayout() {
        view = LayoutHostingView(root {
            UILabel().anchors {
                Anchors(.centerX, .centerY)
            }
        })
        
        XCTAssertEqual(root.constraints.count, 2)
    }
    
    func testForIn() {
        let views: [UILabel] = (0..<10).map(\.description).map({
            let label = UILabel()
            label.text = $0.description
            return label
        })
        
        let root = UIView().viewTag.root
        view = LayoutHostingView(root {
            for view in views {
                view
            }
        })
        
        XCTAssertEqual(root.subviews.count, views.count)
        XCTAssertEqual(root.subviews, views)
    }
    
    func testEither() {
        let root = UIView().viewTag.root
        let friendA = UIView().viewTag.friendA
        let friendB = UIView().viewTag.friendB
        
        var chooseA = true
        deactivable = root {
            if chooseA {
                friendA
            } else {
                friendB
            }
        }.active()
        
        XCTAssertEqual(friendA.superview, root)
        XCTAssertNotEqual(friendB.superview, root)
        
        chooseA = false
        
        deactivable = root {
            if chooseA {
                friendA
            } else {
                friendB
            }
        }.active()
        
        XCTAssertNotEqual(friendA.superview, root)
        XCTAssertEqual(friendB.superview, root)
    }
    
    func testAnchorsOfDimensionToItem() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        deactivable = root {
            child.anchors {
                Anchors(.top, .leading)
                Anchors(.width, .height)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 4)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(child.bounds.size, .init(width: 100, height: 100))
    }
    
    func testAnchorsOfDimensionToItem2() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        deactivable = root {
            child.anchors {
                Anchors(.top, .leading)
                Anchors(.width, .height).equalTo(constant: 80)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 2)
        XCTAssertEqual(child.constraints.count, 2)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(child.bounds.size, .init(width: 80, height: 80))
    }
    
    func testAnchorsOfDimensionToItem3() {
        let root = UIView().viewTag.root
        let child1 = UIView().viewTag.child2
        let child2 = UIView().viewTag.child2
        
        deactivable = root {
            child1.anchors {
                Anchors(.top, .trailing, .bottom)
                Anchors(.width, .height).equalTo(constant: 80)
            }
            child2.anchors {
                Anchors(.trailing).equalTo(child1, attribute: .leading)
                Anchors(.top, .bottom)
                Anchors(.width, .height).equalTo(constant: 80)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 6)
        XCTAssertEqual(child1.constraints.count, 2)
        XCTAssertEqual(child2.constraints.count, 2)
        
        root.frame = .init(origin: .zero, size: .init(width: 200, height: 80))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        
        XCTAssertEqual(child1.frame.origin, .init(x: 120, y: 0))
        XCTAssertEqual(child1.bounds.size, .init(width: 80, height: 80))
        
        XCTAssertEqual(child2.frame.origin, .init(x: 40, y: 0))
        XCTAssertEqual(child1.bounds.size, .init(width: 80, height: 80))
    }
    
    func testAnchorsOfDimensionToItem4() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        deactivable = root {
            child.anchors {
                Anchors(.top, .leading).equalTo(constant: 20)
                Anchors(.trailing, .bottom).equalTo(constant: -20)
            }
        }.active()
        
        XCTAssertEqual(root.constraints.count, 4)
        
        root.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        root.setNeedsLayout()
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 60, height: 60))
    }
    
    final class IdentifiedView: UIView, LayoutBuilding {
        
        lazy var contentView: UIView = UIView()
        lazy var nameLabel: UILabel = UILabel()
        
        var deactivable: Deactivable?
        
        var layout: some Layout {
            contentView {
                nameLabel
            }
        }
        
        init(_ options: LayoutOptions = []) {
            super.init(frame: .zero)
            updateLayout(options)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func testNoAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        XCTAssertNil(view.contentView.accessibilityIdentifier)
        XCTAssertNil(view.nameLabel.accessibilityIdentifier)
    }
    
    func testAccessibilityIdentifierOption() {
        let view = IdentifiedView(.automaticIdentifierAssignment)
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel")
    }
    
    func testRules() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        enum TestCase {
            case topEqualToNameless
            case topEqualToSuper
            case topEqualToSuperWithConstant
            case topGreaterThanOrEqualToNameless
            case topGreaterThanOrEqualToSuperWithConstant
            case topGreaterThanOrEqualToSuper
            case topLessThanOrEqualToNameless
            case topLessThanOrEqualToSuper
            case topLessThanOrEqualToSuperWithConstant
            
            case topOfFriendEqualToBottomOfChild
            case widthOfFriendEqualToNameless
            case widthOfFriendEqualToSuper
            case widthOfFriendEqualToChild
            case widthOfFriendEqualToHeightOfChild
            case widthOfFriendEqualToConstant
            case widthOfFriendEqualToChildWithConstant
        }
        
        var test = TestCase.topEqualToNameless
        @LayoutBuilder
        func layout() -> Layout {
            root {
                child.anchors {
                    switch test {
                    case .topEqualToNameless:
                        Anchors(.top)
                    case .topEqualToSuper:
                        Anchors(.top).equalTo(root)
                    case .topEqualToSuperWithConstant:
                        Anchors(.top).equalTo(root, constant: 78.0)
                    case .topGreaterThanOrEqualToNameless:
                        Anchors(.top).greaterThanOrEqualTo()
                    case .topGreaterThanOrEqualToSuper:
                        Anchors(.top).greaterThanOrEqualTo(root)
                    case .topGreaterThanOrEqualToSuperWithConstant:
                        Anchors(.top).greaterThanOrEqualTo(root, constant: 78.0)
                    case .topLessThanOrEqualToNameless:
                        Anchors(.top).lessThanOrEqualTo()
                    case .topLessThanOrEqualToSuper:
                        Anchors(.top).lessThanOrEqualTo(root)
                    case .topLessThanOrEqualToSuperWithConstant:
                        Anchors(.top).lessThanOrEqualTo(root, constant: 78.0)
                    default:
                        Anchors.cap
                    }
                }
                friend.anchors {
                    switch test {
                    case .topOfFriendEqualToBottomOfChild:
                        Anchors(.top).equalTo(child, attribute: .bottom)
                        Anchors.shoe
                    case .widthOfFriendEqualToNameless:
                        Anchors(.width)
                        Anchors.shoe
                    case .widthOfFriendEqualToSuper:
                        Anchors(.width).equalTo(root)
                        Anchors.shoe
                    case .widthOfFriendEqualToChild:
                        Anchors(.width).equalTo(child)
                        Anchors.shoe
                    case .widthOfFriendEqualToHeightOfChild:
                        Anchors(.width).equalTo(child, attribute: .height)
                        Anchors.shoe
                    case .widthOfFriendEqualToConstant:
                        Anchors(.width).equalTo(constant: 78.0)
                        Anchors.shoe
                    case .widthOfFriendEqualToChildWithConstant:
                        Anchors(.width).equalTo(child, constant: 78.0)
                        Anchors.shoe
                    default:
                        Anchors.shoe
                    }
                }
            }
        }
        
        context("top equal to nameless") {
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super") {
            deactivable?.deactive()
            test = .topEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super with constant of 78.0") {
            deactivable?.deactive()
            test = .topEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal, constant: 78.0).count, 1)
        }
        
        context("top greater than or equal to nameless") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }
        
        context("top greater than or equal to nameless with constant of 78.0") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual, constant: 78.0).count, 1)
        }

        context("top greater than or equal to super") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }

        context("top less than or equal to nameless") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }

        context("top less than or equal to super") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }
        
        context("top less than or equal to super with constant of 78.0") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual, constant: 78.0).count, 1)
        }
        
        context("top of friend equal to bottom of child") {
            deactivable?.deactive()
            test = .topOfFriendEqualToBottomOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }
        
        context("top of friend equal to bottom of child") {
            deactivable?.deactive()
            test = .topOfFriendEqualToBottomOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of nameless") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of super") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of child") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to height of child") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToHeightOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .height), relation: .equal).count, 1)
        }
        
        context("width of friend equal to constant of 78.0") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, nil), attributes: (.width, .notAnAttribute), relation: .equal, constant: 78.0).count, 1)
        }
        
        context("width of friend equal to child with constant of 78.0") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToChildWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .width), relation: .equal, constant: 78.0).count, 1)
        }
    }
    
    func testLayoutCanHasMultipleRootLayouts() {
        let a = UIView().viewTag.a
        let child = UIView().viewTag.child
        let b = UIView().viewTag.b
        child.addSubview(b)
        let c = UIView().viewTag.c
        let cchild = UIView().viewTag.cchild
        
        @LayoutBuilder
        func layout() -> Layout {
            a {
                child.anchors {
                    Anchors.boundary
                }
            }
            b.anchors {
                Anchors(.width, .height).equalTo(constant: 120.0)
            }
            c {
                cchild.anchors {
                    Anchors.boundary
                }
            }
        }
        deactivable = layout().active()
        
        XCTAssertEqual(a.constraints.count, 4)
        XCTAssertEqual(b.constraints.count, 2)
        XCTAssertEqual(c.constraints.count, 4)
        
        XCTAssertNil(a.superview)
        XCTAssertEqual(child.superview, a)
        XCTAssertEqual(b.superview, child)
        XCTAssertNil(c.superview)
        XCTAssertEqual(cchild.superview, c)
    }
}

extension Anchors {
    static var boundary: Anchors { .init(.top, .leading, .trailing, .bottom) }
    static var cap: Anchors { .init(.top, .leading, .trailing) }
    static var shoe: Anchors { .init(.leading, .trailing, .bottom) }
}

extension UIView {
    func findConstraints(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute)? = nil, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint] {
        var constraints = self.constraints.filter { constraint in
            constraint.isFit(items: items, attributes: attributes, relation: relation, constant: constant, multiplier: multiplier)
        }
        for subview in subviews {
            constraints.append(contentsOf: subview.findConstraints(items: items, attributes: attributes, relation: relation, constant: constant, multiplier: multiplier))
        }
        return constraints
    }
}

extension NSLayoutConstraint {
    func isFit(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute)? = nil, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> Bool {
        let item = firstItem as? NSObject
        let toItem = secondItem as? NSObject
        return (item, toItem) == items
        && attributes.flatMap({ $0 == (firstAttribute, secondAttribute) }) ?? true
        && self.relation == relation && self.constant == constant && self.multiplier == multiplier
    }
}

class LayoutHostingView: UIView, LayoutBuilding {
    
    let content: AnyLayout
    
    var layout: some Layout {
        content
    }
    
    var deactivable: Deactivable?
    
    init<L: Layout>(_ _content: L) {
        content = _content.anyLayout
        super.init(frame: .zero)
        updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension Collection where Element: CustomHashable {
    var weakens: [WeakReference<Element>] {
        map(WeakReference.init)
    }
}

private final class WeakReference<Origin>: Hashable where Origin: CustomHashable {
    static func == (lhs: WeakReference<Origin>, rhs: WeakReference<Origin>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(origin: Origin? = nil) {
        self.origin = origin
    }
    
    weak var origin: Origin?
    
    func hash(into hasher: inout Hasher) {
        origin?.customHash(&hasher)
    }
}

extension NSLayoutConstraint: CustomHashable {
    func customHash(_ hasher: inout Hasher) {
        hasher.combine(firstItem as? NSObject)
        hasher.combine(firstAttribute)
        hasher.combine(secondItem as? NSObject)
        hasher.combine(secondAttribute)
        hasher.combine(relation)
        hasher.combine(constant)
        hasher.combine(multiplier)
        hasher.combine(priority)
    }
}

extension WeakReference: CustomDebugStringConvertible where Origin: NSLayoutConstraint {
    var debugDescription: String {
        guard let origin = origin else { return "WK constraint: unknown: \(UUID().uuidString)" }
        guard let first = origin.firstItem as? UIView else { return "WK constraint: unknown: \(UUID().uuidString)" }
        if let second = origin.secondItem as? UIView {
            return "WK constraint: \(first.tagDescription) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription)"
        } else if let second = origin.secondItem as? UILayoutGuide {
            return "WK constraint: \(first.tagDescription) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription)"
        } else {
            return "WK constraint: \(first.tagDescription) \(origin.relation)[\(origin.constant)x\(origin.multiplier)]"
        }
    }
}

private struct AddressDescriptor<Object>: CustomStringConvertible where Object: AnyObject {
    let description: String
    
    init(_ object: Object) {
        self.description = Unmanaged<Object>.passUnretained(object).toOpaque().debugDescription + ":\(type(of: object))"
    }
}

private struct TagDescriptor<Value>: CustomDebugStringConvertible where Value: TagDescriptable, Value: AnyObject {
    internal init(_ value: Value) {
        self.value = value
    }
    
    let value: Value
    
    var valueHasIdentifier: Bool {
        value.accessibilityIdentifier != nil
    }
    
    var identifier: String {
        if let identifier = value.accessibilityIdentifier {
            return identifier
        } else {
            return AddressDescriptor(value).description
        }
    }
    
    var debugDescription: String {
        identifier
    }
    
}

private protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
}

private protocol TagDescriptable {
    var accessibilityIdentifier: String? { get }
}

extension TagDescriptable where Self: UIView {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
}

extension TagDescriptable where Self: UILayoutGuide {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
    
    var accessibilityIdentifier: String? { owningView?.accessibilityIdentifier }
}

extension UIView: TagDescriptable {}
extension UILayoutGuide: TagDescriptable {}
