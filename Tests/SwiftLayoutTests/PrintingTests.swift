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
            Anchors(.width).to(.equal, to: .init(attribute: .notAnAttribute, constant: 0.0))
            Anchors(.height).to(.equal, to: .init(attribute: .notAnAttribute, constant: 0.0))
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
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
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
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
            }
            friend.anchors {
                Anchors(.top).equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: -10.0))
            }
            friend.anchors {
                Anchors(.top).to(.equal, to: .init(item: child, attribute: .bottom, constant: 0.0))
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
                Anchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
                Anchors(.leading).to(.equal, to: .init(item: root, attribute: .leading, constant: 0.0))
                Anchors(.trailing).to(.equal, to: .init(item: root, attribute: .trailing, constant: 0.0))
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: 0.0))
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
                Anchors(.top).to(.equal, to: .init(item: root, attribute: .top, constant: 0.0))
                Anchors(.leading).to(.equal, to: .init(item: root, attribute: .leading, constant: 0.0))
                Anchors(.trailing).to(.equal, to: .init(item: root, attribute: .trailing, constant: 0.0))
                Anchors(.bottom).to(.equal, to: .init(item: root, attribute: .bottom, constant: 0.0))
            }.subviews {
                grandchild.anchors {
                    Anchors(.top).to(.equal, to: .init(item: child, attribute: .top, constant: 0.0))
                    Anchors(.leading).to(.equal, to: .init(item: child, attribute: .leading, constant: 0.0))
                    Anchors(.trailing).to(.equal, to: .init(item: child, attribute: .trailing, constant: 0.0))
                    Anchors(.bottom).to(.equal, to: .init(item: child, attribute: .bottom, constant: 0.0))
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
                    Anchors(.top).to(.equal, to: .init(item: child, attribute: .top, constant: 0.0))
                }
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root, tags: [child: "child", grand: "grandchild"]).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    func testSafeAreaLayoutGuide() {
        let expect = """
        root {
            child.anchors {
                Anchors(.top).to(.equal, to: .init(item: root.safeAreaLayoutGuide, attribute: .top, constant: 0.0))
                Anchors(.bottom).to(.equal, to: .init(item: root.safeAreaLayoutGuide, attribute: .bottom, constant: 0.0))
                Anchors(.leading).to(.equal, to: .init(item: root, attribute: .leading, constant: 0.0))
            }
        }
        """.tabbed
        
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        deactivable = root {
            child.anchors {
                Anchors(.top).equalTo(root.safeAreaLayoutGuide, attribute: .top)
                Anchors(.bottom).equalTo(root.safeAreaLayoutGuide, attribute: .bottom)
                Anchors(.leading).equalTo(root, attribute: .leading)
            }
        }.active()
        
        let result = SwiftLayoutPrinter(root).print()
        print(result)
        XCTAssertEqual(result, expect)
    }
    
    
    class Cell: UIView, LayoutBuilding {
        var profileView: UIImageView = .init(image: nil)
        var nameLabel: UILabel = .init()
        
        var deactivable: Deactivable?
        
        var layout: Layout {
            self {
                profileView
                nameLabel
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateLayout()
        }
        
        required init?(coder: NSCoder) {
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
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"]).print()
        XCTAssertEqual(result, expect)
    }
}

private extension String {
    var tabbed: String { replacingOccurrences(of: "    ", with: "\t") }
}
