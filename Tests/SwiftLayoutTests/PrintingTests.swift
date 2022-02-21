import XCTest
import UIKit
import SwiftLayout

class PrintingTests: XCTestCase {
    
    var deactivable: Deactivable?
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        deactivable = nil
    }
}

extension PrintingTests {
    func testPrintWithViewsSimple() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        deactivable = root {
            child
        }.active()
        
        let expect = """
        root {
            child
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoViews() throws {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoDepthOfViews() throws {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithMultipleDepthOfViews() throws {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSimpleAnchors() {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsWithOneDepth() {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
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
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
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
    
    func testPrintWithTwwDepthsWithSublayout() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
        deactivable = root {
            child.anchors{
                Anchors.boundary
            }.sublayout {
                grandchild.anchors {
                    Anchors.boundary
                }
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .leading, .trailing, .bottom)
            }.sublayout {
                grandchild.anchors {
                    Anchors(.top, .leading, .trailing, .bottom)
                }
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithInstantTags() {
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
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSafeAreaLayoutGuide() {
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
    
    func testPrintMoreEfficiently() {
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
    
    func testGreaterThanAndLessThan() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        deactivable = root {
            child.anchors {
                Anchors(.top).greaterThanOrEqualTo()
                Anchors(.bottom).lessThanOrEqualTo()
                Anchors(.height).equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors(.height).equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top).greaterThanOrEqualTo()
                Anchors(.bottom).lessThanOrEqualTo()
                Anchors(.height).equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors(.height).equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
}

extension PrintingTests {
    class Cell: UIView, LayoutBuilding {
        
        let options: LayoutOptions
        
        var profileView: UIImageView = .init(image: nil)
        var nameLabel: UILabel = .init()
        
        var deactivable: Deactivable?
        
        var layout: some Layout {
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
}

private extension String {
    var tabbed: String { replacingOccurrences(of: "    ", with: "\t") }
}
