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
            child
            friend.anchors {
                Anchors.leading
                Anchors.trailing.equalTo(child)
            }
        }.finalActive()
        
        XCTAssertEqual(parent.constraints.shortDescription, """
        friend.leading == parent.leading
        friend.trailing == child.trailing
        """.descriptions)
        
        XCTAssertEqual(SwiftLayoutPrinter(parent).print(), """
        parent {
            child
            friend.anchors {
                Anchors.leading
                Anchors.trailing.equalTo(child)
            }
        }
        """.tabbed)
    }

}
