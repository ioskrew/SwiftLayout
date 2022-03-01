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
                Anchors.allSides()
            }
        }.active()
        
        let expect = """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
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
                Anchors.allSides()
            }.sublayout {
                grandchild.anchors {
                    Anchors.allSides()
                }
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                grandchild.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
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
            profileView:UIImageView
            nameLabel:UILabel
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"]).print(.withTypeOfView)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        deactivable = root {
            child.anchors {
                Anchors.cap()
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
                Anchors(.top).greaterThanOrEqualTo(child, attribute: .bottom, constant: 8.0)
                Anchors(.bottom, .leading)
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

// MARK: - automatic identifier assignment
extension PrintingTests {
    
    func testautomaticIdentifierAssignmentOption() {
        let cell = Cell(.automaticIdentifierAssignment)
        
        XCTAssertEqual(cell.profileView.accessibilityIdentifier, "profileView")
        XCTAssertEqual(cell.nameLabel.accessibilityIdentifier, "nameLabel")
    }
    
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

// MARK: - identifier assignment deeply
extension PrintingTests {
    
    func testDeepAssignIdentifier() {
        let gont = Gont()
        
        XCTAssertEqual(SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView),
        """
        gont {
            sea:UILabel.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                duny:Duny.anchors {
                    Anchors(.centerX).setMultiplier(1.2000000476837158)
                    Anchors(.centerY).setMultiplier(0.800000011920929)
                }.sublayout {
                    duny.nickname:UILabel.anchors {
                        Anchors(.top, .leading, .trailing)
                    }.sublayout {
                        sparrowhawk.anchors {
                            Anchors(.top, .bottom, .leading, .trailing)
                        }
                    }
                    duny.truename:UILabel.anchors {
                        Anchors(.top).equalTo(duny.nickname:UILabel, attribute: .bottom)
                        Anchors(.bottom, .leading, .trailing)
                    }.sublayout {
                        ged.anchors {
                            Anchors(.top, .bottom, .leading, .trailing)
                        }
                    }
                }
            }
        }
        """.tabbed)
    }
    
    class Earth: UIView {
        let sea = UILabel()
    }
    
    class Gont: Earth, LayoutBuilding {
        lazy var duny = Duny(in: self)
        
        var deactivable: Deactivable?
        var layout: some Layout {
            self {
                sea.anchors({
                    Anchors.allSides()
                }).sublayout {
                    duny.anchors {
                        Anchors(.centerX).setMultiplier(1.2)
                        Anchors(.centerY).setMultiplier(0.8)
                    }
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Wizard: UIView {
        let truename = UILabel()
    }
    
    class Duny: Wizard, LayoutBuilding {
        
        init(in earth: Earth) {
            super.init(frame: .zero)
            self.earth = earth
            updateLayout()
        }
        
        weak var earth: Earth?
        let nickname = UILabel()
        
        var deactivable: Deactivable?
        var layout: some Layout {
            self {
                nickname.anchors({
                    Anchors.cap()
                }).sublayout {
                    UIView().viewTag.sparrowhawk.anchors {
                        Anchors.allSides()
                    }
                }
                truename.anchors({
                    Anchors(.top).equalTo(nickname.bottomAnchor)
                    Anchors.shoe()
                }).sublayout {
                    UIView().viewTag.ged.anchors {
                        Anchors.allSides()
                    }
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateLayout()
        }
    }
    
}

// MARK: - print system constraint
extension PrintingTests {
    
    func testSystemConstraint() {
        
        let root = UIView().viewTag.root
        let label = UILabel().viewTag.label
        label.font = .systemFont(ofSize: 12)
        label.text = "HELLO"
        @LayoutBuilder
        func layout() -> some Layout {
            root {
                label.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        layout().finalActive()
        label.setNeedsLayout()
        label.layoutIfNeeded()
        XCTAssertEqual(SwiftLayoutPrinter(root).print(systemConstraintsHidden: false), """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
                Anchors(.width).equalTo(constant: 38.666666666666664)
                Anchors(.height).equalTo(constant: 14.333333333333334)
            }
        }
        """.tabbed)
    }
    
}

// MARK: - options for IdentifierUpdater
extension PrintingTests {
    func testNameOnly() {
        let id = ID()
        IdentifierUpdater.nameOnly.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "label")
    }
    
    func testWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.withTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "label:UILabel")
    }
    
    func testReferenceAndName() {
        let id = ID()
        IdentifierUpdater.referenceAndName.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label")
    }
    
    func testReferenceAndNameWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.referenceAndNameWithTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label:UILabel")
    }

    class Name: UIView {
        let label = UILabel()
    }
    
    class ID: UIView {
        let name = Name()
    }
}

// MARK: - performance
extension PrintingTests {
    func testSwiftLayoutPrinterPerformance() {
        measure {
            let gont = Gont()
            print(SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView))
        }
    }
}
