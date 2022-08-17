import XCTest
import SwiftLayout
import SwiftLayoutUtil
import UIKit

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
        
        activation = root.sublayout {
            child
        }.active()
        
        let expect = """
        root.sublayout {
            child
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoViews() throws {
        let root = UIView().identifying("root")
        let a = UIView().identifying("a")
        let b = UIView().identifying("b")
        
        activation = root.sublayout {
            a
            b
        }.active()
        
        let expect = """
        root.sublayout {
            a
            b
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoDepthOfViews() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")
        
        activation = root.sublayout {
            child.sublayout {
                grandchild
            }
        }.active()
        
        let expect = """
        root.sublayout {
            child.sublayout {
                grandchild
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithMultipleDepthOfViews() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        let grandchild = UIView().identifying("grandchild")
        
        activation = root.sublayout {
            child.sublayout {
                grandchild
            }
            friend
        }.active()
        
        let expect = """
        root.sublayout {
            child.sublayout {
                grandchild
            }
            friend
        }
        """
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testTopBottomAndEquals() {
        let root = UIView().identifying("root")
        let one = UIView().identifying("one")
        let two = UIView().identifying("two")
        
        func layout() -> some Layout {
            root.sublayout {
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
        root.sublayout {
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
        """)
    }
    
    func testSizeWithConstant() {
        let root = UIView().identifying("root")
        let one = UIView().identifying("one")
        
        root.sublayout {
            one.anchors {
                Anchors.width.equalTo(root, constant: -20.0)
            }
        }.finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root.sublayout {
            one.anchors {
                Anchors.width.equalToSuper(constant: -20.0)
            }
        }
        """)
    }
    
    func testPrintWithAnchorsWithOneDepth() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        activation = root.sublayout {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }.active()
        
        let expect = """
        root.sublayout {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        activation = root.sublayout {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root.sublayout {
            child.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
        let root = UIView().identifying("root")
        activation = root.sublayout {
            UILabel().identifying("label").anchors {
                Anchors.allSides()
            }
        }.active()
        
        let expect = """
        root.sublayout {
            label.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """
        
        let result = ViewPrinter(root).description
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwwDepthsWithSublayout() throws {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")
        
        activation = root.sublayout {
            child.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.anchors {
                    Anchors.allSides()
                }
            }
        }.active()
        
        let expect = """
        root.sublayout {
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
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithInstantTags() {
        let root = UIView().identifying("root")
        let child = UILabel()
        let grand = UILabel().identifying("grand")
        
        activation = root.sublayout {
            child.sublayout {
                grand.anchors {
                    Anchors.top
                }
            }
        }.active()
        
        let expect = """
        root.sublayout {
            child.sublayout {
                grandchild.anchors {
                    Anchors.top
                }
            }
        }
        """
        
        let result = ViewPrinter(root, tags: [child: "child", grand: "grandchild"]).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSafeAreaLayoutGuide() {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        activation = root.sublayout {
            child.anchors {
                Anchors.top.bottom.equalTo(root.safeAreaLayoutGuide)
                Anchors.leading
            }
        }.active()
        
        let expect = """
        root.sublayout {
            child.anchors {
                Anchors.top.bottom.equalTo(root.safeAreaLayoutGuide)
                Anchors.leading
            }
        }
        """
       
        let result = ViewPrinter(root).description
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithFindingViewIdentifiers() {
        let cell = Cell()
        let expect = """
        contentView.sublayout {
            profileView:\(UIImageView.self)
            nameLabel:\(UILabel.self)
        }
        """
        
        let result = ViewPrinter(cell, tags: [cell: "contentView"]).updateIdentifiers(.withTypeOfView).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        
        activation = root.sublayout {
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
        root.sublayout {
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
        """
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
    
    func testGreaterThanAndLessThan() {
        let root = UIView().identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().identifying("child")
        let friend = UIView().identifying("friend")
        activation = root.sublayout {
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
        root.sublayout {
            child.anchors {
                Anchors.top.greaterThanOrEqualToSuper()
                Anchors.bottom.lessThanOrEqualToSuper()
                Anchors.height.equalTo(constant: 12.0)
            }
            friend.anchors {
                Anchors.height.equalTo(child)
            }
        }
        """
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
    
    func testPrintSize() {
       
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        
        func layout() -> some Layout {
            root.sublayout {
                child.anchors {
                    Anchors.width.height
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root.sublayout {
            child.anchors {
                Anchors.width.height.equalToSuper()
            }
        }
        """)
        
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
            self.sublayout {
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
        gont.sublayout {
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
        """)
    }
    
    class Earth: UIView {
        let sea = UILabel()
    }
    
    class Gont: Earth, Layoutable {
        lazy var duny = Duny(in: self)
        
        var activation: Activation?
        var layout: some Layout {
            self.sublayout {
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
            self.sublayout {
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
            root.sublayout {
                label.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        layout().finalActive()
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, """
        root.sublayout {
            label.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """)
    }
    
}

extension ViewPrinterTests {
    
    func testUpdateIdentifiers() {
        let rootView = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        let container = TestViewContainer()
        container.root.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(container.root)
        
        container.root.sublayout {
            container.red.sublayout {
                container.button
                container.label
                container.blue.sublayout {
                    container.image
                }
            }
        }
        .finalActive()
        
        let expect = """
        root.sublayout {
            red.sublayout {
                button
                label
                blue.sublayout {
                    image
                }
            }
        }
        """
        
        XCTAssertEqual(
            ViewPrinter(container.root, options: .onlyIdentifier)
                .updateIdentifiers(rootObject: container)
                .description,
            expect
        )
        
        XCTAssertEqual(container.root.accessibilityIdentifier, "root")
        XCTAssertEqual(container.red.accessibilityIdentifier, "red")
        XCTAssertEqual(container.button.accessibilityIdentifier, "button")
        XCTAssertEqual(container.label.accessibilityIdentifier, "label")
        XCTAssertEqual(container.blue.accessibilityIdentifier, "blue")
        XCTAssertEqual(container.image.accessibilityIdentifier, "image")
    }
    
    // This can be a UIViewController or a UIView.
    private final class TestViewContainer {
        let root = UIView()
        let red = UIView()
        let blue = UIView()
        let button = UIButton()
        let label = UILabel()
        let image = UIImageView()
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

// MARK: - options
extension ViewPrinterTests {
    func testViewPrinterOptionIdentifierOnly() {
        let view = IdentifierView(frame: .zero)
        
        XCTAssertEqual(ViewPrinter(view,tags: [view: "view"], options: .onlyIdentifier).description, """
        view.sublayout {
            red.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
        }
        """)
    }
    
    private final class IdentifierView: UIView, Layoutable {
        let red = UIView().identifying("red")
        let blue = UIView()
        
        var activation: Activation?
        
        var layout: some Layout {
            self.sublayout {
                red.anchors {
                    Anchors.cap()
                }
                blue.anchors {
                    Anchors.top.equalTo(red.bottomAnchor)
                    Anchors.shoe()
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
    }
}

// MARK: - withViewConfig
extension ViewPrinterTests {
    func testWithViewConfig() {
        let root = UILabel().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")

        activation = root.config {
            $0.alpha = 0.4
            $0.contentMode = .scaleAspectFit
        }.sublayout {
            child.config {
                $0.alpha = 1.0
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.config {
                    $0.isHidden = true
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                }.anchors {
                    Anchors.allSides()
                }
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
            $0.alpha = 0.4000000059604645
            $0.contentMode = .scaleAspectFit
        }.sublayout {
            child.config {
                $0.accessibilityIdentifier = "child"
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                grandchild.config {
                    $0.accessibilityIdentifier = "grandchild"
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                    $0.isHidden = true
                }.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testWithOutViewConfig() {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")
        let grandchild = UIView().identifying("grandchild")

        activation = root.config {
            $0.alpha = 0.4
        }.sublayout {
            child.config {
                $0.alpha = 1.0
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.config {
                    $0.isHidden = true
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                }.anchors {
                    Anchors.allSides()
                }
            }
        }.active()

        let expect = """
        root.sublayout {
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
        """

        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }

    func testAccessibilityDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UIControl()

        activation = root.sublayout {
            child.config {
                $0.isAccessibilityElement = true
                $0.accessibilityLabel = "accessibilityLabel_child"
                $0.accessibilityHint = "accessibilityHint_child"
                $0.accessibilityIdentifier = "accessibilityIdentifier_child"
                $0.accessibilityTraits = [.button, .image]
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
        }.sublayout {
            accessibilityIdentifier_child.config {
                $0.accessibilityHint = "accessibilityHint_child"
                $0.accessibilityIdentifier = "accessibilityIdentifier_child"
                $0.accessibilityLabel = "accessibilityLabel_child"
                $0.accessibilityTraits = [.button, .image]
                $0.isAccessibilityElement = true
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUIViewDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UIView().identifying("child")

        activation = root.sublayout {
            child.config {
                $0.contentMode = .scaleAspectFill
                $0.semanticContentAttribute = .forceLeftToRight
                $0.tag = 7
                $0.isUserInteractionEnabled = false
                $0.isMultipleTouchEnabled = true
                $0.alpha = 0.9
                $0.backgroundColor = .darkGray
                $0.tintColor = .magenta
                $0.isOpaque = false
                $0.isHidden = true
                $0.clearsContextBeforeDrawing = false
                $0.clipsToBounds = true
                $0.autoresizesSubviews = false
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
        }.sublayout {
            child.config {
                $0.accessibilityIdentifier = "child"
                $0.alpha = 0.8999999761581421
                $0.autoresizesSubviews = false
                $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                $0.clearsContextBeforeDrawing = false
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
                $0.isHidden = true
                $0.isMultipleTouchEnabled = true
                $0.isOpaque = false
                $0.isUserInteractionEnabled = false
                $0.semanticContentAttribute = .forceLeftToRight
                $0.tag = 7
                $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUIControlDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UIControl().identifying("child")
        let friend = UIControl().identifying("friend")

        activation = root.sublayout {
            child.config {
                $0.contentHorizontalAlignment = .trailing
                $0.contentVerticalAlignment = .top
                $0.isSelected = true
                $0.isHighlighted = true
            }
            friend.config {
                $0.isEnabled = false
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
        }.sublayout {
            child.config {
                $0.accessibilityIdentifier = "child"
                $0.contentHorizontalAlignment = .trailing
                $0.contentVerticalAlignment = .top
                $0.isHighlighted = true
                $0.isSelected = true
            }
            friend.config {
                $0.accessibilityIdentifier = "friend"
                $0.isEnabled = false
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUILabelDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UILabel().identifying("child")

        activation = root.sublayout {
            child.config {
                $0.text = "text_child"
                $0.textColor = .gray
                $0.font = .systemFont(ofSize: 16, weight: .semibold)
                $0.adjustsFontForContentSizeCategory = true
                $0.textAlignment = .left
                $0.numberOfLines = 3
                $0.isEnabled = false
                $0.isHighlighted = true
                if #available(iOS 14.0, *), UIDevice.current.userInterfaceIdiom == .mac {
                    $0.showsExpansionTextWhenTruncated = true
                }
                $0.baselineAdjustment = .alignCenters
                $0.lineBreakMode = .byTruncatingHead
                $0.adjustsFontSizeToFitWidth = true
                $0.minimumScaleFactor = 0.5
                $0.allowsDefaultTighteningForTruncation = true
                $0.highlightedTextColor = .blue
                $0.shadowColor = .brown
                $0.shadowOffset = .zero
            }
        }.active()

        let expect: String
        if #available(iOS 14.0, *), UIDevice.current.userInterfaceIdiom == .mac {
            expect =
            """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.adjustsFontForContentSizeCategory = true
                    $0.adjustsFontSizeToFitWidth = true
                    $0.allowsDefaultTighteningForTruncation = true
                    $0.baselineAdjustment = .alignCenters
                    $0.font = /* Modified! Check it manually. (fontName: .SFUI-Semibold, pointSize: 16.0) */
                    $0.highlightedTextColor = /* Modified! Check it manually. (hex: #0000FF, alpha: 1.0) */
                    $0.isEnabled = false
                    $0.isHighlighted = true
                    $0.lineBreakMode = .byTruncatingHead
                    $0.minimumScaleFactor = 0.5
                    $0.numberOfLines = 3
                    $0.shadowColor = /* Modified! Check it manually. (hex: #996633, alpha: 1.0) */
                    $0.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    $0.showsExpansionTextWhenTruncated = true
                    $0.text = "text_child"
                    $0.textAlignment = .left
                    $0.textColor = /* Modified! Check it manually. (hex: #7F7F7F, alpha: 1.0) */
                }
            }
            """
        } else {
            expect =
            """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.adjustsFontForContentSizeCategory = true
                    $0.adjustsFontSizeToFitWidth = true
                    $0.allowsDefaultTighteningForTruncation = true
                    $0.baselineAdjustment = .alignCenters
                    $0.font = /* Modified! Check it manually. (fontName: .SFUI-Semibold, pointSize: 16.0) */
                    $0.highlightedTextColor = /* Modified! Check it manually. (hex: #0000FF, alpha: 1.0) */
                    $0.isEnabled = false
                    $0.isHighlighted = true
                    $0.lineBreakMode = .byTruncatingHead
                    $0.minimumScaleFactor = 0.5
                    $0.numberOfLines = 3
                    $0.shadowColor = /* Modified! Check it manually. (hex: #996633, alpha: 1.0) */
                    $0.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    $0.text = "text_child"
                    $0.textAlignment = .left
                    $0.textColor = /* Modified! Check it manually. (hex: #7F7F7F, alpha: 1.0) */
                }
            }
            """
        }

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUIImageViewDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UIImageView().identifying("child")

        activation = root.sublayout {
            child.config {
                $0.image = UIImage(systemName: "star")
                $0.highlightedImage = UIImage(systemName: "star.fill")
                $0.isHighlighted = true
                $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
        }.sublayout {
            child.config {
                $0.accessibilityIdentifier = "child"
                $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
                $0.highlightedImage = /* Modified! Check it manually. */
                $0.image = /* Modified! Check it manually. */
                $0.isHighlighted = true
                $0.isOpaque = false
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testStackViewDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UIStackView().identifying("child")

        activation = root.sublayout {
            child.config {
                $0.axis = .vertical
                $0.alignment = .leading
                $0.distribution = .fillEqually
                $0.spacing = 5
                $0.isBaselineRelativeArrangement = true
            }
        }.active()

        let expect = """
        root.config {
            $0.accessibilityIdentifier = "root"
        }.sublayout {
            child.config {
                $0.accessibilityIdentifier = "child"
                $0.alignment = .leading
                $0.axis = .vertical
                $0.distribution = .fillEqually
                $0.isBaselineRelativeArrangement = true
                $0.spacing = 5.0
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }
    
    func testSwitchDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = UISwitch().identifying("child")

        activation = root.sublayout {
            child.config { child in
                for subview in child.subviews {
                    subview.removeFromSuperview()
                }
                child.isOn = true
                child.isSelected = true // for testing property from their ancestor(UIControl)
                child.onTintColor = UIColor.orange
                child.thumbTintColor = UIColor.yellow
                child.onImage = UIImage(systemName: "plus")
                child.offImage = UIImage(systemName: "minus")
                if #available(iOS 14.0, *) {
                    child.preferredStyle = .sliding
                }
            }
        }.active()
        
        if #available(iOS 14.0, *) {
            let expect = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.isOn = true
                    $0.isSelected = true
                    $0.offImage = /* Modified! Check it manually. */
                    $0.onImage = /* Modified! Check it manually. */
                    $0.onTintColor = /* Modified! Check it manually. (hex: #FF7F00, alpha: 1.0) */
                    $0.preferredStyle = .sliding
                    $0.thumbTintColor = /* Modified! Check it manually. (hex: #FFFF00, alpha: 1.0) */
                }
            }
            """
            
            let result = ViewPrinter(root, options: .withViewConfig).description
            XCTAssertEqual(result, expect)
        } else {
            let expect = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.isOn = true
                    $0.isSelected = true
                    $0.offImage = /* Modified! Check it manually. */
                    $0.onImage = /* Modified! Check it manually. */
                    $0.onTintColor = /* Modified! Check it manually. (hex: #FF7F00, alpha: 1.0) */
                    $0.thumbTintColor = /* Modified! Check it manually. (hex: #FFFF00, alpha: 1.0) */
                }
            }
            """
            
            let result = ViewPrinter(root, options: .withViewConfig).description
            XCTAssertEqual(result, expect)
        }
    }
}

