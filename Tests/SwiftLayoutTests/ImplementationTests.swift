import XCTest
@testable import SwiftLayoutUtil
@testable import SwiftLayout


/// test cases for api rules except DSL syntax
final class ImplementationTests: XCTestCase {
    
    var window: UIView!
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    var friend = UIView().viewTag.friend
    
    var activation: Activation?
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        friend = UIView().viewTag.friend
        window.addSubview(root)
    }
    
    override func tearDownWithError() throws {
        activation = nil
    }
}

extension ImplementationTests {
    func testLayoutTraversal() {
        let root: UIView = UIView().viewTag.root
        let button: UIButton = UIButton().viewTag.button
        let label: UILabel = UILabel().viewTag.label
        let redView: UIView = UIView().viewTag.redView
        let image: UIImageView = UIImageView().viewTag.image
        
        let layout = root {
            redView
            label {
                button
                image
            }
        }
        
        var result: [String] = []
        for viewInformation in LayoutElements(layout: layout).viewInformations {
            let superDescription = viewInformation.superview?.accessibilityIdentifier ?? "nil"
            let currentDescription = viewInformation.view?.accessibilityIdentifier ?? "nil"
            let description = "\(superDescription), \(currentDescription)"
            result.append(description)
        }
        
        let expectedResult = [
            "nil, root",
            "root, redView",
            "root, label",
            "label, button",
            "label, image",
        ]
        
        XCTAssertEqual(expectedResult, result)
    }
    
    
    func testLayoutFlattening() {
        let layout = root {
            child.anchors {
                Anchors.allSides()
            }.sublayout {
                friend.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        XCTAssertNotNil(layout)
        XCTAssertEqual(LayoutElements(layout: layout).viewInformations.map(\.view), [root, child, friend])
    }
    
    func testLayoutCompare() {
        let f1 = root {
            child
        }
        let e1 = LayoutElements(layout: f1)
        
        let f2 = root {
            child
        }
        let e2 = LayoutElements(layout: f2)
        
        let f3 = root {
            child.anchors { Anchors.allSides() }
        }
        let e3 = LayoutElements(layout: f3)
        
        let f4 = root {
            child.anchors { Anchors.allSides() }
        }
        let e4 = LayoutElements(layout: f4)
        
        let f5 = root {
            child.anchors { Anchors.cap() }
        }
        let e5 = LayoutElements(layout: f5)
        
        let f6 = root {
            friend.anchors { Anchors.allSides() }
        }
        let e6 = LayoutElements(layout: f6)
        
        XCTAssertEqual(e1.viewInformations, e2.viewInformations)
        XCTAssertEqual(e1.viewConstraints.weakens, e2.viewConstraints.weakens)
        
        XCTAssertEqual(e3.viewInformations, e4.viewInformations)
        XCTAssertEqual(e3.viewConstraints.weakens, e4.viewConstraints.weakens)
        
        XCTAssertEqual(e4.viewInformations, e5.viewInformations)
        XCTAssertNotEqual(e4.viewConstraints.weakens, e5.viewConstraints.weakens)
        
        XCTAssertNotEqual(e5.viewInformations, e6.viewInformations)
        XCTAssertNotEqual(e5.viewConstraints.weakens, e6.viewConstraints.weakens)
    }
    
    func testSetAccessibilityIdentifier() {
        class TestView: UIView {
            let contentView = UIView()
            let nameLabel = UILabel()
        }
        
        let view = TestView()
        IdentifierUpdater.withTypeOfView.update(view)
        
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
        
        class Test2View: TestView {}
        
        let view2 = Test2View()
        IdentifierUpdater.withTypeOfView.update(view2)
        
        XCTAssertEqual(view2.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view2.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
    }
    
    func testDontTouchRootViewByDeactive() {
        let root = UIView().viewTag.root
        let red = UIView().viewTag.red
        let old = UIView().viewTag.old
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        activation = root {
            red.anchors {
                Anchors.allSides()
            }
        }.active()
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        
        activation?.deactive()
        activation = nil
        
        XCTAssertEqual(root.superview, old)
    }
    
}

extension ImplementationTests {
    final class IdentifiedView: UIView, Layoutable {
        
        lazy var contentView: UIView = UIView()
        lazy var nameLabel: UILabel = UILabel()
        
        var activation: Activation?
        
        var layout: some Layout {
            contentView {
                nameLabel
            }
        }
        
        init() {
            super.init(frame: .zero)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func testNoAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        XCTAssertEqual(view.contentView.accessibilityIdentifier ?? "", "")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier ?? "", "")
    }
    
    func testAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        ViewPrinter(view).updateIdentifiers()
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel")
    }
}

extension ImplementationTests {
    func testIdentifier() {
        let activation = root {
            UILabel().identifying("label").anchors {
                Anchors.cap()
            }
            UIView().identifying("secondView").anchors {
                Anchors.top.equalTo("label", attribute: .bottom)
                Anchors.shoe()
            }
        }.active()
        
        let label = activation.viewForIdentifier("label")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.accessibilityIdentifier, "label")
        
        let secondView = activation.viewForIdentifier("secondView")
        XCTAssertEqual(secondView?.accessibilityIdentifier, "secondView")
        
        let currents = activation.constraints
        let labelConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(labelConstraints), labelConstraints)
        
        let secondViewConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(secondViewConstraints), secondViewConstraints)
        
