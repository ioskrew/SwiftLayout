//
//  PrintingTests.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import XCTest
import SwiftLayout

class PrintingTests: XCTestCase {
    
    var deactivable: Deactivable?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewsSimple() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        deactivable = root {
            child
        }.active()
        
        XCTAssertEqual(child.superview, root)
        let expect = """
        root:UIView {
        \tchild:UIView
        }
        """
        let result = SwiftLayoutPrinter(view: root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testTwoViews() throws {
        let root = UIView().viewTag.root
        let a = UIView().viewTag.a
        let b = UIView().viewTag.b
        
        deactivable = root {
            a
            b
        }.active()
        
        let expect = """
        root:UIView {
        \ta:UIView
        \tb:UIView
        }
        """
        let result = SwiftLayoutPrinter(view: root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testTwoDepthOfViews() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
        deactivable = root {
            child {
                grandchild
            }
        }.active()
        
        let expect = """
        root:UIView {
        \tchild:UIView {
        \t\tgrandchild:UIView
        \t}
        }
        """
        let result = SwiftLayoutPrinter(view: root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }

}
