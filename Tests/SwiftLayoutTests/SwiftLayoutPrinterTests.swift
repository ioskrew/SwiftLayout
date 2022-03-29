//
//  SwiftLayoutPrinterTests.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import XCTest
@testable import SwiftLayout

class SwiftLayoutPrinterTests: XCTestCase {

    var parent: UIView!
    var child: UIView!
    var friend: UIView!
    
    override func setUpWithError() throws {
        parent = UIView().viewTag.parent
        child = UIView().viewTag.child
        friend = UIView().viewTag.friend
    }

    override func tearDownWithError() throws {
        
    }

    func testSwiftLayoutPrinter() throws {
        parent {
            child.anchors {
                Anchors.height.equalTo(constant: 120.0)
            }
        }.finalActive()
        
        XCTAssertEqual(child.constraints.shortDescription, """
        child.height == + 120.0
        """.descriptions)
        
        XCTAssertEqual(SwiftLayoutPrinter(parent).print(), """
        parent {
            child.anchors {
                Anchors.height.equalTo(constant: 120.0)
            }
        }
        """.tabbed)
    }

}
