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
        root {
        \tchild
        }
        """
        let result = SwiftLayoutPrinter(root).print()
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
        root {
        \ta
        \tb
        }
        """
        let result = SwiftLayoutPrinter(root).print()
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
        root {
        \tchild {
        \t\tgrandchild
        \t}
        }
        """
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testMultipleDepthOfViews() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        let grandchild = UIView().viewTag.grandchild
        
        deactivable = root {
            child {
                grandchild
            }
            friend
        }.active()
        
        let expect = """
        root {
        \tchild {
        \t\tgrandchild
        \t}
        \tfriend
        }
        """
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintingSimpleAnchors() {
        let root = UIView().viewTag.root
        deactivable = root.anchors {
            Anchors(.width, .height)
        }.active()
        
        let expect = """
        root.anchors {
        \tAnchors(.width).to(.equal, to: .init(attribute: .notAnAttribute, constant: 0.0))
        \tAnchors(.height).to(.equal, to: .init(attribute: .notAnAttribute, constant: 0.0))
        }
        """
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintingAnchorsWithOneDepth() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        deactivable = root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
            }
        }.active()
        
        let expect = """
        root {
        \tchild.anchors {
        \t\tAnchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
        \t\tAnchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
        \t}
        }
        """
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintingAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        deactivable = root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root {
        \tchild.anchors {
        \t\tAnchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
        \t\tAnchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
        \t}
        \tfriend.anchors {
        \t\tAnchors(.top).to(.equal, to: .init(item: child, attribute: .bottom, constant: 0.0))
        \t}
        }
        """
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }

}
