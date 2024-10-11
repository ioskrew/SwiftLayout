@testable import SwiftLayout
import Testing
import UIKit

/// test cases for api rules except DSL syntax
@MainActor
struct ImplementationTests {

    let root = UIView().sl.identifying("root")
    let child = UIView().sl.identifying("child")
    let friend = UIView().sl.identifying("friend")

    var activation: Activation?
}

extension ImplementationTests {
    @Test
    func layoutTraversal() {
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

        #expect(expectedResult == result)
    }

    @Test
    func layoutFlattening() throws {
        let layout = root.sl.sublayout {
            child.sl.anchors {
                Anchors.allSides.equalToSuper()
            }.sublayout {
                friend.sl.anchors {
                    Anchors.allSides.equalToSuper()
                }
            }
        }

        _ = try #require(layout)
        #expect(LayoutElements(layout: layout).viewInformations.map(\.view) == [root, child, friend])
    }

    // swiftlint:disable identifier_name
    @Test
    func layoutCompare() {
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

        #expect(e1.viewInformations == e2.viewInformations)
        #expect(isEqual(e1.viewConstraints, e2.viewConstraints))

        #expect(e3.viewInformations == e4.viewInformations)
        #expect(isEqual(e3.viewConstraints, e4.viewConstraints))

        #expect(e4.viewInformations == e5.viewInformations)
        #expect(isNotEqual(e4.viewConstraints, e5.viewConstraints))

        #expect(e5.viewInformations != e6.viewInformations)
        #expect(isNotEqual(e5.viewConstraints, e6.viewConstraints))
    }

    // swiftlint:enable identifier_name

    @Test
    mutating func dontTouchRootViewByDeactive() {
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

        #expect(root.translatesAutoresizingMaskIntoConstraints == true)

        activation?.deactive()
        activation = nil

        #expect(root.superview == old)
    }

    @Test
    mutating func onActivateBlockCallOnlyOnceWithConstantLayout() {
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
        #expect(rootCount == 1)
        #expect(buttonCount == 1)
        #expect(labelCount == 1)

        activation = layout.update(fromActivation: activation!)
        #expect(rootCount == 2)
        #expect(buttonCount == 2)
        #expect(labelCount == 2)

        activation = layout.update(fromActivation: activation!)
        #expect(rootCount == 3)
        #expect(buttonCount == 3)
        #expect(labelCount == 3)

        activation?.deactive()
        activation = nil
        #expect(rootCount == 3)
        #expect(buttonCount == 3)
        #expect(labelCount == 3)
    }

    @Test
    mutating func onActivateBlockCallOnlyOnceWithComputedLayout() {
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
        #expect(rootCount == 1)
        #expect(buttonCount == 1)
        #expect(labelCount == 1)

        var _ = layout
        activation = layout.update(fromActivation: activation!)
        #expect(rootCount == 2)
        #expect(buttonCount == 2)
        #expect(labelCount == 2)

        activation = layout.update(fromActivation: activation!)
        #expect(rootCount == 3)
        #expect(buttonCount == 3)
        #expect(labelCount == 3)

        activation?.deactive()
        activation = nil
        #expect(rootCount == 3)
        #expect(buttonCount == 3)
        #expect(labelCount == 3)
    }
}

extension ImplementationTests {
    @Test
    func identifier() throws {
        let activation = root.sl.sublayout {
            UILabel().sl.identifying("label").sl.anchors {
                Anchors.cap.equalToSuper()
            }
            UIView().sl.identifying("secondView").sl.anchors {
                Anchors.top.equalTo("label", attribute: .bottom)
                Anchors.shoe.equalToSuper()
            }
        }.active()

        let label = try #require(activation.viewForIdentifier("label"))
        #expect(label.accessibilityIdentifier == "label")

        let secondView = try #require(activation.viewForIdentifier("secondView"))
        #expect(secondView.accessibilityIdentifier == "secondView")

        let currents = activation.constraints
        let labelConstraints = Set(ofWeakConstraintsFrom: Anchors.cap.equalToSuper().constraints(item: label, toItem: root))
        #expect(currents.intersection(labelConstraints) == labelConstraints)

        let secondViewConstraints = Set(ofWeakConstraintsFrom: Anchors.cap.equalToSuper().constraints(item: label, toItem: root))
        #expect(currents.intersection(secondViewConstraints) == secondViewConstraints)

        let constraintsBetweebViews = Set(ofWeakConstraintsFrom: Anchors.top.equalTo(label, attribute: .bottom).constraints(item: secondView, toItem: label))
        #expect(currents.intersection(constraintsBetweebViews) == constraintsBetweebViews)
    }
}

extension ImplementationTests {

    @Test
    func stackViewMaintainOrderingOfArrangedSubviews() {
        let stack = StackView(frame: .init(x: 0, y: 0, width: 40, height: 80)).sl.identifying("view")
        var aView: UIView {
            stack.aView
        }
        var bView: UIView {
            stack.bView
        }
        stack.sl.updateLayout(forceLayout: true)
        #expect(aView.frame.debugDescription == "(20.0, 0.0, 0.0, 40.0)")
        #expect(bView.frame.debugDescription == "(20.0, 40.0, 0.0, 40.0)")

        stack.isA = false
        stack.sl.updateLayout(forceLayout: true)

        #expect(bView.frame.debugDescription == "(20.0, 0.0, 0.0, 80.0)")

        stack.isA = true
        stack.sl.updateLayout(forceLayout: true)

        #expect(stack.stack.arrangedSubviews.compactMap(\.accessibilityIdentifier) == [aView, bView].compactMap(\.accessibilityIdentifier))
        #expect(aView.frame.debugDescription == "(20.0, 0.0, 0.0, 40.0)")
        #expect(bView.frame.debugDescription == "(20.0, 40.0, 0.0, 40.0)")
    }

    @MainActor
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

    @Test
    func forecDeactivateNSLayoutConstraint() async throws {
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

        @MainActor
        func activeLayoutAndForceDeactivate() async {
            activation = layout.active(forceLayout: true)

            NSLayoutConstraint.deactivate(superview.constraints)
            superview.setNeedsLayout()
            superview.layoutIfNeeded()
        }

        @MainActor
        func layoutUpdateAfterForceDeactivate() async {
            activation = layout.update(fromActivation: activation, forceLayout: true)
        }

        await activeLayoutAndForceDeactivate()
        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        await layoutUpdateAfterForceDeactivate()

        #expect(true) // If the test runs without crashing, it's OK
    }
}
