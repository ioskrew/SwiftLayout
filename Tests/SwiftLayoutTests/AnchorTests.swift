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
        continueAfterFailure = false
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
            child.bottomAnchor
            child.leadingAnchor
            child.trailingAnchor
        }
        
        deactivatable = layout.active()
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .bottom, s: root, sa: .bottom, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .leading, s: root, sa: .leading, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .trailing, s: root, sa: .trailing, relation: .equal))!.isActive)
        
        deactivatable?.deactive()
        XCTAssertNil(child.superview)
        XCTAssertTrue(root.constraints.isEmpty)
        
        deactivatable = layout.active()
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .top, s: root, sa: .top, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .bottom, s: root, sa: .bottom, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .leading, s: root, sa: .leading, relation: .equal))!.isActive)
        XCTAssertTrue(root.constraints.first(LayoutConstraint(f: child, fa: .trailing, s: root, sa: .trailing, relation: .equal))!.isActive)
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
