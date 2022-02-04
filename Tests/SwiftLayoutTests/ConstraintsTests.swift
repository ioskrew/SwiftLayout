//
//  ConstraintsTests.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import XCTest
@testable import SwiftLayout

class ConstraintsTests: XCTestCase {

    var deactivatable: AnyDeactivatable?
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    
    override func setUpWithError() throws {
        root = UIView().viewTag.root
        child = UIView().viewTag.child
    }

    override func tearDownWithError() throws {
        deactivatable = nil
    }

    func testTypeOfConstraints() {
        XCTAssertEqual(typeString(of: root {
            child.topAnchor
        }), "SuperSubLayout<UIView, NSLayoutYAxisAnchor>")
        XCTAssertEqual(typeString(of: root {
            child.topAnchor
            child.bottomAnchor
        }), "SuperSubLayout<UIView, PairLayout<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor>>")
        XCTAssertEqual(typeString(of: root {
            child.topAnchor
            child.bottomAnchor
            child.leadingAnchor
            child.trailingAnchor
        }), "SuperSubLayout<UIView, TupleLayout<(NSLayoutYAxisAnchor, NSLayoutYAxisAnchor, NSLayoutXAxisAnchor, NSLayoutXAxisAnchor)>>")
    }
    
    func testLayoutFromAnchor() {
        let layout: some Layout = root {
            child.topAnchor
        }
        
        deactivatable = layout.active()
        
        XCTAssertEqual(child.superview, root)
        XCTAssertFalse(root.constraints.isEmpty)
        XCTAssertNotNil(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal)))
    }
        
    func testAttributeFromAnchor() {
        XCTAssertEqual(child.topAnchor.attribute, .top)
        XCTAssertEqual(child.bottomAnchor.attribute, .bottom)
        XCTAssertEqual(child.leadingAnchor.attribute, .leading)
        XCTAssertEqual(child.trailingAnchor.attribute, .trailing)
        XCTAssertEqual(child.leftAnchor.attribute, .left)
        XCTAssertEqual(child.rightAnchor.attribute, .right)
        XCTAssertEqual(child.widthAnchor.attribute, .width)
        XCTAssertEqual(child.heightAnchor.attribute, .height)
        XCTAssertEqual(child.centerXAnchor.attribute, .centerX)
        XCTAssertEqual(child.centerYAnchor.attribute, .centerY)
        XCTAssertEqual(child.lastBaselineAnchor.attribute, .lastBaseline)
        XCTAssertEqual(child.firstBaselineAnchor.attribute, .firstBaseline)
        
        let guide = child.safeAreaLayoutGuide
        XCTAssertEqual(guide.topAnchor.attribute, .top)
        XCTAssertEqual(guide.bottomAnchor.attribute, .bottom)
        XCTAssertEqual(guide.leadingAnchor.attribute, .leading)
        XCTAssertEqual(guide.trailingAnchor.attribute, .trailing)
        XCTAssertEqual(guide.leftAnchor.attribute, .left)
        XCTAssertEqual(guide.rightAnchor.attribute, .right)
        XCTAssertEqual(guide.widthAnchor.attribute, .width)
        XCTAssertEqual(guide.heightAnchor.attribute, .height)
        XCTAssertEqual(guide.centerXAnchor.attribute, .centerX)
        XCTAssertEqual(guide.centerYAnchor.attribute, .centerY)
    }
    
//    func testConstraintTop() {
//        let layout: some Layout = root {
//            child
//        }
//
//        let constraint: some Constraint = layout.constraint {
//            child.topAnchor // equal to topAnchor of root
//        }
//
//        deactivatable = constraint.active()
//
//        XCTAssertEqual(child.superview, root)
//
//        let constraints = child.constraints
//        XCTAssertEqual(constraints.count, 1)
//        let top = constraints.first
//        XCTAssertEqual(String(describing: top?.firstItem), String(describing: child))
//        XCTAssertEqual(String(describing: top?.secondItem), String(describing: root))
//        XCTAssertEqual(top?.firstAttribute, .top)
//        XCTAssertEqual(top?.secondAttribute, .top)
//        XCTAssertEqual(top?.relation, .equal)
//        XCTAssertEqual(top?.constant, 0.0)
//        XCTAssertEqual(top?.multiplier, 1.0)
//    }
    
}
//
//typealias Attribute = NSLayoutConstraint.Attribute
//typealias Relation = NSLayoutConstraint.Relation
//
//func XCTAssertConstraint(_ constraint: NSLayoutConstraint,
//                         first: ConstraintPart,
//                         second: ConstraintPart?,
//                         relation: Relation = .equal, file: StaticString = #file, line: UInt = #line) where FirstItem: NSObjectProtocol, SecondItem: NSObjectProtocol {
//    guard constraint.relation == relation else {
//        XCTFail("relation: constraint.\(constraint.relation) != \(relation)", file: file, line: line)
//        return
//    }
//    if let firstItem = constraint.firstItem {
//        guard first.item.isEqual(firstItem) else {
//            XCTFail("first item: constraint.\(firstItem) != \(first.item)", file: file, line: line)
//            return
//        }
//        guard first.attribute == constraint.firstAttribute else {
//            XCTFail("first attribute: constraint.\(constraint.firstAttribute) != \(first.attribute)", file: file, line: line)
//            return
//        }
//    } else {
//        XCTFail("first item is nil", file: file, line: line)
//    }
//    if let second = second {
//        if let secondItem = constraint.secondItem {
//            guard second.item.isEqual(secondItem) else {
//                XCTFail("first item: constraint.\(secondItem) != \(second.item)", file: file, line: line)
//                return
//            }
//            guard second.attribute == constraint.secondAttribute else {
//                XCTFail("first attribute: constraint.\(constraint.secondAttribute) != \(second.attribute)", file: file, line: line)
//                return
//            }
//        } else {
//            XCTFail("second item is nil", file: file, line: line)
//        }
//    }
//}

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
