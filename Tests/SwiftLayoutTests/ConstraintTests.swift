//
//  ConstraintTokenizingTests.swift
//  
//
//  Created by oozoofrog on 2022/01/24.
//

import UIKit
import XCTest
@testable import SwiftLayout

class ConstraintTests: XCTestCase {

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
                    XCTAssertEqual(bindingFromView, binding)
                }
            }
        }
        context("직접 생성한 NSLayoutConstraint와") {
            let constraint: NSLayoutConstraint = left.topAnchor.constraint(equalTo: right.topAnchor)
            context("binding에서 생성한 constraint는") {
                let binding: NSLayoutConstraint = SwiftLayout.Binding(first: left.top, second: right.top, rule: SwiftLayout.Rule.equal).bind()
                context("동일하다") {
                    XCTAssertEqual(constraint.equator, binding.equator)
                }
            }
        }
    }
    
    func testLayoutConstraintBinding() {
        context("left의 top, bottom을 right에 연결하면") {
            right.layout {
                left.top
                left.bottom
            }
            
            context("top constraint 성공") {
                let constraint = left.top.find(secondElement: right.top)[0]
                let compare = left.topAnchor.constraint(equalTo: right.topAnchor)
                XCTAssertLayoutEqual(constraint, compare)
            }
            context("bottom constraint 성공") {
                let constraint = left.bottom.find(secondElement: right.bottom)[0]
                let compare = left.bottomAnchor.constraint(equalTo: right.bottomAnchor)
                XCTAssertLayoutEqual(constraint, compare)
            }
        }
    }
    
}

func XCTAssertLayoutEqual(_ lhs: NSLayoutConstraint, _ rhs: NSLayoutConstraint, file: StaticString = #filePath, line: UInt = #line) {
    guard lhs.equator != rhs.equator else { return }
    XCTFail(lhs.binding.debugDescription + " is not " + rhs.binding.debugDescription,
            file: file, line: line)
}
