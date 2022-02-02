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
        let layout: some Layout = root {
            child
        }
        
        let top: some Constraint = layout.constraint {
            child.topAnchor
        }
        
        XCTAssertEqual(typeString(of: top), "")
    }
    
}

typealias Attribute = NSLayoutConstraint.Attribute
typealias Relation = NSLayoutConstraint.Relation
struct ConstraintItem<Item> where Item: NSObjectProtocol {
    let item: Item
    let attribute: Attribute
}
func XCTAssertConstraint<FirstItem, SecondItem>(_ constraint: NSLayoutConstraint,
                                                first: ConstraintItem<FirstItem>,
                                                second: ConstraintItem<SecondItem>?,
                                                relation: Relation = .equal, file: StaticString = #file, line: UInt = #line) where FirstItem: NSObjectProtocol, SecondItem: NSObjectProtocol {
    guard constraint.relation == relation else {
        XCTFail("relation: constraint.\(constraint.relation) != \(relation)", file: file, line: line)
        return
    }
    if let firstItem = constraint.firstItem {
        guard first.item.isEqual(firstItem) else {
            XCTFail("first item: constraint.\(firstItem) != \(first.item)", file: file, line: line)
            return
        }
        guard first.attribute == constraint.firstAttribute else {
            XCTFail("first attribute: constraint.\(constraint.firstAttribute) != \(first.attribute)", file: file, line: line)
            return
        }
    } else {
        XCTFail("first item is nil", file: file, line: line)
    }
    if let second = second {
        if let secondItem = constraint.secondItem {
            guard second.item.isEqual(secondItem) else {
                XCTFail("first item: constraint.\(secondItem) != \(second.item)", file: file, line: line)
                return
            }
            guard second.attribute == constraint.secondAttribute else {
                XCTFail("first attribute: constraint.\(constraint.secondAttribute) != \(second.attribute)", file: file, line: line)
                return
            }
        } else {
            XCTFail("second item is nil", file: file, line: line)
        }
    }
}

extension Attribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left:
            return "NSLayoutConstraint.Attribute.left"
        case .right:
            return "NSLayoutConstraint.Attribute.right"
        case .top:
            return "NSLayoutConstraint.Attribute.top"
        case .bottom:
            return "NSLayoutConstraint.Attribute.bottom"
        case .leading:
            return "NSLayoutConstraint.Attribute.leading"
        case .trailing:
            return "NSLayoutConstraint.Attribute.trailing"
        case .width:
            return "NSLayoutConstraint.Attribute.width"
        case .height:
            return "NSLayoutConstraint.Attribute.height"
        case .centerX:
            return "NSLayoutConstraint.Attribute.centerX"
        case .centerY:
            return "NSLayoutConstraint.Attribute.centerY"
        case .lastBaseline:
            return "NSLayoutConstraint.Attribute.lastBaseline"
        case .firstBaseline:
            return "NSLayoutConstraint.Attribute.firstBaseline"
        case .leftMargin:
            return "NSLayoutConstraint.Attribute.leftMargin"
        case .rightMargin:
            return "NSLayoutConstraint.Attribute.rightMargin"
        case .topMargin:
            return "NSLayoutConstraint.Attribute.topMargin"
        case .bottomMargin:
            return "NSLayoutConstraint.Attribute.bottomMargin"
        case .leadingMargin:
            return "NSLayoutConstraint.Attribute.leadingMargin"
        case .trailingMargin:
            return "NSLayoutConstraint.Attribute.trailingMargin"
        case .centerXWithinMargins:
            return "NSLayoutConstraint.Attribute.centerXWithinMargins"
        case .centerYWithinMargins:
            return "NSLayoutConstraint.Attribute.centerYWithinMargins"
        case .notAnAttribute:
            return "NSLayoutConstraint.Attribute.notAnAttribute"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}

extension Relation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lessThanOrEqual:
            return "NSLayoutConstraint.Attribute.lessThanOrEqual"
        case .equal:
            return "NSLayoutConstraint.Attribute.equal"
        case .greaterThanOrEqual:
            return "NSLayoutConstraint.Attribute.greaterThanOrEqual"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}