        let constraintsBetweebViews = Set(AnchorsContainer(Anchors.top.equalTo(label!, attribute: .bottom)).constraints(item: secondView!, toItem: label).weakens)
        XCTAssertEqual(currents.intersection(constraintsBetweebViews), constraintsBetweebViews)
    }
    
    func testDebugLayoutStructurePrint() {
        let root: UIView = UIView().viewTag.root
        let contentView: UIView = UIView().viewTag.contentView
        let image: UIImageView = UIImageView().viewTag.image
        let title: UILabel = UILabel().viewTag.title
        let description: UILabel = UILabel().viewTag.description
        
        let layout = root {
            contentView.anchors {
                Anchors.leading.equalTo(root.safeAreaLayoutGuide, constant: 16.0)
                Anchors.trailing.equalTo(root.safeAreaLayoutGuide, constant: -16.0)
                Anchors.centerY.equalTo(root)
                Anchors.height.equalTo(constant: 80.0)
            }.sublayout {
                image.anchors {
                    Anchors.leading.equalToSuper(constant: 10.0)
                    Anchors.centerY
                    Anchors.size(width: 70, height: 70)
                }
                
                title.anchors {
                    Anchors.top.equalToSuper(constant: 8.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.height.equalTo(constant: 24.0)
                }.anyLayout
                
                description.anchors {
                    Anchors.top.equalTo(title, attribute: .bottom, constant: 5.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.bottom.equalToSuper(constant: -8.0)
                    Anchors.trailing.equalToSuper(constant: -10.0)
                }
            }
        }
        
        let expectedResult = """
        ViewLayout - view: root
        └─ ViewLayout - view: contentView
           └─ TupleLayout
              ├─ ViewLayout - view: image
              ├─ AnyLayout
              │  └─ ViewLayout - view: title
              └─ ViewLayout - view: description
        """
        
        XCTAssertEqual(LayoutPrinter.print(layout), expectedResult)
    }
    
    func testDebugLayoutStructurePrintWithAnchors() {
        let root: UIView = UIView().viewTag.root
        let contentView: UIView = UIView().viewTag.contentView
        let image: UIImageView = UIImageView().viewTag.image
        let title: UILabel = UILabel().viewTag.title
        let description: UILabel = UILabel().viewTag.description
        
        let layout = root {
            contentView.anchors {
                Anchors.leading.equalTo(root.safeAreaLayoutGuide, constant: 16.0)
                Anchors.trailing.equalTo(root.safeAreaLayoutGuide, constant: -16.0)
                Anchors.centerY.equalTo(root)
                Anchors.height.equalTo(constant: 80.0)
            }.sublayout {
                image.anchors {
                    Anchors.leading.equalToSuper(constant: 10.0)
                    Anchors.centerY
                    Anchors.size(width: 70, height: 70)
                }
                
                title.anchors {
                    Anchors.top.equalToSuper(constant: 8.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.height.equalTo(constant: 24.0)
                }.anyLayout
                
                description.anchors {
                    Anchors.top.equalTo(title, attribute: .bottom, constant: 5.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.bottom.equalToSuper(constant: -8.0)
                    Anchors.trailing.equalToSuper(constant: -10.0)
                }
            }
        }
        
        let expectedResult = """
        ViewLayout - view: root
        └─ ViewLayout - view: contentView
           │     .leading == root.safeAreaLayoutGuide.leading + 16.0
           │     .trailing == root.safeAreaLayoutGuide.trailing - 16.0
           │     .centerY == root.centerY
           │     .height == + 80.0
           └─ TupleLayout
              ├─ ViewLayout - view: image
              │        .leading == superview.leading + 10.0
              │        .centerY == superview.centerY
              │        .width == + 70.0
              │        .height == + 70.0
              ├─ AnyLayout
              │  └─ ViewLayout - view: title
              │           .top == superview.top + 8.0
              │           .leading == image.trailing + 10.0
              │           .height == + 24.0
              └─ ViewLayout - view: description
                       .top == title.bottom + 5.0
                       .leading == image.trailing + 10.0
                       .bottom == superview.bottom - 8.0
                       .trailing == superview.trailing - 10.0
        """
        
        XCTAssertEqual(LayoutPrinter.print(layout, withAnchors: true), expectedResult)
    }
}

extension ImplementationTests {
    func testAnchorConstraint() {
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false

        let constraints = Anchors.allSides().constraints(item: child, toItem: root)

        NSLayoutConstraint.activate(constraints)

        root.frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 200, height: 200))
        root.removeConstraints(constraints)

        let constraints1 = AnchorsContainer(Anchors.top).constraints(item: child, toItem: root)
        let constraints2 = AnchorsContainer(Anchors.leading).constraints(item: child, toItem: root)
        let constraints3 = AnchorsContainer(Anchors.width.height.equalTo(constant: 98)).constraints(item: child, toItem: nil)

        NSLayoutConstraint.activate(constraints1)
        NSLayoutConstraint.activate(constraints2)
        NSLayoutConstraint.activate(constraints3)

        root.layoutIfNeeded()
        child.setNeedsLayout()
        child.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 98, height: 98))
    }

    func testSelfContraint() {
        let superview = UIView().viewTag.superview
        let subview = UIView().viewTag.subview

        let constraint = subview.widthAnchor.constraint(equalToConstant: 24)

        XCTAssertEqual(constraint.firstItem as? NSObject, subview)
        XCTAssertNil(constraint.secondItem)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)
        XCTAssertEqual(constraint.constant, 24)

        let anchor = AnchorsContainer(Anchors.width.equalTo(constant: 24)).constraints(item: subview, toItem: superview).first!

        XCTAssertEqual(anchor.firstItem as? NSObject, subview)
        XCTAssertNil(anchor.secondItem)
        XCTAssertEqual(anchor.firstAttribute, .width)
        XCTAssertEqual(anchor.secondAttribute, .notAnAttribute)
        XCTAssertEqual(anchor.constant, 24)
    }

    func testAnchorsBuilder() {
        func build(@AnchorsBuilder _ build: () -> AnchorsContainer) -> AnchorsContainer {
            build()
        }

        let anchors: AnchorsContainer = build {
            Anchors.top.equalToSuper(constant: 12.0)
            Anchors.leading.equalToSuper(constant: 13.0)
            Anchors.trailing.equalToSuper(constant: -13.0)
            Anchors.bottom
        }

        child.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(child)

        let constraint = anchors.constraints(item: child, toItem: root)
        XCTAssertEqual(constraint.count, 4)
    }

    func testIgnoreAnchorsDuplication() {
        root {
            child.anchors {
                Anchors.allSides()
                Anchors.cap()
                Anchors.shoe()
                Anchors.height
                Anchors.width
                Anchors.width.equalTo(constant: 24.0)
            }
        }.finalActive()

        
        XCTAssertEqual(root.constraints.shortDescription, """
        child.top == root.top
        child.leading == root.leading
        child.height == root.height
        child.width == root.width
        child.trailing == root.trailing
        child.bottom == root.bottom
        """.descriptions)
        XCTAssertEqual(child.constraints.shortDescription, """
        child.width == + 24.0
        """.descriptions)
        
        XCTAssertEqual(ViewPrinter(root).print(), """
        root {
            child.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
                Anchors.width.equalTo(constant: 24.0)
                Anchors.width.height.equalToSuper()
            }
        }
        """.tabbed)
    }

    func testIgnoreAnchorsDuplication2() {
        root {
            child.anchors {
                Anchors.cap()
                Anchors.height.equalTo(constant: 44)
                Anchors.height.equalTo(constant: 44)
            }
        }.finalActive()

        let expect = """
        root {
            child.anchors {
                Anchors.top
                Anchors.leading.trailing
                Anchors.height.equalTo(constant: 44.0)
            }
        }
        """

        XCTAssertEqual(ViewPrinter(root).print(), expect.tabbed)
    }

    func testRules() {
        let root = UIView().viewTag.root
        root.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(root)
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend

        enum TestCase {
            case topEqualToNameless
            case topEqualToSuper
            case topEqualToSuperWithConstant
            case topGreaterThanOrEqualToNameless
            case topGreaterThanOrEqualToSuperWithConstant
            case topGreaterThanOrEqualToSuper
            case topLessThanOrEqualToNameless
            case topLessThanOrEqualToSuper
            case topLessThanOrEqualToSuperWithConstant

            case topOfFriendEqualToBottomOfChild
            case widthOfFriendEqualToNameless
            case widthOfFriendEqualToSuper
            case widthOfFriendEqualToChild
            case widthOfFriendEqualToHeightOfChild
            case widthOfFriendEqualToConstant
            case widthOfFriendEqualToChildWithConstant
        }

        var test = TestCase.topEqualToNameless
        @LayoutBuilder
        func layout() -> Layout {
            root {
                child.anchors {
                    switch test {
                    case .topEqualToNameless:
                        Anchors.top
                    case .topEqualToSuper:
                        Anchors.top.equalTo(root)
                    case .topEqualToSuperWithConstant:
                        Anchors.top.equalTo(root, constant: 78.0)
                    case .topGreaterThanOrEqualToNameless:
                        Anchors.top.greaterThanOrEqualToSuper()
                    case .topGreaterThanOrEqualToSuper:
                        Anchors.top.greaterThanOrEqualTo(root)
                    case .topGreaterThanOrEqualToSuperWithConstant:
                        Anchors.top.greaterThanOrEqualTo(root, constant: 78.0)
                    case .topLessThanOrEqualToNameless:
                        Anchors.top.lessThanOrEqualToSuper()
                    case .topLessThanOrEqualToSuper:
                        Anchors.top.lessThanOrEqualTo(root)
                    case .topLessThanOrEqualToSuperWithConstant:
                        Anchors.top.lessThanOrEqualTo(root, constant: 78.0)
                    default:
                        Anchors.cap()
                    }
                }
                friend.anchors {
                    switch test {
                    case .topOfFriendEqualToBottomOfChild:
                        Anchors.top.equalTo(child, attribute: .bottom)
                        Anchors.shoe()
                    case .widthOfFriendEqualToNameless:
                        Anchors.width
                        Anchors.shoe()
                    case .widthOfFriendEqualToSuper:
                        Anchors.width.equalTo(root)
                        Anchors.shoe()
                    case .widthOfFriendEqualToChild:
                        Anchors.width.equalTo(child)
                        Anchors.shoe()
                    case .widthOfFriendEqualToHeightOfChild:
                        Anchors.width.equalTo(child, attribute: .height)
                        Anchors.shoe()
                    case .widthOfFriendEqualToConstant:
                        Anchors.width.equalTo(constant: 78.0)
                        Anchors.shoe()
                    case .widthOfFriendEqualToChildWithConstant:
                        Anchors.width.equalTo(child, constant: 78.0)
                        Anchors.leading
                        Anchors.bottom
                    default:
                        Anchors.shoe()
                    }
                }
            }
        }

        context("top equal to nameless") {
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super") {
            test = .topEqualToSuper
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super with constant of 78.0") {
            test = .topEqualToSuperWithConstant
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal, constant: 78.0).count, 1)
        }

        context("top greater than or equal to nameless") {
            test = .topGreaterThanOrEqualToNameless
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }

        context("top greater than or equal to nameless with constant of 78.0") {
            test = .topGreaterThanOrEqualToSuperWithConstant
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual, constant: 78.0).count, 1)
        }

        context("top greater than or equal to super") {
            test = .topGreaterThanOrEqualToSuper
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }

        context("top less than or equal to nameless") {
            test = .topLessThanOrEqualToNameless
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }

        context("top less than or equal to super") {
            test = .topLessThanOrEqualToSuper
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }

        context("top less than or equal to super with constant of 78.0") {
            test = .topLessThanOrEqualToSuperWithConstant
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual, constant: 78.0).count, 1)
        }

        context("top of friend equal to bottom of child") {
            test = .topOfFriendEqualToBottomOfChild
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }

        context("top of friend equal to bottom of child") {
            test = .topOfFriendEqualToBottomOfChild
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }

        context("width of friend equal to width of nameless") {
            test = .widthOfFriendEqualToNameless
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }

        context("width of friend equal to width of super") {
            test = .widthOfFriendEqualToSuper
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }

        context("width of friend equal to width of child") {
            test = .widthOfFriendEqualToChild
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .width), relation: .equal).count, 1)
        }

        context("width of friend equal to height of child") {
            test = .widthOfFriendEqualToHeightOfChild
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .height), relation: .equal).count, 1)
        }

        context("width of friend equal to constant of 78.0") {
            test = .widthOfFriendEqualToConstant
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, nil), attributes: (.width, .notAnAttribute), relation: .equal, constant: 78.0).count, 1)
        }

        context("width of friend equal to child with constant of 78.0") {
            test = .widthOfFriendEqualToChildWithConstant
            activation = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .width), relation: .equal, constant: 78.0).count, 1)
        }
    }

}

