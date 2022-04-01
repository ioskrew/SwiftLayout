import XCTest
import SwiftLayout
import SwiftLayoutUtil

class ViewPrinterTests: XCTestCase {
    
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

extension ViewPrinterTests {
    func testPrintWithViewsSimple() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        
        activation = root {
            child
        }.active()
        
        let expect = """
        root {
            child
        }
        """.tabbed
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoViews() throws {
        let root = UIView().identifying("root")
        let a = UIView().identifying("a")
        let b = UIView().identifying("b")
        
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
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoDepthOfViews() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")
        
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
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithMultipleDepthOfViews() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        let grandchild = UIView().identifying("grandchild")
        
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
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testTopBottomAndEquals() {
        let root = UIView().identifying("root")
        let one = UIView().identifying("one")
        let two = UIView().identifying("two")
        
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
        
        XCTAssertEqual(ViewPrinter(root).description, """
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
        let root = UIView().identifying("root")
        let one = UIView().identifying("one")
        
        root {
            one.anchors {
                Anchors.width.equalTo(root, constant: -20.0)
            }
        }.finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root {
            one.anchors {
                Anchors.width.equalToSuper(constant: -20.0)
            }
        }
        """.tabbed)
    }
    
    func testPrintWithAnchorsWithOneDepth() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
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
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
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
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
        let root = UIView().identifying("root")
        activation = root {
            UILabel().identifying("label").anchors {
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
        
        let result = ViewPrinter(root).description
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwwDepthsWithSublayout() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")
        
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
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithInstantTags() {
        let root = UIView().identifying("root")
        let child = UILabel()
        let grand = UILabel().identifying("grand")
        
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
        
        let result = ViewPrinter(root, tags: [child: "child", grand: "grandchild"]).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSafeAreaLayoutGuide() {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
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
       
        let result = ViewPrinter(root).description
        
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
        
        let result = ViewPrinter(cell, tags: [cell: "contentView"]).updateIdentifiers(.withTypeOfView).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        
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
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
    
    func testGreaterThanAndLessThan() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
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
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
    
    func testPrintSize() {
       
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        
        func layout() -> some Layout {
            root {
                child.anchors {
                    Anchors.width.height
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root {
            child.anchors {
                Anchors.width.height.equalToSuper()
            }
        }
        """.tabbed)
        
    }
    
}

// MARK: - automatic identifier assignment
extension ViewPrinterTests {
    
    func testautomaticIdentifierAssignmentOption() {
        let cell = Cell()
        ViewPrinter(cell).updateIdentifiers()
        
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
extension ViewPrinterTests {
    
    class One: UIView {}
    class Two: One {}
    class Three: Two {}
   
    func testDeepAssignIdentifier() {
        let gont = Gont()
        
        XCTAssertEqual(ViewPrinter(gont, tags: [gont: "gont"]).updateIdentifiers(.referenceAndNameWithTypeOfView).description,
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
                    UIView().identifying("sparrowhawk").anchors {
                        Anchors.allSides()
                    }
                }
                truename.anchors({
                    Anchors.top.equalTo(nickname.bottomAnchor)
                    Anchors.shoe()
                }).sublayout {
                    UIView().identifying("ged").anchors {
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
extension ViewPrinterTests {
    
    func testSystemConstraint() {
        
        let root = UIView().identifying("root")
        let label = UILabel().identifying("label")
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
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, """
        root {
            label.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed)
    }
    
}

// MARK: - performance
extension ViewPrinterTests {
    func testViewPrinterPerformance() {
        measure {
            let gont = Gont()
            _ = ViewPrinter(gont, tags: [gont: "gont"]).updateIdentifiers(.referenceAndNameWithTypeOfView).description
        }
    }
}
