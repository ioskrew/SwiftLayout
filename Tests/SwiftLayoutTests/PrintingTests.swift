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
        continueAfterFailure = false
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
            child
        }
        """.tabbed
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
            a
            b
        }
        """.tabbed
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
            child {
                grandchild
            }
        }
        """.tabbed
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
            child {
                grandchild
            }
            friend
        }
        """.tabbed
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
            Anchors(.width, .height)
        }
        """.tabbed
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
                Anchors(.bottom).equalTo(constant: -10.0)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).equalTo(constant: -10.0)
            }
        }
        """.tabbed
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
                Anchors(.bottom).equalTo(constant: -10.0)
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top)
                Anchors(.bottom).equalTo(constant: -10.0)
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }
        """.tabbed
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }

    func testAnonymousTaggedView() {
        let root = UIView().viewTag.root
        deactivable = root {
            UILabel().viewTag.label.anchors {
                Anchors.boundary
            }
        }.active()
        
        let expect = """
        root {
            label.anchors {
                Anchors(.top, .leading, .trailing, .bottom)
            }
        }
        """.tabbed
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testTwwDepthsWithSubviews() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
        deactivable = root {
            child.anchors{
                Anchors.boundary
            }.subviews {
                grandchild.anchors {
                    Anchors.boundary
                }
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .leading, .trailing, .bottom)
            }.subviews {
                grandchild.anchors {
                    Anchors(.top, .leading, .trailing, .bottom)
                }
            }
        }
        """.tabbed
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testInstantTags() {
        let root = UIView().viewTag.root
        let child = UILabel()
        let grand = UILabel().viewTag.grand
        
        deactivable = root {
            child {
                grand.anchors {
                    Anchors(.top)
                }
            }
        }.active()
        
        let expect = """
        root {
            child {
                grandchild.anchors {
                    Anchors(.top)
                }
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root, tags: [child: "child", grand: "grandchild"]).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testSafeAreaLayoutGuide() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        deactivable = root {
            child.anchors {
                Anchors(.top, .bottom).equalTo(root.safeAreaLayoutGuide)
                Anchors(.leading)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom).equalTo(root.safeAreaLayoutGuide)
                Anchors(.leading)
            }
        }
        """.tabbed
       
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    
    class Cell: UIView, LayoutBuilding {
        
        let options: LayoutOptions
        
        var profileView: UIImageView = .init(image: nil)
        var nameLabel: UILabel = .init()
        
        var deactivable: Deactivable?
        
        var layout: Layout {
            self {
                profileView
                nameLabel
            }
        }
        
        init(_ _options: LayoutOptions = []) {
            options = _options
            super.init(frame: .zero)
            updateLayout(options)
        }
        
        required init?(coder: NSCoder) {
            options = []
            super.init(coder: coder)
            updateLayout()
        }
    }
    
    func testPrintWithFindingViewIdentifiers() {
        let cell = Cell()
        let expect = """
        contentView {
            profileView
            nameLabel
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"], options: .automaticIdentifierAssignment).print()
        XCTAssertEqual(result, expect)
    }
    
    func testAccessibilityIdentifierSettings() {
        let cell = Cell(.automaticIdentifierAssignment)
        
        XCTAssertEqual(cell.profileView.accessibilityIdentifier, "profileView")
        XCTAssertEqual(cell.nameLabel.accessibilityIdentifier, "nameLabel")
    }
    
    func testMoreEfficientPrinting() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        deactivable = root {
            child.anchors {
                Anchors.cap
            }
            friend.anchors {
                Anchors(.leading, .bottom)
                Anchors(.top).greaterThanOrEqualTo(child, attribute: .bottom, constant: 8)
                Anchors(.trailing).equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .leading, .trailing)
            }
            friend.anchors {
                Anchors(.leading, .bottom)
                Anchors(.top).greaterThanOrEqualTo(child, attribute: .bottom, constant: 8.0)
                Anchors(.trailing).equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
        
    }
}

private extension String {
    var tabbed: String { replacingOccurrences(of: "    ", with: "\t") }
}
