//
//  ConstraintTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class ConstraintTests: XCTestCase {

    override func setUpWithError() throws {
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
//                builder.top.equal.to.top.of(root)
            }
        }
        
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, ConstraintLayout<UIView, Array<Binding>>>")
    }
    
}
