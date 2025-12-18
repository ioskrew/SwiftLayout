@testable import SwiftLayout
import Testing
import SwiftLayoutPlatform

/// test cases for api rules except DSL syntax
@MainActor
struct ImplementationTests {

    let root = SLView().withIdentifier("root")
    let child = SLView().withIdentifier("child")
    let friend = SLView().withIdentifier("friend")

    var activation: Activation?
}

extension ImplementationTests {
    @Test
    func layoutTraversal() {
        let root = SLView().withIdentifier("root")
        let button = SLView().withIdentifier("button")
        let label = SLView().withIdentifier("label")
        let redView = SLView().withIdentifier("redView")
        let image = SLView().withIdentifier("image")

        let layout = root.sl.sublayout {
            redView
            label.sl.sublayout {
                button
                image
            }
        }

        let result = layout.layoutComponents(superview: nil, option: .none).map {
            let superDescription = $0.superview?.testIdentifier ?? "nil"
            let currentDescription = $0.node.nodeIdentifier ?? "nil"
            return "\(superDescription), \(currentDescription)"
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
        let currentViews = LayoutElements(layout: layout).hierarchyInfos.compactMap { $0.node.baseObject as? SLView }
        #expect(currentViews == [root, child, friend])
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

        #expect(e1.hierarchyInfos == e2.hierarchyInfos)
        #expect(isEqual(e1.viewConstraints, e2.viewConstraints))

        #expect(e3.hierarchyInfos == e4.hierarchyInfos)
        #expect(isEqual(e3.viewConstraints, e4.viewConstraints))

        #expect(e4.hierarchyInfos == e5.hierarchyInfos)
        #expect(isNotEqual(e4.viewConstraints, e5.viewConstraints))

        #expect(e5.hierarchyInfos != e6.hierarchyInfos)
        #expect(isNotEqual(e5.viewConstraints, e6.viewConstraints))
    }

    // swiftlint:enable identifier_name

    @Test
    mutating func dontTouchRootViewByDeactive() {
        let root = SLView().withIdentifier("root")
        let red = SLView().withIdentifier("red")
        let old = SLView().withIdentifier("old")
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
        let root = SLView()
        let button = SLView()
        let label = SLView()

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
        let root = SLView()
        let button = SLView()
        let label = SLView()

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
            SLView().sl.identifying("label").anchors {
                Anchors.cap.equalToSuper().identifier("label-anchors")
            }
            SLView().sl.identifying("secondView").anchors {
                Anchors.top.equalTo("label", attribute: .bottom).identifier("between-anchors")
                Anchors.shoe.equalToSuper().identifier("secondView-anchors")
            }
            SLLayoutGuide().sl.identifying("layoutGuide")
        }.active()

        let label = try #require(activation.viewForIdentifier("label"))
        #expect(label.testIdentifier == "label")

        let secondView = try #require(activation.viewForIdentifier("secondView"))
        #expect(secondView.testIdentifier == "secondView")

        #expect(activation.viewForIdentifier("layoutGuide") == nil)
        let layoutGuide = try #require(activation.layoutGuideForIdentifier("layoutGuide"))
        #expect(layoutGuide.testIdentifier == "layoutGuide")

        let currentLabelConstraints = activation.constraints.filter { $0.origin?.identifier == "label-anchors" }
        let labelConstraints = Set(ofWeakConstraintsFrom: Anchors.cap.equalToSuper().identifier("label-anchors").constraints(item: label, toItem: root))
        #expect(currentLabelConstraints == labelConstraints)

        let currentBetweenConstraints = activation.constraints.filter { $0.origin?.identifier == "between-anchors" }
        let betweenConstraints = Set(ofWeakConstraintsFrom: Anchors.top.equalTo(label, attribute: .bottom).identifier("between-anchors").constraints(item: secondView, toItem: label))
        #expect(currentBetweenConstraints == betweenConstraints)

        let currentSeconeViewConstraints = activation.constraints.filter { $0.origin?.identifier == "secondView-anchors" }
        let seconeViewConstraints = Set(ofWeakConstraintsFrom: Anchors.shoe.equalToSuper().identifier("secondView-anchors").constraints(item: secondView, toItem: root))
        #expect(currentSeconeViewConstraints == seconeViewConstraints)
    }
}

extension ImplementationTests {

