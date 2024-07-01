@testable import SwiftLayout
import XCTest

/// test cases for api rules except DSL syntax
final class ImplementationTests: XCTestCase {

    var root = UIView().sl.identifying("root")
    var child = UIView().sl.identifying("child")
    var friend = UIView().sl.identifying("friend")

    var activation: Activation?

    override func setUpWithError() throws {
        continueAfterFailure = false
        root = UIView().sl.identifying("root")
        child = UIView().sl.identifying("child")
        friend = UIView().sl.identifying("friend")
    }

    override func tearDownWithError() throws {
        activation = nil
    }
}

extension ImplementationTests {
    func testLayoutTraversal() {
        let root: UIView = UIView().sl.identifying("root")
        let button: UIButton = UIButton().sl.identifying("button")
        let label: UILabel = UILabel().sl.identifying("label")
        let redView: UIView = UIView().sl.identifying("redView")
        let image: UIImageView = UIImageView().sl.identifying("image")

        let layout = root.sl.sublayout {
            redView
            label.sl.sublayout {
                button
                image
            }
        }

        var result: [String] = []
        LayoutExplorer.traversal(layout: layout, superview: nil, option: .none) { layout, superview, _ in
            guard let view = layout.view else {
                return
            }

            let superDescription = superview?.accessibilityIdentifier ?? "nil"
            let currentDescription = view.accessibilityIdentifier ?? "nil"
            let description = "\(superDescription), \(currentDescription)"
            result.append(description)
        }

        let expectedResult = [
            "nil, root",
            "root, redView",
            "root, label",
            "label, button",
            "label, image"
        ]

        XCTAssertEqual(expectedResult, result)
    }

    func testLayoutFlattening() {
        let layout = root.sl.sublayout {
            child.sl.anchors {
                Anchors.allSides.equalToSuper()
            }.sublayout {
                friend.sl.anchors {
                    Anchors.allSides.equalToSuper()
                }
            }
        }

        XCTAssertNotNil(layout)
        XCTAssertEqual(LayoutElements(layout: layout).viewInformations.map(\.view), [root, child, friend])
    }

    // swiftlint:disable identifier_name
    func testLayoutCompare() {
        let f1 = root.sl.sublayout {
            child
        }
        let e1 = LayoutElements(layout: f1)

        let f2 = root.sl.sublayout {
            child
        }
        let e2 = LayoutElements(layout: f2)

        let f3 = root.sl.sublayout {
            child.sl.anchors { Anchors.allSides.equalToSuper() }
        }
        let e3 = LayoutElements(layout: f3)

        let f4 = root.sl.sublayout {
            child.sl.anchors { Anchors.allSides.equalToSuper() }
        }
        let e4 = LayoutElements(layout: f4)

        let f5 = root.sl.sublayout {
            child.sl.anchors { Anchors.cap.equalToSuper() }
        }
        let e5 = LayoutElements(layout: f5)

        let f6 = root.sl.sublayout {
            friend.sl.anchors { Anchors.allSides.equalToSuper() }
        }
        let e6 = LayoutElements(layout: f6)

        XCTAssertEqual(e1.viewInformations, e2.viewInformations)
        SLTAssertConstraintsEqual(e1.viewConstraints, e1.viewConstraints)

        XCTAssertEqual(e3.viewInformations, e4.viewInformations)
        SLTAssertConstraintsEqual(e3.viewConstraints, e4.viewConstraints)

        XCTAssertEqual(e4.viewInformations, e5.viewInformations)
        SLTAssertConstraintsNotEqual(e4.viewConstraints, e5.viewConstraints)

        XCTAssertNotEqual(e5.viewInformations, e6.viewInformations)
        SLTAssertConstraintsNotEqual(e5.viewConstraints, e6.viewConstraints)
    }
    // swiftlint:enable identifier_name

    func testDontTouchRootViewByDeactive() {
        let root = UIView().sl.identifying("root")
        let red = UIView().sl.identifying("red")
        let old = UIView().sl.identifying("old")
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true

        activation = root.sl.sublayout {
            red.sl.anchors {
                Anchors.allSides.equalToSuper()
            }
        }.active()

        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)

        activation?.deactive()
        activation = nil

