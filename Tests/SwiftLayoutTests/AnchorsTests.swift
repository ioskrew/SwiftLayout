//
//  AnchorsTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class AnchorsTests: XCTestCase {
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
            XCTAssertNotNil(root.findConstraints(items: (child, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (child, red), attributes: (.trailing, .leading)).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
    }
    
    func testSelfContraint() {
        let superview = UIView().viewTag.superview
        let subview = UIView().viewTag.subview
        
        let constraint = subview.widthAnchor.constraint(equalToConstant: 24)
        
        XCTAssertEqual(constraint.firstItem as? NSObject, subview)
        XCTAssertNil(constraint.secondItem)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)
        XCTAssertEqual(constraint.constant, 24)
        
        let anchor = Anchors(.width).equalTo(constant: 24).constraints(item: subview, toItem: superview).first!
        
        XCTAssertEqual(anchor.firstItem as? NSObject, subview)
        XCTAssertNil(anchor.secondItem)
        XCTAssertEqual(anchor.firstAttribute, .width)
        XCTAssertEqual(anchor.secondAttribute, .notAnAttribute)
        XCTAssertEqual(anchor.constant, 24)
    }
    
    func testAnchorsBuilder() {
        func build(@AnchorsBuilder _ build: () -> [Constraint]) -> [Constraint] {
            build()
        }
        
        let anchors: some Constraint = build {
            Anchors(.top).equalTo(constant: 12.0)
            Anchors(.leading).equalTo(constant: 13.0)
            Anchors(.trailing).equalTo(constant: -13.0)
            Anchors(.bottom)
        }
        
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        child.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(child)
        
        let constraint = anchors.constraints(item: child, toItem: root)
        XCTAssertEqual(constraint.count, 4)
    }
    
}
