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
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        
        activation = root.sl.sublayout {
            child
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoViews() throws {
        let root = UIView().sl.identifying("root")
        let a = UIView().sl.identifying("a")
        let b = UIView().sl.identifying("b")
        
        activation = root.sl.sublayout {
            a
            b
        }.active()
        
        let expect = """
        root.sl.sublayout {
            a
            b
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwoDepthOfViews() throws {
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let grandchild = UIView().sl.identifying("grandchild")
        
        activation = root.sl.sublayout {
            child.sl.sublayout {
                grandchild
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.sublayout {
                grandchild
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithMultipleDepthOfViews() throws {
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let friend = UIView().sl.identifying("friend")
        let grandchild = UIView().sl.identifying("grandchild")
        
        activation = root.sl.sublayout {
            child.sl.sublayout {
                grandchild
            }
            friend
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.sublayout {
                grandchild
            }
            friend
        }
        """
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testTopBottomAndEquals() {
        let root = UIView().sl.identifying("root")
        let one = UIView().sl.identifying("one")
        let two = UIView().sl.identifying("two")
        
        func layout() -> some Layout {
            root.sl.sublayout {
                one.sl.anchors {
                    Anchors.bottom
                    Anchors.leading.trailing
                }
                two.sl.anchors {
                    Anchors.top.equalTo(one.bottomAnchor)
                    Anchors.width.equalTo(one)
                    Anchors.centerX.equalTo(one)
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root.sl.sublayout {
            one.sl.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
            two.sl.anchors {
                Anchors.top.equalTo(one, attribute: .bottom)
                Anchors.width.equalTo(one)
                Anchors.centerX.equalTo(one)
            }
        }
        """)
    }
    
    func testSizeWithConstant() {
        let root = UIView().sl.identifying("root")
        let one = UIView().sl.identifying("one")
        
        root.sl.sublayout {
            one.sl.anchors {
                Anchors.width.equalTo(root, constant: -20.0)
            }
        }.finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root.sl.sublayout {
            one.sl.anchors {
                Anchors.width.equalToSuper(constant: -20.0)
            }
        }
        """)
    }
    
    func testPrintWithAnchorsWithOneDepth() {
        let root = UIView().sl.identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().sl.identifying("child")
        activation = root.sl.sublayout {
            child.sl.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithAnchorsOfTwoViewWithOneDepth() {
        let root = UIView().sl.identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().sl.identifying("child")
        let friend = UIView().sl.identifying("friend")
        activation = root.sl.sublayout {
            child.sl.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.sl.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top
                Anchors.bottom.equalToSuper(constant: -10.0)
            }
            friend.sl.anchors {
                Anchors.top.equalTo(child, attribute: .bottom)
            }
        }
        """
        
        let result = ViewPrinter(root).description
        XCTAssertEqual(result, expect)
    }

    func testPrintWithAnonymousTaggedView() {
        let root = UIView().sl.identifying("root")
        activation = root.sl.sublayout {
            UILabel().sl.identifying("label").sl.anchors {
                Anchors.allSides()
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            label.sl.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """
        
        let result = ViewPrinter(root).description
        
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithTwwDepthsWithSublayout() throws {
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let grandchild = UIView().sl.identifying("grandchild")
        
        activation = root.sl.sublayout {
            child.sl.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.sl.anchors {
                    Anchors.allSides()
                }
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                grandchild.sl.anchors {
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
        let root = UIView().sl.identifying("root")
        let child = UILabel()
        let grand = UILabel().sl.identifying("grand")
        
        activation = root.sl.sublayout {
            child.sl.sublayout {
                grand.sl.anchors {
                    Anchors.top
                }
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.sublayout {
                grandchild.sl.anchors {
                    Anchors.top
                }
            }
        }
        """
        
        let result = ViewPrinter(root, tags: [child: "child", grand: "grandchild"]).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintWithSafeAreaLayoutGuide() {
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        activation = root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.bottom.equalTo(root.safeAreaLayoutGuide)
                Anchors.leading
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
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
        contentView.sl.sublayout {
            profileView:\(UIImageView.self)
            nameLabel:\(UILabel.self)
        }
        """
        
        let result = ViewPrinter(cell, tags: [cell: "contentView"]).updateIdentifiers(.withTypeOfView).description
        XCTAssertEqual(result, expect)
    }
    
    func testPrintMoreEfficiently() {
        let root = UIView().sl.identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().sl.identifying("child")
        let friend = UIView().sl.identifying("friend")
        
        activation = root.sl.sublayout {
            child.sl.anchors {
                Anchors.cap()
            }
            friend.sl.anchors {
                Anchors.leading
                Anchors.bottom
                Anchors.top.greaterThanOrEqualTo(child, attribute: .bottom, constant: 8)
                Anchors.trailing.equalTo(child)
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
            friend.sl.anchors {
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
        let root = UIView().sl.identifying("root")
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().sl.identifying("child")
        let friend = UIView().sl.identifying("friend")
        activation = root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.greaterThanOrEqualToSuper()
                Anchors.bottom.lessThanOrEqualToSuper()
                Anchors.height.equalTo(constant: 12.0)
            }
            friend.sl.anchors {
                Anchors.height.equalTo(child)
            }
        }.active()
        
        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.greaterThanOrEqualToSuper()
                Anchors.bottom.lessThanOrEqualToSuper()
                Anchors.height.equalTo(constant: 12.0)
            }
            friend.sl.anchors {
                Anchors.height.equalTo(child)
            }
        }
        """
        
        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
    
    func testPrintSize() {

        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        
        func layout() -> some Layout {
            root.sl.sublayout {
                child.sl.anchors {
                    Anchors.width.height
                }
            }
        }
        
        layout().finalActive()
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root.sl.sublayout {
            child.sl.anchors {
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
            self.sl.sublayout {
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
        gont.sl.sublayout {
            sea:\(UILabel.self).sl.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                duny:Duny.sl.anchors {
                    Anchors.centerX.equalToSuper().multiplier(1.2000000476837158)
                    Anchors.centerY.equalToSuper().multiplier(0.800000011920929)
                }.sublayout {
                    duny.nickname:\(UILabel.self).sl.anchors {
                        Anchors.top
                        Anchors.leading.trailing
                    }.sublayout {
                        sparrowhawk.sl.anchors {
                            Anchors.top.bottom
                            Anchors.leading.trailing
                        }
                    }
                    duny.truename:\(UILabel.self).sl.anchors {
                        Anchors.top.equalTo(duny.nickname:UILabel, attribute: .bottom)
                        Anchors.bottom
                        Anchors.leading.trailing
                    }.sublayout {
                        ged.sl.anchors {
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
            self.sl.sublayout {
                sea.sl.anchors {
                    Anchors.allSides()
                } .sublayout {
                    duny.sl.anchors {
                        Anchors.centerX.equalToSuper().multiplier(1.2)
                        Anchors.centerY.equalToSuper().multiplier(0.8)
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
            self.sl.sublayout {
                nickname.sl.anchors {
                    Anchors.cap()
                }.sublayout {
                    UIView().sl.identifying("sparrowhawk").sl.anchors {
                        Anchors.allSides()
                    }
                }
                truename.sl.anchors {
                    Anchors.top.equalTo(nickname.bottomAnchor)
                    Anchors.shoe()
                }.sublayout {
                    UIView().sl.identifying("ged").sl.anchors {
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
        
        let root = UIView().sl.identifying("root")
        let label = UILabel().sl.identifying("label")
        label.font = .systemFont(ofSize: 12)
        label.text = "HELLO"
        @LayoutBuilder
        func layout() -> some Layout {
            root.sl.sublayout {
                label.sl.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        layout().finalActive()
        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, """
        root.sl.sublayout {
            label.sl.anchors {
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
        
        container.root.sl.sublayout {
            container.red.sl.sublayout {
                container.button
                container.label
                container.blue.sl.sublayout {
                    container.image
                }
            }
        }
        .finalActive()
        
        let expect = """
        root.sl.sublayout {
            red.sl.sublayout {
                button
                label
                blue.sl.sublayout {
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
        view.sl.sublayout {
            red.sl.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
        }
        """)
    }
    
    private final class IdentifierView: UIView, Layoutable {
        let red = UIView().sl.identifying("red")
        let blue = UIView()
        
        var activation: Activation?
        
        var layout: some Layout {
            self.sl.sublayout {
                red.sl.anchors {
                    Anchors.cap()
                }
                blue.sl.anchors {
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
        let root = UILabel().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let grandchild = UIView().sl.identifying("grandchild")

        activation = root.sl.onActivate {
            $0.alpha = 0.4
            $0.contentMode = .scaleAspectFit
        }.sublayout {
            child.sl.onActivate {
                $0.alpha = 1.0
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.sl.onActivate {
                    $0.isHidden = true
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                }.anchors {
                    Anchors.allSides()
                }
            }
        }.active()

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
            $0.alpha = 0.4000000059604645
            $0.contentMode = .scaleAspectFit
        }.sl.sublayout {
            child.sl.onActivate {
                $0.accessibilityIdentifier = "child"
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.sl.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                grandchild.sl.onActivate {
                    $0.accessibilityIdentifier = "grandchild"
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                    $0.isHidden = true
                }.sl.anchors {
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
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let grandchild = UIView().sl.identifying("grandchild")

        activation = root.sl.onActivate {
            $0.alpha = 0.4
        }.sublayout {
            child.sl.onActivate {
                $0.alpha = 1.0
                $0.accessibilityLabel = "child-accessibilityLabel"
            }.anchors{
                Anchors.allSides()
            }.sublayout {
                grandchild.sl.onActivate {
                    $0.isHidden = true
                    $0.accessibilityLabel = "grandchild-accessibilityLabel"
                }.anchors {
                    Anchors.allSides()
                }
            }
        }.active()

        let expect = """
        root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                grandchild.sl.anchors {
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
        let root = UIView().sl.identifying("root")
        let child = UIControl()

        activation = root.sl.sublayout {
            child.sl.onActivate {
                $0.isAccessibilityElement = true
                $0.accessibilityLabel = "accessibilityLabel_child"
                $0.accessibilityHint = "accessibilityHint_child"
                $0.accessibilityIdentifier = "accessibilityIdentifier_child"
                $0.accessibilityTraits = [.button, .image]
            }
        }.active()

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            accessibilityIdentifier_child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")

        activation = root.sl.sublayout {
            child.sl.onActivate {
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
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = UIControl().sl.identifying("child")
        let friend = UIControl().sl.identifying("friend")

        activation = root.sl.sublayout {
            child.sl.onActivate {
                $0.contentHorizontalAlignment = .trailing
                $0.contentVerticalAlignment = .top
                $0.isSelected = true
                $0.isHighlighted = true
            }
            friend.sl.onActivate {
                $0.isEnabled = false
            }
        }.active()

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            child.sl.onActivate {
                $0.accessibilityIdentifier = "child"
                $0.contentHorizontalAlignment = .trailing
                $0.contentVerticalAlignment = .top
                $0.isHighlighted = true
                $0.isSelected = true
            }
            friend.sl.onActivate {
                $0.accessibilityIdentifier = "friend"
                $0.isEnabled = false
            }
        }
        """

        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUILabelDefaultConfigurableProperties() {
        let root = UIView().sl.identifying("root")
        let child = UILabel().sl.identifying("child")

        activation = root.sl.sublayout {
            child.sl.onActivate {
                $0.text = "text_child"
                $0.textColor = .gray
                $0.font = .systemFont(ofSize: 16, weight: .semibold)
                $0.adjustsFontForContentSizeCategory = true
                $0.textAlignment = .left
                $0.numberOfLines = 3
                $0.isEnabled = false
                $0.isHighlighted = true
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

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            child.sl.onActivate {
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
        let result = ViewPrinter(root, options: .withViewConfig).description
        XCTAssertEqual(result, expect)
    }

    func testUIImageViewDefaultConfigurableProperties() {
        let root = UIView().sl.identifying("root")
        let child = UIImageView().sl.identifying("child")

        activation = root.sl.sublayout {
            child.sl.onActivate {
                $0.image = UIImage(systemName: "star")
                $0.highlightedImage = UIImage(systemName: "star.fill")
                $0.isHighlighted = true
                $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            }
        }.active()

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = UIStackView().sl.identifying("child")

        activation = root.sl.sublayout {
            child.sl.onActivate {
                $0.axis = .vertical
                $0.alignment = .leading
                $0.distribution = .fillEqually
                $0.spacing = 5
                $0.isBaselineRelativeArrangement = true
            }
        }.active()

        let expect = """
        root.sl.onActivate {
            $0.accessibilityIdentifier = "root"
        }.sl.sublayout {
            child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = UISwitch().sl.identifying("child")

        activation = root.sl.sublayout {
            child.sl.onActivate { child in
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = CustomConfigurableView().sl.identifying("child")
        
        activation = root.sl.sublayout {
            child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = CustomConfigurableView().sl.identifying("child")
        
        activation = root.sl.sublayout {
            child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
        let root = UIView().sl.identifying("root")
        let child = CustomRegistedConfigurableView().sl.identifying("child")
        ConfigurableProperties.default.regist(CustomRegistedConfigurableView.self, defaultReferenceView: CustomRegistedConfigurableView()) { defaultReferenceView in
            [
                ConfigurableProperty.property(keypath: \.someFlag, defaultReferenceView: defaultReferenceView) { "$0.someFlag = \($0)" },
                ConfigurableProperty.property(keypath: \.someValue, defaultReferenceView: defaultReferenceView) { "$0.someValue = \($0)" }
            ]
        }
        
        activation = root.sl.sublayout {
            child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
            root.sl.onActivate {
                $0.accessibilityIdentifier = "root"
            }.sl.sublayout {
                child.sl.onActivate {
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