        XCTAssertEqual(root.superview, old)
    }

    func testOnActivateBlockCallOnlyOnceWithConstantLayout() {
        let root = UIView()
        let button: UIButton = UIButton()
        let label: UILabel = UILabel()

        var rootCount: Int = 0
        var buttonCount: Int = 0
        var labelCount: Int = 0

        let layout: some Layout = root.sl.onActivate { _ in
            rootCount += 1
        }.sublayout {
            button.sl.onActivate { _ in
                buttonCount += 1
            }

            label.sl.onActivate { _ in
                labelCount += 1
            }
        }

        activation = layout.active()
        XCTAssertEqual(rootCount, 1)
        XCTAssertEqual(buttonCount, 1)
        XCTAssertEqual(labelCount, 1)

        activation = layout.update(fromActivation: activation!)
        XCTAssertEqual(rootCount, 2)
        XCTAssertEqual(buttonCount, 2)
        XCTAssertEqual(labelCount, 2)

        activation = layout.update(fromActivation: activation!)
        XCTAssertEqual(rootCount, 3)
        XCTAssertEqual(buttonCount, 3)
        XCTAssertEqual(labelCount, 3)

        activation?.deactive()
        activation = nil
        XCTAssertEqual(rootCount, 3)
        XCTAssertEqual(buttonCount, 3)
        XCTAssertEqual(labelCount, 3)
    }

    func testOnActivateBlockCallOnlyOnceWithComputedLayout() {
        let root = UIView()
        let button: UIButton = UIButton()
        let label: UILabel = UILabel()

        var rootCount: Int = 0
        var buttonCount: Int = 0
        var labelCount: Int = 0

        var layout: some Layout {
            root.sl.onActivate { _ in
                rootCount += 1
            }.sublayout {
                button.sl.onActivate { _ in
                    buttonCount += 1
                }

                label.sl.onActivate { _ in
                    labelCount += 1
                }
            }
        }

        activation = layout.active()
        XCTAssertEqual(rootCount, 1)
        XCTAssertEqual(buttonCount, 1)
        XCTAssertEqual(labelCount, 1)

        var _ = layout
        activation = layout.update(fromActivation: activation!)
        XCTAssertEqual(rootCount, 2)
        XCTAssertEqual(buttonCount, 2)
        XCTAssertEqual(labelCount, 2)

        activation = layout.update(fromActivation: activation!)
        XCTAssertEqual(rootCount, 3)
        XCTAssertEqual(buttonCount, 3)
        XCTAssertEqual(labelCount, 3)

        activation?.deactive()
        activation = nil
        XCTAssertEqual(rootCount, 3)
        XCTAssertEqual(buttonCount, 3)
        XCTAssertEqual(labelCount, 3)
    }
}

extension ImplementationTests {
    func testIdentifier() {
        let activation = root.sl.sublayout {
            UILabel().sl.identifying("label").sl.anchors {
                Anchors.cap.equalToSuper()
            }
            UIView().sl.identifying("secondView").sl.anchors {
                Anchors.top.equalTo("label", attribute: .bottom)
                Anchors.shoe.equalToSuper()
            }
        }.active()

        let label = activation.viewForIdentifier("label")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.accessibilityIdentifier, "label")

        let secondView = activation.viewForIdentifier("secondView")
        XCTAssertEqual(secondView?.accessibilityIdentifier, "secondView")

        let currents = activation.constraints
        let labelConstraints = Set(ofWeakConstraintsFrom: Anchors.cap.equalToSuper().constraints(item: label!, toItem: root))
        XCTAssertEqual(currents.intersection(labelConstraints), labelConstraints)

        let secondViewConstraints = Set(ofWeakConstraintsFrom: Anchors.cap.equalToSuper().constraints(item: label!, toItem: root))
        XCTAssertEqual(currents.intersection(secondViewConstraints), secondViewConstraints)

        let constraintsBetweebViews = Set(ofWeakConstraintsFrom: Anchors.top.equalTo(label!, attribute: .bottom).constraints(item: secondView!, toItem: label))
        XCTAssertEqual(currents.intersection(constraintsBetweebViews), constraintsBetweebViews)
    }
}

extension ImplementationTests {

    func testStackViewMaintainOrderingOfArrangedSubviews() {
        let stack = StackView(frame: .init(x: 0, y: 0, width: 40, height: 80)).sl.identifying("view")
        var aView: UIView {
            stack.aView
        }
        var bView: UIView {
            stack.bView
        }
        stack.sl.updateLayout(forceLayout: true)
        XCTAssertEqual(aView.frame.debugDescription, "(20.0, 0.0, 0.0, 40.0)")
        XCTAssertEqual(bView.frame.debugDescription, "(20.0, 40.0, 0.0, 40.0)")

        stack.isA = false
        stack.sl.updateLayout(forceLayout: true)

        XCTAssertEqual(bView.frame.debugDescription, "(20.0, 0.0, 0.0, 80.0)")

        stack.isA = true
        stack.sl.updateLayout(forceLayout: true)

        XCTAssertEqual(stack.stack.arrangedSubviews.compactMap(\.accessibilityIdentifier), [aView, bView].compactMap(\.accessibilityIdentifier))
        XCTAssertEqual(aView.frame.debugDescription, "(20.0, 0.0, 0.0, 40.0)")
        XCTAssertEqual(bView.frame.debugDescription, "(20.0, 40.0, 0.0, 40.0)")
    }

    final class StackView: UIView, Layoutable {
        var activation: Activation?
        var layout: some Layout {
            self.sl.sublayout {
                stack.sl.anchors {
                    Anchors.allSides.equalToSuper()
                }.sublayout {
                    if isA {
                        aView
                    }
                    bView
                }
            }
        }

        let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .center
            stack.spacing = 0.0
            return stack
        }().sl.identifying("stack")

        let aView = UIView().sl.identifying("a")
        let bView = UIView().sl.identifying("b")

        var isA: Bool = true
    }

    func testForecDeactivateNSLayoutConstraint() {
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let childs: [UIView] = (0..<10).map({ _ in UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) })

        var layout: some Layout {
            superview.sl.sublayout {
                for child in childs {
                    child.sl.anchors {
                        Anchors.top
                    }
                }
            }
        }

        var activation: Activation!

        let expectation1 = XCTestExpectation(description: "active layout and force deactivate")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            activation = layout.active(forceLayout: true)

            NSLayoutConstraint.deactivate(superview.constraints)
            superview.setNeedsLayout()
            superview.layoutIfNeeded()

            expectation1.fulfill()
        }

        let expectation2 = XCTestExpectation(description: "layout update after force deactivate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            activation = layout.update(fromActivation: activation, forceLayout: true)

            expectation2.fulfill()
        }

        wait(for: [expectation1, expectation2], timeout: 3)
    }
}