    @Test
    func stackViewMaintainOrderingOfArrangedSubviews() {
        let stack = StackView(frame: .init(x: 0, y: 0, width: 40, height: 80)).withIdentifier("view")
        var aView: SLView {
            stack.aView
        }
        var bView: SLView {
            stack.bView
        }
        stack.sl.updateLayout(forceLayout: true)
        #if canImport(UIKit)
        // Frame expectations are iOS-specific due to UIStackView behavior
        #expect(aView.frame.debugDescription == "(20.0, 0.0, 0.0, 40.0)")
        #expect(bView.frame.debugDescription == "(20.0, 40.0, 0.0, 40.0)")
        #endif

        stack.isA = false
        stack.sl.updateLayout(forceLayout: true)

        #if canImport(UIKit)
        #expect(bView.frame.debugDescription == "(20.0, 0.0, 0.0, 80.0)")
        #endif

        stack.isA = true
        stack.sl.updateLayout(forceLayout: true)

        #expect(stack.stack.arrangedSubviews.compactMap(\.testIdentifier) == [aView, bView].compactMap(\.testIdentifier))
        #if canImport(UIKit)
        #expect(aView.frame.debugDescription == "(20.0, 0.0, 0.0, 40.0)")
        #expect(bView.frame.debugDescription == "(20.0, 40.0, 0.0, 40.0)")
        #endif
    }

    @MainActor
    final class StackView: SLView, Layoutable {
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

        let stack: SLStackView = {
            let stack = SLStackView()
            #if canImport(UIKit)
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .center
            stack.accessibilityIdentifier = "stack"
            #else
            stack.orientation = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .centerX
            stack.setAccessibilityIdentifier("stack")
            #endif
            stack.spacing = 0.0
            return stack
        }()

        let aView = SLView().withIdentifier("a")
        let bView = SLView().withIdentifier("b")

        var isA: Bool = true
    }

    @Test
    func forecDeactivateNSLayoutConstraint() async throws {
        let superview = SLView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let childs: [SLView] = (0..<10).map({ _ in SLView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) })

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
            superview.slSetNeedsLayout()
            superview.slLayoutIfNeeded()
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

extension ImplementationTests {

    @Test
    mutating func constraintUpdaterUpdatesConstantAndPriority() throws {
        let layout = root.sl.sublayout {
            child.sl.anchors {
                Anchors.bottom.equalToSuper().identifier("bottom-id")
            }
        }

        activation = layout.active()

        let initialConstraints = try #require(activation?.constraints).compactMap(\.origin)
        let bottom = try #require(initialConstraints.first { $0.identifier == "bottom-id" })
        #expect(bottom.constant == 0)
        #expect(bottom.priority == .required)

        activation?.anchors("bottom-id", attribute: .bottom).update(constant: -12, priority: .defaultHigh)

        let updatedConstraints = try #require(activation?.constraints).compactMap(\.origin)
        let updated = try #require(updatedConstraints.first { $0.identifier == "bottom-id" })
        #expect(updated.constant == -12)
        #expect(updated.priority == .defaultHigh)

        activation?.deactive()
        activation = nil
    }

    @Test
    mutating func constraintUpdaterFiltersByAttribute() throws {
        let layout = root.sl.sublayout {
            child.sl.anchors {
                Anchors.top.equalToSuper().identifier("edge-id")
                Anchors.bottom.equalToSuper().identifier("edge-id")
            }
        }

        activation = layout.active()

        let constraints = try #require(activation?.constraints).compactMap(\.origin)
        let top = try #require(constraints.first { $0.firstAttribute == .top && $0.identifier == "edge-id" })
        let bottom = try #require(constraints.first { $0.firstAttribute == .bottom && $0.identifier == "edge-id" })
        #expect(top.constant == 0)
        #expect(bottom.constant == 0)

        activation?.anchors("edge-id", attribute: .bottom).update(constant: -4, priority: nil)

        let refreshedConstraints = try #require(activation?.constraints).compactMap(\.origin)
        let refreshedTop = try #require(refreshedConstraints.first { $0.firstAttribute == .top && $0.identifier == "edge-id" })
        let refreshedBottom = try #require(refreshedConstraints.first { $0.firstAttribute == .bottom && $0.identifier == "edge-id" })

        #expect(refreshedTop.constant == 0)
        #expect(refreshedBottom.constant == -4)

        activation?.deactive()
        activation = nil
    }
}
