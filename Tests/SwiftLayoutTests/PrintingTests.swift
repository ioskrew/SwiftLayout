import XCTest
import SwiftLayout

class PrintingTests: XCTestCase {
    
    var window: UIView!
    
    var activation: Activation? 
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
    }

    override func tearDownWithError() throws {
        activation = nil
    }
}

extension PrintingTests {
    func testPrintWithViewsSimple() throws {
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
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
        let root = UIView().viewTag.root
        let a = UIView().viewTag.a
        let b = UIView().viewTag.b
        
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
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let grandchild = UIView().viewTag.grandchild
        
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
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        let grandchild = UIView().viewTag.grandchild
        
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
    
    func testTopBottomAndEquals() {
        let root = UIView().viewTag.root
        let one = UIView().viewTag.one
        let two = UIView().viewTag.two
        
        func layout() -> some Layout {
            root {
                one.anchors {
                    Anchors.bottom
                    Anchors.leading.trailing
                }
                two.anchors {
                    Anchors.top.equalTo(one.bottomAnchor)
                    Anchors.width.equalTo(one)
                    Anchors.centerX.equalTo(one)
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(root.constraints.shortDescription, """
        one.leading == root.leading
        one.bottom == root.bottom
        two.top == one.bottom
        two.centerX == one.centerX
        one.trailing == root.trailing
        two.width == one.width
        """.descriptions)
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            one.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
            two.anchors {
                Anchors.top.equalTo(one, attribute: .bottom)
                Anchors.width.equalTo(one)
                Anchors.centerX.equalTo(one)
            }
        }
        """.tabbed)
    }
    
    func testSizeWithConstant() {
        let root = UIView().viewTag.root
        let one = UIView().viewTag.one
        
        root {
            one.anchors {
                Anchors.width.equalTo(root, constant: -20.0)
            }
        }.finalActive()
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            one.anchors {
                Anchors.width.equalToSuper(constant: -20.0)
            }
        }
        """.tabbed)
    }
  
    // test 자체가 오류
//    func testPrintWithSimpleAnchors() {
//        let root = UIView().viewTag.root
//        activation = root.anchors {
//            Anchors.width.height
//        }.active()
//
//        let expect = """
//        root.anchors {
//            Anchors.width.height.equalToSuper()
//        }
//        """.tabbed
//
//        let result = SwiftLayoutPrinter(root).print()
//        XCTAssertEqual(result, expect)
//    }
    
    func testPrintWithAnchorsWithOneDepth() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        activation = root {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        activation = root {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(root).print()
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
        let root = UIView().viewTag.root
        activation = root {
            UILabel().viewTag.label.anchors {
                Anchors.allSides()
            }
        }.active()
        
        let expect = """
        root {
            label.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
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
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                grandchild.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
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
        
        activation = root {
            child {
                grand.anchors {
                    Anchors.top
                }
            }
        }.active()
        
        let expect = """
        root {
            child {
                grandchild.anchors {
                    Anchors.top
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
        activation = root {
            child.anchors {
                Anchors.top.bottom.equalTo(root.safeAreaLayoutGuide)
                Anchors.leading
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors.top.bottom.equalTo(root.safeAreaLayoutGuide)
                Anchors.leading
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
            profileView:\(UIImageView.self)
            nameLabel:\(UILabel.self)
        }
        """.tabbed
        
        let result = SwiftLayoutPrinter(cell, tags: [cell: "contentView"]).print(.withTypeOfView)
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        activation = root {
            child.anchors {
                Anchors.cap()
            }
            friend.anchors {
                Anchors.leading
                Anchors.bottom
                Anchors.top.greaterThanOrEqualTo(child, attribute: .bottom, constant: 8)
                Anchors.trailing.equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
            friend.anchors {
                Anchors.top.greaterThanOrEqualTo(child, attribute: .bottom, constant: 8.0)
                Anchors.bottom
                Anchors.leading
                Anchors.trailing.equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testGreaterThanAndLessThan() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        activation = root {
            child.anchors {
                Anchors.top.greaterThanOrEqualToSuper()
                Anchors.bottom.lessThanOrEqualToSuper()
                Anchors.height.equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors.height.equalTo(child)
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors.top.greaterThanOrEqualToSuper()
                Anchors.bottom.lessThanOrEqualToSuper()
                Anchors.height.equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors.height.equalTo(child)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testPrintSize() {
       
        let root = UIView().viewTag.root
        let child = UIView().viewTag.child
        
        func layout() -> some Layout {
            root {
                child.anchors {
                    Anchors.width.height
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(root.constraints.shortDescription, """
        child.width == root.width
        child.height == root.height
        """.descriptions)
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), """
        root {
            child.anchors {
                Anchors.width.height.equalToSuper()
            }
        }
        """.tabbed)
        
    }
    
}

// MARK: - automatic identifier assignment
extension PrintingTests {
    
    func testautomaticIdentifierAssignmentOption() {
        let cell = Cell().updateIdentifiers()
        
        XCTAssertEqual(cell.profileView.accessibilityIdentifier, "profileView")
        XCTAssertEqual(cell.nameLabel.accessibilityIdentifier, "nameLabel")
    }
    
    class Cell: UIView, Layoutable {
        
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
    
    class One: UIView {}
    class Two: One {}
    class Three: Two {}
   
    func testDeepAssignIdentifier() {
        let gont = Gont()
        
        XCTAssertEqual(SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView),
        """
        gont {
            sea:\(UILabel.self).anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                duny:Duny.anchors {
                    Anchors.centerX.equalToSuper().multiplier(1.2000000476837158)
                    Anchors.centerY.equalToSuper().multiplier(0.800000011920929)
                }.sublayout {
                    duny.nickname:\(UILabel.self).anchors {
                        Anchors.top
                        Anchors.leading.trailing
                    }.sublayout {
                        sparrowhawk.anchors {
                            Anchors.top.bottom
                            Anchors.leading.trailing
                        }
                    }
                    duny.truename:\(UILabel.self).anchors {
                        Anchors.top.equalTo(duny.nickname:UILabel, attribute: .bottom)
                        Anchors.bottom
                        Anchors.leading.trailing
                    }.sublayout {
                        ged.anchors {
                            Anchors.top.bottom
                            Anchors.leading.trailing
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
    
    class Gont: Earth, Layoutable {
        lazy var duny = Duny(in: self)
        
        var activation: Activation?
        var layout: some Layout {
            self {
                sea.anchors({
                    Anchors.allSides()
                }).sublayout {
                    duny.anchors {
                        Anchors.centerX.multiplier(1.2)
                        Anchors.centerY.multiplier(0.8)
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
    
    class Wizard: UIView {
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
                    UIView().viewTag.sparrowhawk.anchors {
                        Anchors.allSides()
                    }
                }
                truename.anchors({
                    Anchors.top.equalTo(nickname.bottomAnchor)
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
            sl.updateLayout()
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
        XCTAssertEqual(SwiftLayoutPrinter(root).print(options: .onlyIdentifier), """
        root {
            label.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
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
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
    }
    
    func testWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.withTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
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
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label:\(UILabel.self)")
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
            _ = SwiftLayoutPrinter(gont, tags: [gont: "gont"]).print(.referenceAndNameWithTypeOfView)
        }
    }
}
