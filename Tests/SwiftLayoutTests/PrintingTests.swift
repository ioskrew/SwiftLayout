import XCTest
import SwiftLayout

class PrintingTests: XCTestCase {
    
    var window: SLView!
    
    var activation: Activation? 
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        window = SLView(frame: .init(x: 0, y: 0, width: 150, height: 150))
    }

    override func tearDownWithError() throws {
        activation = nil
    }
}

extension PrintingTests {
    func testPrintWithViewsSimple() throws {
        let root = SLView().viewTag.root
        let child = SLView().viewTag.child
        
        activation = root {
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
        let root = SLView().viewTag.root
        let a = SLView().viewTag.a
        let b = SLView().viewTag.b
        
        activation = root {
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
        let root = SLView().viewTag.root
        let child = SLView().viewTag.child
        let grandchild = SLView().viewTag.grandchild
        
        activation = root {
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
        let root = SLView().viewTag.root
        let child = SLView().viewTag.child
        let friend = SLView().viewTag.friend
        let grandchild = SLView().viewTag.grandchild
        
        activation = root {
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
        let root = SLView().viewTag.root
        activation = root.anchors {
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
        let root = SLView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = SLView().viewTag.child
        activation = root {
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
        let root = SLView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = SLView().viewTag.child
        let friend = SLView().viewTag.friend
        activation = root {
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
        let root = SLView().viewTag.root
        activation = root {
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
        let root = SLView().viewTag.root
        let child = SLView().viewTag.child
        let grandchild = SLView().viewTag.grandchild
        
        activation = root {
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
        let root = SLView().viewTag.root
        let child = UILabel()
        let grand = UILabel().viewTag.grand
        
        activation = root {
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
        let root = SLView().viewTag.root
        let child = SLView().viewTag.child
        activation = root {
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
        #if canImport(AppKit)
        cell.profileView.subviews.first?.setAccessibilityIdentifier("profileViewCell")
        let expect = """
        contentView {
            profileView:\(UIImageView.self) {
                profileViewCell
            }
            nameLabel:\(UILabel.self)
        }
        """.tabbed
        #else
        let expect = """
        contentView {
            profileView:\(UIImageView.self)
            nameLabel:\(UILabel.self)
        }
        """.tabbed
        #endif
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"]).print(.withTypeOfView)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = SLView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = SLView().viewTag.child
        let friend = SLView().viewTag.friend
        
        activation = root {
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
        let root = SLView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = SLView().viewTag.child
        let friend = SLView().viewTag.friend
        activation = root {
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
        let cell = Cell().updateIdentifiers()
        
        XCTAssertEqual(cell.profileView.slIdentifier, "profileView")
        XCTAssertEqual(cell.nameLabel.slIdentifier, "nameLabel")
    }
    
    class Cell: SLView, Layoutable {
        
        var profileView: UIImageView = .init(image: .init())
        var nameLabel: UILabel = .init()
        
        var activation: Activation?
        
        var layout: some Layout {
            self {
                profileView
                nameLabel
            }
        }
        
        init() {
            super.init(frame: .zero)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            sl.updateLayout()
        }
    }
}

// MARK: - identifier assignment deeply
extension PrintingTests {
    
    class One: SLView {}
    class Two: One {}
    class Three: Two {}
   
    func testDeepAssignIdentifier() {
        let gont = Gont()
        
        XCTAssertEqual(SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView),
        """
        gont {
            sea:\(UILabel.self).anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                duny:Duny.anchors {
                    Anchors(.centerX).setMultiplier(1.2000000476837158)
                    Anchors(.centerY).setMultiplier(0.800000011920929)
                }.sublayout {
                    duny.nickname:\(UILabel.self).anchors {
                        Anchors(.top, .leading, .trailing)
                    }.sublayout {
                        sparrowhawk.anchors {
                            Anchors(.top, .bottom, .leading, .trailing)
                        }
                    }
                    duny.truename:\(UILabel.self).anchors {
                        Anchors(.top).equalTo(duny.nickname:\(UILabel.self), attribute: .bottom)
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
    
    class Earth: SLView {
        let sea = UILabel()
    }
    
    class Gont: Earth, Layoutable {
        lazy var duny = Duny(in: self)
        
        var activation: Activation?
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
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Wizard: SLView {
        let truename = UILabel()
    }
    
    class Duny: Wizard, Layoutable {
        
        init(in earth: Earth) {
            super.init(frame: .zero)
            self.earth = earth
            sl.updateLayout()
        }
        
        weak var earth: Earth?
        let nickname = UILabel()
        
        var activation: Activation? 
        var layout: some Layout {
            self {
                nickname.anchors({
                    Anchors.cap()
                }).sublayout {
                    SLView().viewTag.sparrowhawk.anchors {
                        Anchors.allSides()
                    }
                }
                truename.anchors({
                    Anchors(.top).equalTo(nickname.bottomAnchor)
                    Anchors.shoe()
                }).sublayout {
                    SLView().viewTag.ged.anchors {
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
            sl.updateLayout()
        }
    }
    
}

// MARK: - print system constraint
extension PrintingTests {
    
    func testSystemConstraint() {
        
        let root = SLView().viewTag.root
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
        #if canImport(UIKit)
        XCTAssertEqual(SwiftLayoutPrinter(root).print(systemConstraintsHidden: false), """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
                Anchors(.width).equalTo(constant: 38.666666666666664)
                Anchors(.height).equalTo(constant: 14.333333333333334)
            }
        }
        """.tabbed)
        #else
        XCTAssertEqual(SwiftLayoutPrinter(root).print(systemConstraintsHidden: false), """
        root {
            label.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed)
        #endif
    }
    
}

// MARK: - options for IdentifierUpdater
extension PrintingTests {
    func testNameOnly() {
        let id = ID()
        IdentifierUpdater.nameOnly.update(id)
        XCTAssertEqual(id.name.slIdentifier, "name")
        XCTAssertEqual(id.name.label.slIdentifier ?? "", "")
    }
    
    func testWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.withTypeOfView.update(id)
        XCTAssertEqual(id.name.slIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.slIdentifier ?? "", "")
    }
    
    func testReferenceAndName() {
        let id = ID()
        IdentifierUpdater.referenceAndName.update(id)
        XCTAssertEqual(id.name.slIdentifier, "name")
        XCTAssertEqual(id.name.label.slIdentifier, "name.label")
    }
    
    func testReferenceAndNameWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.referenceAndNameWithTypeOfView.update(id)
        XCTAssertEqual(id.name.slIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.slIdentifier, "name.label:\(UILabel.self)")
    }

    class Name: SLView {
        let label = UILabel()
    }
    
    class ID: SLView {
        let name = Name()
    }
}

// MARK: - performance
extension PrintingTests {
    func testSwiftLayoutPrinterPerformance() {
        measure {
            let gont = Gont()
            _ = SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView)
        }
    }
}
