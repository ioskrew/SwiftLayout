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
        
        let constraint: some Layout = root.constraint {
            
        }
        XCTAssertEqual(typeString(of: constraint), "ConstraintLayout<UIView, Array<Binding>>")
        
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
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, ConstraintLayout<UIView, Array<Binding>>>")
        
        deactivatable = layout.active()
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(root.constraints.count, 6)
        for attrib in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom, .centerX, .centerY] {
            let constraint = root.constraints.first(LayoutConstraint(f: child, fa: attrib, s: root, sa: attrib, relation: .equal))
            XCTAssertNotNil(constraint)
            if let constraint = constraint {
                XCTAssertTrue(constraint.isActive)
            } else {
                XCTFail(constraint.debugDescription)
            }
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
                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
                }
                deactivatable = AnyDeactivatable()
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
                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
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
                    XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
                }
                deactivatable = AnyDeactivatable()
            }
        }
    }
    
}

protocol LayoutConstraintInterface {
    func isEqual(_ interface: LayoutConstraintInterface) -> Bool
    func isEqual(_ constraint: NSLayoutConstraint) -> Bool
}

struct LayoutConstraint<F, S>: LayoutConstraintInterface where F: NSObject, S: NSObject {
    typealias Attribute = NSLayoutConstraint.Attribute
    typealias Relation = NSLayoutConstraint.Relation
    let f: F
    let fa: NSLayoutConstraint.Attribute
    let s: S?
    let sa: NSLayoutConstraint.Attribute
    
    let relation: Relation
    
    func isEqual(_ interface: LayoutConstraintInterface) -> Bool {
        guard let constraint = interface as? Self else { return false }
        return f == constraint.f && s == constraint.s && relation == constraint.relation
    }
    
    func isEqual(_ constraint: NSLayoutConstraint) -> Bool {
        let second = constraint.secondItem as? S
        return f.isEqual(constraint.firstItem) && s == second && relation == constraint.relation
    }
}

extension Collection where Element: NSLayoutConstraint {
    
    func first(_ constraint: LayoutConstraintInterface) -> Element? {
        self.first(where:constraint.isEqual)
    }
    
    func filter(_ constaint: LayoutConstraintInterface) -> [Element] {
        self.filter(constaint.isEqual)
    }
    
}
