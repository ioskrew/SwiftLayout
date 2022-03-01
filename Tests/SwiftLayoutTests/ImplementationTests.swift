import XCTest
import UIKit
@testable import SwiftLayout

/// test cases for api rules except DSL syntax
final class ImplementationTests: XCTestCase {
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    var friend = UIView().viewTag.friend
    
    var deactivable: Deactivable?
   
    override func setUpWithError() throws {
        continueAfterFailure = false
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        friend = UIView().viewTag.friend
    }
    
    override func tearDownWithError() throws {
        deactivable = nil
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
        for viewInformation in layout.viewInformations {
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
    
    func testViewStrongReferenceCycle() {
        class DeinitView: UIView {
            static var deinitCount: Int = 0
            
            deinit {
                Self.deinitCount += 1
            }
        }
        
        class SelfReferenceView: UIView, LayoutBuilding {
            var layout: some Layout {
                self {
                    DeinitView().anchors {
                        Anchors.allSides()
                    }.sublayout {
                        DeinitView()
                    }
                }
            }
            
            var deactivable: Deactivable?
        }
        
        DeinitView.deinitCount = 0
        var view: SelfReferenceView? = SelfReferenceView()
        weak var weakView: UIView? = view
        
        view?.updateLayout()
        view = nil
        
        XCTAssertNil(weakView)
        XCTAssertEqual(DeinitView.deinitCount, 2)
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
        XCTAssertEqual(layout.viewInformations.map(\.view), [root, child, friend])
    }
    
    func testLayoutCompare() {
        let f1 = root {
            child
        }

        let f2 = root {
           child
        }

        let f3 = root {
            child.anchors { Anchors.allSides() }
        }

        let f4 = root {
            child.anchors { Anchors.allSides() }
        }

        let f5 = root {
            child.anchors { Anchors.cap() }
        }

        let f6 = root {
            friend.anchors { Anchors.allSides() }
        }

        XCTAssertEqual(f1.viewInformations, f2.viewInformations)
        XCTAssertEqual(f1.viewConstraints().weakens, f2.viewConstraints().weakens)

        XCTAssertEqual(f3.viewInformations, f4.viewInformations)
        XCTAssertEqual(f3.viewConstraints().weakens, f4.viewConstraints().weakens)

        XCTAssertEqual(f4.viewInformations, f5.viewInformations)
        XCTAssertNotEqual(f4.viewConstraints().weakens, f5.viewConstraints().weakens)

        XCTAssertNotEqual(f5.viewInformations, f6.viewInformations)
        XCTAssertNotEqual(f5.viewConstraints().weakens, f6.viewConstraints().weakens)
    }
    
    func testSetAccessibilityIdentifier() {
        class TestView: UIView {
            let contentView = UIView()
            let nameLabel = UILabel()
        }
        
        let view = TestView()
        IdentifierUpdater(view, enableViewType: true).update()
        
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView:UIView")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel:UILabel")
        
        class Test2View: TestView {}
        
        let view2 = Test2View()
        IdentifierUpdater(view2, enableViewType: true).update()
        
        XCTAssertEqual(view2.contentView.accessibilityIdentifier, "contentView:UIView")
        XCTAssertEqual(view2.nameLabel.accessibilityIdentifier, "nameLabel:UILabel")
    }
    
    func testDontTouchRootViewByDeactive() {
        let root = UIView().viewTag.root
        let red = UIView().viewTag.red
        let old = UIView().viewTag.old
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        deactivable = root {
            red.anchors {
                Anchors.allSides()
            }
        }.active()
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        
        deactivable?.deactive()
        deactivable = nil
        
        XCTAssertEqual(root.superview, old)
    }
    
}

extension ImplementationTests {
    final class IdentifiedView: UIView, LayoutBuilding {
        
        lazy var contentView: UIView = UIView()
        lazy var nameLabel: UILabel = UILabel()
        
        var deactivable: Deactivable?
        
        var layout: some Layout {
            contentView {
                nameLabel
            }
        }
        
        init(_ options: LayoutOptions = []) {
            super.init(frame: .zero)
            updateLayout(options)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func testNoAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        XCTAssertNil(view.contentView.accessibilityIdentifier)
        XCTAssertNil(view.nameLabel.accessibilityIdentifier)
    }
    
    func testAccessibilityIdentifierOption() {
        let view = IdentifiedView(.automaticIdentifierAssignment)
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel")
    }
}

extension ImplementationTests {
    func testIdentifier() {
        let deactivation = root {
            UILabel().identifying("label").anchors {
                Anchors.cap()
            }
            UIView().identifying("secondView").anchors {
                Anchors(.top).equalTo("label", attribute: .bottom)
                Anchors.shoe()
            }
        }.active()
        
        let label = deactivation.viewForIdentifier("label")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.accessibilityIdentifier, "label")
        
