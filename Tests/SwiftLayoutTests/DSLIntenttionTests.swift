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

///
/// 이 테스트 케이스에서는 구현이 아닌 인터페이스 혹은
/// 구현을 테스트 합니다.
final class DSLIntentionsTests: XCTestCase {
    
    var deactivatable: AnyDeactivatable!
    
    var root: UIView!
    var child: UIView!
    var grandchild: UIView!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        grandchild = UIView().viewTag.grandchild
    }
    
    override func tearDownWithError() throws {
        deactivatable?.deactive()
    }
    
    func testAnchors() {
        deactivatable = root {
            child.anchors {
                Anchors.boundary
            }
        }.active()
        
        XCTAssertEqual(child.superview, root)
        for attribute in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            let constraints = root.findConstraints(items: (child, root),
                                                   attributes: (attribute, attribute))
            XCTAssertEqual(constraints.count, 1, constraints.debugDescription)
        }
    }
    
    func testLayoutAfterAnchors() {
        deactivatable = root {
            child.anchors {
                Anchors.boundary
            }.subviews {
                grandchild.anchors {
                    Anchors.boundary
                }
            }
        }.active()
        
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(grandchild.superview, child)
        for attribute in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            let childConstraints = root.findConstraints(items: (child, root),
                                                   attributes: (attribute, attribute))
            XCTAssertEqual(childConstraints.count, 1, childConstraints.debugDescription)
            
            let grandchildConstraints = root.findConstraints(items: (grandchild, child),
                                                   attributes: (attribute, attribute))
            XCTAssertEqual(grandchildConstraints.count, 1, grandchildConstraints.debugDescription)
        }
    }
    
}

extension Anchors {
    static var boundary: Anchors { .init(.top, .leading, .trailing, .bottom) }
}

extension UIView {
    func findConstraints(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute), relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint] {
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
    func isFit(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute), relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> Bool {
        let item = firstItem as? NSObject
        let toItem = secondItem as? NSObject
        return (item, toItem) == items
        && (firstAttribute, secondAttribute) == attributes
        && self.relation == relation && self.constant == constant && self.multiplier == multiplier
    }
}
