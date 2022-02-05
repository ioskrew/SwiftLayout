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

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testConstraintToLayout() {
        
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
   
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
    }
    
}
