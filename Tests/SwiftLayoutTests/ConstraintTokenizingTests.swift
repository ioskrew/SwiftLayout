//
//  ConstraintTokenizingTests.swift
//  
//
//  Created by oozoofrog on 2022/01/24.
//

import XCTest
@testable import SwiftLayout

class ConstraintTokenizingTests: XCTestCase {

    var left: UIView!
    var right: UIView!
    
    override func setUpWithError() throws {
        left = UIView().tag.left
        right = UIView().tag.right
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBinding() {
        context("NSLayoutConstraint에서 가져온 Binding과") {
            let bindingFromView = left.topAnchor.constraint(equalTo: right.topAnchor).binding
            context("직접 생성한 Binding은") {
                let binding = SwiftLayout.Binding(first: left.top, second: right.top)
                context("동일하다") {
                    print(bindingFromView)
                    XCTAssertEqual(bindingFromView, binding)
                }
            }
        }
    }
}
