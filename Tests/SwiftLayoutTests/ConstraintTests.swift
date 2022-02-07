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
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attrib, relation: .equal, toItem: root))
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
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
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
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
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
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
                }
                deactivatable = AnyDeactivatable()
            }
        }
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
            child.constraint(.top, .leading, .bottom).constraint(.trailing, to: (red, .leading))
            red.constraint(.top, .trailing, .bottom)
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
            child.constraint(.top, .bottom, .leading, .trailing).layout {
                red.constraint(.centerX, .centerY)
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