extension ViewPrinterTests {
    private class CustomConfigurableView: UIView, CustomConfigurableProperties {
        var someFlag: Bool = true
        var someValue: Int = 10
       
        var configurableProperties: [ConfigurableProperty] {
            [
                ConfigurableProperty.property(keypath: \CustomConfigurableView.someFlag, defaultValue: true) { "$0.someFlag = \($0)" },
                ConfigurableProperty.property(keypath: \CustomConfigurableView.someValue, defaultValue: 10) { "$0.someValue = \($0)" }
            ]
        }
    }
    
    func testCustomConfigurableViewDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = CustomConfigurableView().identifying("child")
        
        activation = root.sublayout {
            child.config {
                $0.contentMode = .scaleAspectFill
                $0.semanticContentAttribute = .forceLeftToRight
                $0.tag = 7
                $0.isUserInteractionEnabled = false
                $0.isMultipleTouchEnabled = true
                $0.alpha = 0.9
                $0.backgroundColor = .darkGray
                $0.tintColor = .magenta
                $0.isOpaque = false
                $0.isHidden = true
                $0.clearsContextBeforeDrawing = false
                $0.clipsToBounds = true
                $0.autoresizesSubviews = false
                $0.someFlag = false
                $0.someValue = 1
            }
        }.active()
        