        let secondView = deactivation.viewForIdentifier("secondView")
        XCTAssertEqual(secondView?.accessibilityIdentifier, "secondView")
        
        let currents = deactivation.constraints ?? []
        let labelConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(labelConstraints), labelConstraints)
        
        let secondViewConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(secondViewConstraints), secondViewConstraints)
        
        let constraintsBetweebViews = Set(Anchors(.top).equalTo(label!, attribute: .bottom).constraints(item: secondView!, toItem: label).weakens)
        XCTAssertEqual(currents.intersection(constraintsBetweebViews), constraintsBetweebViews)
    }
}

extension ImplementationTests {
    func testAnchorConstraint() {
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = Anchors(.top, .leading, .trailing, .bottom).constraints(item: child, toItem: root)
        
        NSLayoutConstraint.activate(constraints)
        
        root.frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 200, height: 200))
        root.removeConstraints(constraints)
        
        let constraints1 = Anchors(.top, .leading).constraints(item: child, toItem: root)
        let constraints2 = Anchors(.width, .height).equalTo(constant: 98).constraints(item: child, toItem: root)
        
        NSLayoutConstraint.activate(constraints1)
        NSLayoutConstraint.activate(constraints2)
        
        root.setNeedsLayout()
        root.layoutIfNeeded()
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
        
        let anchor = Anchors(.width).equalTo(constant: 24).constraints(item: subview, toItem: superview).first!
        
        XCTAssertEqual(anchor.firstItem as? NSObject, subview)
        XCTAssertNil(anchor.secondItem)
        XCTAssertEqual(anchor.firstAttribute, .width)
        XCTAssertEqual(anchor.secondAttribute, .notAnAttribute)
        XCTAssertEqual(anchor.constant, 24)
    }
    
    func testAnchorsBuilder() {
        func build(@AnchorsBuilder _ build: () -> [Constraint]) -> [Constraint] {
            build()
        }
        
        let anchors: some Constraint = build {
            Anchors(.top).equalTo(constant: 12.0)
            Anchors(.leading).equalTo(constant: 13.0)
            Anchors(.trailing).equalTo(constant: -13.0)
            Anchors(.bottom)
        }
        
        child.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(child)
        
        let constraint = anchors.constraints(item: child, toItem: root, viewInfoSet: nil)
        XCTAssertEqual(constraint.count, 4)
    }
    
    func testIgnoreAnchorsDuplication() {
        root {
            child.anchors {
                Anchors.allSides()
                Anchors.cap()
                Anchors.shoe()
                Anchors(.height)
                Anchors(.width).equalTo(constant: 44.0)
                Anchors(.width).equalTo(constant: 44.0)
            }
        }.finalActive()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing, .height)
                Anchors(.width).equalTo(constant: 44.0)
            }
        }
        """
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect.tabbed)
    }
    
    func testRules() {
        let root = UIView().viewTag.root
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
                        Anchors(.top)
                    case .topEqualToSuper:
                        Anchors(.top).equalTo(root)
                    case .topEqualToSuperWithConstant:
                        Anchors(.top).equalTo(root, constant: 78.0)
                    case .topGreaterThanOrEqualToNameless:
                        Anchors(.top).greaterThanOrEqualTo()
                    case .topGreaterThanOrEqualToSuper:
                        Anchors(.top).greaterThanOrEqualTo(root)
                    case .topGreaterThanOrEqualToSuperWithConstant:
                        Anchors(.top).greaterThanOrEqualTo(root, constant: 78.0)
                    case .topLessThanOrEqualToNameless:
                        Anchors(.top).lessThanOrEqualTo()
                    case .topLessThanOrEqualToSuper:
                        Anchors(.top).lessThanOrEqualTo(root)
                    case .topLessThanOrEqualToSuperWithConstant:
                        Anchors(.top).lessThanOrEqualTo(root, constant: 78.0)
                    default:
                        Anchors.cap()
                    }
                }
                friend.anchors {
                    switch test {
                    case .topOfFriendEqualToBottomOfChild:
                        Anchors(.top).equalTo(child, attribute: .bottom)
                        Anchors.shoe()
                    case .widthOfFriendEqualToNameless:
                        Anchors(.width)
                        Anchors.shoe()
                    case .widthOfFriendEqualToSuper:
                        Anchors(.width).equalTo(root)
                        Anchors.shoe()
                    case .widthOfFriendEqualToChild:
                        Anchors(.width).equalTo(child)
                        Anchors.shoe()
                    case .widthOfFriendEqualToHeightOfChild:
                        Anchors(.width).equalTo(child, attribute: .height)
                        Anchors.shoe()
                    case .widthOfFriendEqualToConstant:
                        Anchors(.width).equalTo(constant: 78.0)
                        Anchors.shoe()
                    case .widthOfFriendEqualToChildWithConstant:
                        Anchors(.width).equalTo(child, constant: 78.0)
                        Anchors.shoe()
                    default:
                        Anchors.shoe()
                    }
                }
            }
        }
        
        context("top equal to nameless") {
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super") {
            deactivable?.deactive()
            test = .topEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal).count, 1)
        }

        context("top equal to super with constant of 78.0") {
            deactivable?.deactive()
            test = .topEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .equal, constant: 78.0).count, 1)
        }
        
        context("top greater than or equal to nameless") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }
        
        context("top greater than or equal to nameless with constant of 78.0") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual, constant: 78.0).count, 1)
        }

        context("top greater than or equal to super") {
            deactivable?.deactive()
            test = .topGreaterThanOrEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .greaterThanOrEqual).count, 1)
        }

        context("top less than or equal to nameless") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }

        context("top less than or equal to super") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual).count, 1)
        }
        
        context("top less than or equal to super with constant of 78.0") {
            deactivable?.deactive()
            test = .topLessThanOrEqualToSuperWithConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (child, root), attributes: (.top, .top), relation: .lessThanOrEqual, constant: 78.0).count, 1)
        }
        
        context("top of friend equal to bottom of child") {
            deactivable?.deactive()
            test = .topOfFriendEqualToBottomOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }
        
        context("top of friend equal to bottom of child") {
            deactivable?.deactive()
            test = .topOfFriendEqualToBottomOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.top, .bottom), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of nameless") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToNameless
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of super") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToSuper
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, root), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to width of child") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .width), relation: .equal).count, 1)
        }
        
        context("width of friend equal to height of child") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToHeightOfChild
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, child), attributes: (.width, .height), relation: .equal).count, 1)
        }
        
        context("width of friend equal to constant of 78.0") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToConstant
            deactivable = layout().active()
            XCTAssertEqual(root.findConstraints(items: (friend, nil), attributes: (.width, .notAnAttribute), relation: .equal, constant: 78.0).count, 1)
        }
        
        context("width of friend equal to child with constant of 78.0") {
            deactivable?.deactive()
            test = .widthOfFriendEqualToChildWithConstant
            deactivable = layout().active()
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
                Anchors(.top, .leading, .trailing)
            }
            shoe.anchors {
                Anchors(.bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
}

// MARK: - Anchors only
extension ImplementationTests {
    func testAnchorsOnly() {
        let fixedView = UIView()
        fixedView.anchors {
            Anchors(.width, .height).equalTo(constant: 24.0)
        }.finalActive()
        
        XCTAssertEqual(SwiftLayoutPrinter(fixedView, tags: [fixedView: "fixedView"]).print(), """
        fixedView.anchors {
            Anchors(.width, .height).equalTo(constant: 24.0)
        }
        """.tabbed)
    }
}

// MARK: - Animation
extension ImplementationTests {
    func testSetAnimationHandler() {
        deactivable = root {
            child.config({ view in
                view.backgroundColor = .white
            }).setAnimationHandler { view in
                view.alpha = 0.0
            }.anchors {
                Anchors.allSides()
            }.sublayout {
                friend.setAnimationHandler { view in
                    view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }.anchors {
                    Anchors.allSides()
                }
            }
        }.active()
        
        let expect = """
        root {
            child.anchors {
                Anchors(.top, .bottom, .leading, .trailing)
            }.sublayout {
                friend.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
}

// MARK: - Decorations
extension ImplementationTests {
    
    func testFeatureCompose() {
        deactivable = root.config({ root in
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
                Anchors(.top, .bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testFeatureComposeComplex() {
        deactivable = root.config({ root in
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
                Anchors(.top, .leading, .trailing)
            }.sublayout {
                lastview.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
            button.anchors {
                Anchors(.bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }
    
    func testFeatureComposeComplexWithAnimationHandling() {
        deactivable = root.config({ root in
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
                Anchors(.top, .leading, .trailing)
            }.sublayout {
                lastview.anchors {
                    Anchors(.top, .bottom, .leading, .trailing)
                }
            }
            button.anchors {
                Anchors(.bottom, .leading, .trailing)
            }
        }
        """.tabbed
        
        XCTAssertEqual(SwiftLayoutPrinter(root).print(), expect)
    }

}
