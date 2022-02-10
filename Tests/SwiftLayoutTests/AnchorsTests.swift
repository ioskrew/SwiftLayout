//
//  AnchorsTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class AnchorsTests: XCTestCase {
    
    var deactivatable: Activation = .init()
    
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
            XCTAssertNotNil(root.findConstraints(items: (child, root), attributes: (attr, attr)).first)
        }
        XCTAssertNotNil(root.findConstraints(items: (child, red), attributes: (.trailing, .leading)).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.findConstraints(items: (red, root), attributes: (attr, attr)).first)
        }
    }
    
    func testAnyAnchor() {
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        
        XCTAssertEqual(child.topAnchor.anchorType.attribute, .top)
        XCTAssertEqual(child.leadingAnchor.anchorType.attribute, .leading)
        XCTAssertEqual(child.trailingAnchor.anchorType.attribute, .trailing)
        XCTAssertEqual(child.leftAnchor.anchorType.attribute, .left)
        XCTAssertEqual(child.rightAnchor.anchorType.attribute, .right)
        XCTAssertEqual(child.bottomAnchor.anchorType.attribute, .bottom)
        XCTAssertEqual(child.centerXAnchor.anchorType.attribute, .centerX)
        XCTAssertEqual(child.centerYAnchor.anchorType.attribute, .centerY)
        XCTAssertEqual(child.widthAnchor.anchorType.attribute, .width)
        XCTAssertEqual(child.heightAnchor.anchorType.attribute, .height)
        XCTAssertEqual(child.firstBaselineAnchor.anchorType.attribute, .firstBaseline)
        XCTAssertEqual(child.lastBaselineAnchor.anchorType.attribute, .lastBaseline)
        
        XCTAssertEqual(child.safeAreaLayoutGuide.topAnchor.anchorType.attribute, .top)
        XCTAssertEqual(child.safeAreaLayoutGuide.leadingAnchor.anchorType.attribute, .leading)
        XCTAssertEqual(child.safeAreaLayoutGuide.trailingAnchor.anchorType.attribute, .trailing)
        XCTAssertEqual(child.safeAreaLayoutGuide.leftAnchor.anchorType.attribute, .left)
        XCTAssertEqual(child.safeAreaLayoutGuide.rightAnchor.anchorType.attribute, .right)
        XCTAssertEqual(child.safeAreaLayoutGuide.bottomAnchor.anchorType.attribute, .bottom)
        XCTAssertEqual(child.safeAreaLayoutGuide.centerXAnchor.anchorType.attribute, .centerX)
        XCTAssertEqual(child.safeAreaLayoutGuide.centerYAnchor.anchorType.attribute, .centerY)
        XCTAssertEqual(child.safeAreaLayoutGuide.widthAnchor.anchorType.attribute, .width)
        XCTAssertEqual(child.safeAreaLayoutGuide.heightAnchor.anchorType.attribute, .height)
    }
    
    func testAnyAnchorConstraint() {
        
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.topAnchor.anchorType.constraint(to: root)!,
            child.leadingAnchor.anchorType.constraint(to: root)!,
            child.trailingAnchor.anchorType.constraint(to: root)!,
            child.bottomAnchor.anchorType.constraint(to: root)!,
            child.leftAnchor.anchorType.constraint(to: root)!,
            child.rightAnchor.anchorType.constraint(to: root)!,
            child.centerXAnchor.anchorType.constraint(to: root)!,
            child.centerYAnchor.anchorType.constraint(to: root)!,
            child.widthAnchor.anchorType.constraint(to: root)!,
            child.heightAnchor.anchorType.constraint(to: root)!,
            child.firstBaselineAnchor.anchorType.constraint(to: root)!,
            child.lastBaselineAnchor.anchorType.constraint(to: root)!
        ])
     
        for attribute in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom, .left, .right, .centerX, .centerY, .width, .height, .firstBaseline, .lastBaseline] {
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (attribute, attribute)).count, 1, attribute.debugDescription)
        }
        
    }
    
}