        let expect = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.someFlag = false
                    $0.someValue = 1
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        
        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
        
    }
    
    func testCustomConfigurableViewDefaultConfigurablePropertiesHiddenPropertyIsDefault() {
        let root = UIView().identifying("root")
        let child = CustomConfigurableView().identifying("child")
        
        activation = root.sublayout {
            child.config {
                $0.contentMode = .scaleAspectFill
                $0.semanticContentAttribute = .forceLeftToRight
                $0.tag = 7
                $0.isUserInteractionEnabled = false
                $0.isMultipleTouchEnabled = true
                $0.alpha = 0.9
                $0.backgroundColor = .darkGray
                $0.tintColor = .magenta
                $0.isOpaque = false
                $0.isHidden = true
                $0.clearsContextBeforeDrawing = false
                $0.clipsToBounds = true
                $0.autoresizesSubviews = false
                //                $0.someFlag = false
                $0.someValue = 1
            }
        }.active()
        
        let expect = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.someValue = 1
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        
        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
        
        child.someFlag = false
        child.someValue = 10
        let expect2 = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.someFlag = false
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        let result2 = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result2, expect2)
        
        child.someFlag = true
        let expect3 = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        let result3 = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result3, expect3)
    }
    
}

extension ViewPrinterTests {
    private class CustomRegistedConfigurableView: UIView {
        var someFlag: Bool = true
        var someValue: Int = 10
    }
    