extension ImplementationTests {
    func testFinalActive() {
        let root = UIView().viewTag.root
        let cap = UIView().viewTag.cap
        let shoe = UIView().viewTag.shoe

        root {
            cap.anchors {
                Anchors.cap()
            }
            shoe.anchors {
                Anchors.shoe()
            }
        }.finalActive()

        let expect = """
        root {
            cap.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
            shoe.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).print(), expect)
    }
}

// MARK: - Anchors only
extension ImplementationTests {
    func testAnchorsOnly() {
        let fixedView = UIView(frame: .init(x: 0, y: 0, width: 120, height: 120))
        fixedView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(fixedView)
        fixedView.anchors {
            Anchors.width.height.equalTo(constant: 24.0)
        }.finalActive()
        
        let identifier = fixedView.tagDescription
        XCTAssertEqual(fixedView.constraints.shortDescription, """
        \(identifier).width == + 24.0
        \(identifier).height == + 24.0
        """.descriptions)
        
        XCTAssertEqual(ViewPrinter(fixedView, tags: [fixedView: "fixedView"]).print(), """
        fixedView.anchors {
            Anchors.width.height.equalTo(constant: 24.0)
        }
        """.tabbed)
    }
    
    func testConveniencesOfAnchors() {
        let fixedView = UIView().viewTag.fixedView
        fixedView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(fixedView)
        fixedView.anchors {
            Anchors.size(width: 32.0, height: 32.0)
        }.finalActive()
        
        let size = fixedView.systemLayoutSizeFitting(.zero)
        XCTAssertEqual(size, .init(width: 32.0, height: 32.0))
    }
}

// MARK: - Decorations
extension ImplementationTests {

    func testFeatureCompose() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).identifying("root").anchors({ }).sublayout {
            UILabel().config({ label in
                label.text = "hello"
            }).identifying("child").anchors {
                Anchors.allSides()
            }
        }.active()

        let expect = """
        root {
            child.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).print(), expect)
    }

    func testFeatureComposeComplex() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).sublayout {
            UILabel().config { label in
                label.text = "HELLO"
            }.identifying("hellolabel").anchors {
                Anchors.cap()
            }.sublayout {
                UIView().identifying("lastview").anchors {
                    Anchors.allSides()
                }
            }
            UIButton().identifying("button").anchors {
                Anchors.shoe()
            }
        }.active()

        let expect = """
        root {
            hellolabel.anchors {
                Anchors.top
                Anchors.leading.trailing
            }.sublayout {
                lastview.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
            button.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).print(options: .onlyIdentifier), expect)
    }

    func testFeatureComposeComplexWithAnimationHandling() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).sublayout {
            UILabel().config { label in
                label.text = "HELLO"
            }.identifying("hellolabel").anchors {
                Anchors.cap()
            }.sublayout {
                UIView().identifying("lastview").anchors {
                    Anchors.allSides()
                }
            }
            UIButton().identifying("button").anchors {
                Anchors.shoe()
            }
        }.active()

        let expect = """
        root {
            hellolabel.anchors {
                Anchors.top
                Anchors.leading.trailing
            }.sublayout {
                lastview.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
            button.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).print(options: .onlyIdentifier), expect)
    }

}

// MARK: - LayoutProperty
extension ImplementationTests {
    
    func testLayoutProperty() {
        let test = TestView().viewTag.test
        
        XCTAssertEqual(test.trueView.superview, test)
        XCTAssertNil(test.falseView.superview)
        
        test.flag = false
        XCTAssertEqual(test.falseView.superview, test)
        XCTAssertNil(test.trueView.superview)
    }
    
    private class TestView: UIView, Layoutable {
        
        @LayoutProperty var flag = true
        
        var trueView = UIView().viewTag.true
        var falseView = UIView().viewTag.false
        
        var activation: Activation?
        
        var layout: some Layout {
            self {
                if flag {
                    trueView
                } else {
                    falseView
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            sl.updateLayout()
        }
    }
}
