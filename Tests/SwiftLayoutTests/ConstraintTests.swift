//
//  ConstraintTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class ConstraintTests: XCTestCase {
    
    var deactivatable: AnyDeactivatable = .init()
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        deactivatable.deactive()
    }
    
    func testConstraintToLayout() {
        
        let layout: some Layout = root {
            child.constraint {
                ConstraintBuilder.Binding(firstAttribute: .top, firstItem: child, secondAttribute: .top, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .leading, firstItem: child, secondAttribute: .leading, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .trailing, firstItem: child, secondAttribute: .trailing, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .bottom, firstItem: child, secondAttribute: .bottom, secondItem: root, relation: .equal)
                
                ConstraintBuilder.Binding(firstAttribute: .centerY, firstItem: child, secondAttribute: .centerY, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .centerX, firstItem: child, secondAttribute: .centerX, secondItem: root, relation: .equal)
            }
        }
        
        deactivatable = layout.active()
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(root.constraints.count, 6)
        for attrib in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom, .centerX, .centerY] {
//            let constraint = root.constraints.first(LayoutConstraint(f: child, fa: attrib, s: root, sa: attrib, relation: .equal))
//            XCTAssertNotNil(constraint)
//            if let constraint = constraint {
//                XCTAssertTrue(constraint.isActive)
//            } else {
//                XCTFail(constraint.debugDescription)
//            }
        }
        
        deactivatable.deactive()
        XCTAssertNil(child.superview)
        XCTAssertEqual(root.constraints.count, 0)
    }
    
    func testSyntaticSugarOfBindingForConstraint() {
        context("child의 ConstraintBuilder.Binding의") {
            context("first item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, secondAttribute: .top, secondItem: root)
                    }
                }.active()
                context("first item은 child가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
//                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
                }
                deactivatable = AnyDeactivatable()
                XCTAssertNil(child.superview)
                XCTAssertEqual(child.constraints.count, 0)
            }
            context("first item이 있고, second item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, firstItem: child, secondAttribute: .top)
                    }
                }.active()
                context("second item은 root가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
//                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
                }
                deactivatable = AnyDeactivatable()
            }
            context("first item과 second item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, secondAttribute: .top)
                    }
                }.active()
                context("first item은 child, second item은 root가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
//                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
                }
                deactivatable = AnyDeactivatable()
            }
        }
    }
    
    func testConstraintDSL() {
        let red = UIView().viewTag.red
        let blue = UIView().viewTag.blue
        let green = UIView().viewTag.green
        deactivatable = root {
            child.constraint(.top, .leading, .bottom)
            red.constraint(.leading, toItem: child).constraint(.top, .trailing, .bottom, toItem: root)
        }.active()
        
        XCTAssertEqual(root.constraints.count, 6)
        XCTAssertEqual(child.constraints.count, 4)
        XCTAssertEqual(red.constraints.count, 4)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, relation: .equal, toItem: root).first)
        }
    }
    
}

extension Collection where Element: NSLayoutConstraint {
    func filter(_ item: NSObject, firstAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal,
                toItem: NSObject?) -> [Element] {
        filter { constraint in
            guard constraint.relation == relation else { return false }
            if let toItem = toItem {
                return item.isEqual(constraint.firstItem) && toItem.isEqual(constraint.secondItem)
            } else {
                return item.isEqual(constraint.firstItem)
            }
            
        }
    }
}