    func testCustomRegistedConfigurableViewDefaultConfigurableProperties() {
        let root = UIView().identifying("root")
        let child = CustomRegistedConfigurableView().identifying("child")
        ConfigurableProperties.default.regist(CustomRegistedConfigurableView.self, defaultReferenceView: CustomRegistedConfigurableView()) { defaultReferenceView in
            [
                ConfigurableProperty.property(keypath: \.someFlag, defaultReferenceView: defaultReferenceView) { "$0.someFlag = \($0)" },
                ConfigurableProperty.property(keypath: \.someValue, defaultReferenceView: defaultReferenceView) { "$0.someValue = \($0)" }
            ]
        }
        
        activation = root.sublayout {
            child.config {
                $0.contentMode = .scaleAspectFill
                $0.semanticContentAttribute = .forceLeftToRight
                $0.tag = 7
                $0.isUserInteractionEnabled = false
                $0.isMultipleTouchEnabled = true
                $0.alpha = 0.9
                $0.backgroundColor = .darkGray
                $0.tintColor = .magenta
                $0.isOpaque = false
                $0.isHidden = true
                $0.clearsContextBeforeDrawing = false
                $0.clipsToBounds = true
                $0.autoresizesSubviews = false
                $0.someFlag = false
                $0.someValue = 1
            }
        }.active()
        
        let expect = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.someFlag = false
                    $0.someValue = 1
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        
        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
        
        child.someFlag = true
        let expect2 = """
            root.config {
                $0.accessibilityIdentifier = "root"
            }.sublayout {
                child.config {
                    $0.accessibilityIdentifier = "child"
                    $0.alpha = 0.8999999761581421
                    $0.autoresizesSubviews = false
                    $0.backgroundColor = /* Modified! Check it manually. (hex: #555555, alpha: 1.0) */
                    $0.clearsContextBeforeDrawing = false
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                    $0.isHidden = true
                    $0.isMultipleTouchEnabled = true
                    $0.isOpaque = false
                    $0.isUserInteractionEnabled = false
                    $0.semanticContentAttribute = .forceLeftToRight
                    $0.someValue = 1
                    $0.tag = 7
                    $0.tintColor = /* Modified! Check it manually. (hex: #FF00FF, alpha: 1.0) */
                }
            }
            """
        
        let result2 = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result2, expect2)
        
    }
    
}
