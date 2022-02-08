//
//  AnchorsTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class AnchorsTests: XCTestCase {
    
    var deactivatable: AnyDeactivatable = .init()
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    var red = UIView().viewTag.red
    var blue = UIView().viewTag.blue
    var green = UIView().viewTag.green
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        red = UIView().viewTag.red
        blue = UIView().viewTag.blue
        green = UIView().viewTag.green
    }
    
    override func tearDownWithError() throws {
        deactivatable.deactive()
    }
    
    func testAnchorConstraint() {
        let root = UIView()
        let child = UIView()
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = Anchors(.top, .leading, .trailing, .bottom).constraints(item: child, toItem: root)
        
        NSLayoutConstraint.activate(constraints)
        
        root.frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 200, height: 200))
        root.removeConstraints(constraints)
        
        let constraints1 = Anchors(.top, .leading).constraints(item: child, toItem: root)
        let constraints2 = Anchors(.width, .height).equalTo(constant: 98).constraints(item: child, toItem: root)
        
        NSLayoutConstraint.activate(constraints1)
        NSLayoutConstraint.activate(constraints2)
        
        root.setNeedsLayout()
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 98, height: 98))
    }
    
    func testConstraintWithAnchors() {
        root.addSubview(child)
        root.addSubview(red)
        
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: root.topAnchor),
            child.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: red.leadingAnchor),
            child.bottomAnchor.constraint(equalTo: root.bottomAnchor),
            red.topAnchor.constraint(equalTo: root.topAnchor),
            red.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            red.bottomAnchor.constraint(equalTo: root.bottomAnchor)
        ])
       
        // root가 constraint를 다 가져감
        XCTAssertEqual(root.constraints.count, 7)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .trailing, toItem: red, toAttribute: .leading).first, root.constraints.description)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(red, firstAttribute: attr, toItem: root).first)
        }
    }
    
    func testConstraintDSL() {
        deactivatable = root {
            child.anchors {
                Anchors(.top, .leading, .bottom)
                Anchors.trailing.equalTo(red, attribute: .leading)
            }
            red.anchors {
                Anchors(.top, .trailing, .bottom)
            }
        }.active()
        
        // root가 constraint를 다 가져감
        XCTAssertEqual(root.constraints.count, 7)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .trailing, toItem: red, toAttribute: .leading).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(red, firstAttribute: attr, toItem: root).first)
        }
    }
    
    func testLayoutInConstraint() {
        deactivatable = root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.subviews {
                red.anchors {
                    Anchors(.centerX, .centerY)
                }
            }
        }.active()
        
        XCTAssertEqual(red.superview, child)
        XCTAssertEqual(child.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        print(root.constraints)
        XCTAssertNotNil(child.constraints.filter(red, firstAttribute: .centerX, toItem: child).first)
        XCTAssertNotNil(child.constraints.filter(red, firstAttribute: .centerY, toItem: child).first)
    }
    
}

extension Collection where Element: NSLayoutConstraint {
    func filter(_ item: NSObject, firstAttribute: NSLayoutConstraint.Attribute,
                relation: NSLayoutConstraint.Relation = .equal,
                toItem: NSObject?, toAttribute: NSLayoutConstraint.Attribute? = nil) -> [Element] {
        filter { constraint in
            guard constraint.relation == relation else { return false }
            if let toItem = toItem {
                guard constraint.firstAttribute == firstAttribute else { return false }
                guard constraint.secondAttribute == toAttribute ?? firstAttribute else { return false }
                return item.isEqual(constraint.firstItem) && toItem.isEqual(constraint.secondItem)
            } else {
                guard constraint.firstAttribute == firstAttribute else { return false }
                return item.isEqual(constraint.firstItem)
            }
            
        }
    }
}
