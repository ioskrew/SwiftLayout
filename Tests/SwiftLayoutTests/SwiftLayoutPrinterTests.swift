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
        context("to super") {
            parent {
                child.anchors {
                    Anchors.top.bottom
                    Anchors.horizontal(offset: 16.0)
                }
            }.finalActive()
            
            XCTAssertEqual(parent.constraints.shortDescription, """
            child.bottom == parent.bottom
            child.trailing == parent.trailing - 16.0
            child.top == parent.top
            child.leading == parent.leading + 16.0
            """.descriptions)
            
            XCTAssertEqual(SwiftLayoutPrinter(parent).print(), """
            parent {
                child.anchors {
                    Anchors.top.bottom.equalToSuper()
                    Anchors.leading.equalToSuper(constant: 16.0)
                    Anchors.trailing.equalToSuper(constant: -16.0)
                }
            }
            """.tabbed)
        }
        context("to sibling") {
            parent {
                child.anchors {
                    Anchors.cap()
                }
                friend.anchors {
                    Anchors.top.equalTo(child, attribute: .bottom)
                    Anchors.shoe()
                }
            }.finalActive()
            
            XCTAssertEqual(SwiftLayoutPrinter(parent).print(), """
            parent {
                child.anchors {
                    Anchors.top.equalToSuper()
                    Anchors.leading.trailing.equalToSuper()
                }
                friend.anchors {
                    Anchors.top.equalTo(child, attribute: bottom)
                    Anchors.bottom.equalToSuper()
                    Anchors.leading.trailing.equalToSuper()
                }
            }
            """.tabbed)
        }
    }

}
