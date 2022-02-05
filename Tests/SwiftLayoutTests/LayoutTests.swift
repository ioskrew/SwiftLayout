//
//  LayoutTests.swift
//  
//
//  Created by oozoofrog on 2022/02/05.
//

import Foundation
import XCTest
@testable import SwiftLayout

final class LayoutTests: XCTestCase {

    var root = UIView()
    var child = UIView()
    var grandChild1 = UIView()
    var grandChild2 = UIView()
    
    override func setUp() {
        root = UIView()
        child = UIView()
        grandChild1 = UIView()
        grandChild2 = UIView()
    }
    
    override func tearDown() {
        
    }
    
    func testLayoutTree() {
        let layout: some Layout = root {
            child {
                grandChild1
                grandChild2
            }
        }
        
        print(layout)
        layout.attachSuperview()
        
        XCTAssertEqual(grandChild1.superview, child)
        XCTAssertEqual(grandChild2.superview, child)
        XCTAssertEqual(child.superview, root)
        
        layout.detachFromSuperview()
        XCTAssertNil(grandChild1.superview)
        XCTAssertNil(grandChild2.superview)
        XCTAssertNil(child.superview)
    }
    
}
