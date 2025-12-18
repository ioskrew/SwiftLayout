import SwiftLayout
import Testing
import SwiftLayoutPlatform

extension LayoutDSLTests {

    // MARK: - ComplexUsage Tests

    final class ComplexUsageTests: LayoutDSLTestsBase {
        @Test
        func onActivate() {
            var childActivated = false
            var innerViewActivated = false
            let innerView = SLView().withIdentifier("innerView")
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    child.sl.sublayout {
                        innerView.sl.onActivate { _ in
                            innerViewActivated = true
                        }
                    }.onActivate { _ in
                        childActivated = true
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [child])
            expectView(child, superview: root, subviews: [innerView])
            expectView(innerView, superview: child, subviews: [])
            #expect(childActivated)
            #expect(innerViewActivated)
        }

        @Test
        func duplicateLayoutBuilder() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                    }.sublayout {
                        label
                    }.sublayout {
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [button, label, blue])
            expectView(button, superview: red, subviews: [])
            expectView(label, superview: red, subviews: [])
            expectView(blue, superview: red, subviews: [image])
            expectView(image, superview: blue, subviews: [])
        }

        @Test
        func separatedFromFirstLevel() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    child
                    red
                    image
                }

                child.sl.sublayout {
                    button
                    label
                }

                red.sl.sublayout {
                    blue
                    green
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [child, red, image])
            expectView(child, superview: root, subviews: [button, label])
            expectView(red, superview: root, subviews: [blue, green])
            expectView(image, superview: root, subviews: [])
            expectView(button, superview: child, subviews: [])
            expectView(label, superview: child, subviews: [])
            expectView(blue, superview: red, subviews: [])
            expectView(green, superview: red, subviews: [])
        }
    }

    // MARK: - GroupLayout Tests

    final class GroupLayoutTests: LayoutDSLTestsBase {
        @Test
        func groupLayout() {
            let group1_1 = SLView()
            let group1_2 = SLView()
            let group1_3 = SLView()
            let group2_1 = SLView()
            let group2_2 = SLView()

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    GroupLayout {
                        group1_1
                        group1_2
                        group1_3
                    }
                    GroupLayout {
                        group2_1
                        group2_2
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [group1_1, group1_2, group1_3, group2_1, group2_2])
            expectView(group1_1, superview: root, subviews: [])
            expectView(group1_2, superview: root, subviews: [])
            expectView(group1_3, superview: root, subviews: [])
            expectView(group2_1, superview: root, subviews: [])
            expectView(group2_2, superview: root, subviews: [])
        }

        @Test
        func groupLayoutWithOption() {
            let stackView = SLStackView()
            let notArrangedview1 = SLView()
            let notArrangedview2 = SLView()
            let arrangedView1 = SLView()
            let arrangedView2 = SLView()
            let arrangedView3 = SLView()

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    stackView.sl.sublayout {
                        GroupLayout(option: .isNotArranged) {
                            notArrangedview1
                            notArrangedview2
                        }

                        arrangedView1
                        arrangedView2
                        arrangedView3
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [stackView])
            expectView(stackView, superview: root, subviews: [notArrangedview1, notArrangedview2, arrangedView1, arrangedView2, arrangedView3])
            #expect(stackView.arrangedSubviews == [arrangedView1, arrangedView2, arrangedView3])
            #expect(stackView.arrangedSubviews.contains(notArrangedview1) == false)
            #expect(stackView.arrangedSubviews.contains(notArrangedview2) == false)
        }
    }

    // MARK: - ModularLayout Tests

    final class ModularLayoutTests: LayoutDSLTestsBase {
        @MainActor
        struct Module1: ModularLayout {
            let view1 = SLView()
            let view2 = SLView()
            let view3 = SLView()

            @LayoutBuilder var layout: some Layout {
                view1.sl.sublayout {
                    view2
                }

                view3
            }
        }

        @MainActor
        struct Module2: ModularLayout {
            let view1 = SLView()
            let view2 = SLView()
            let view3 = SLView()

            @LayoutBuilder var layout: some Layout {
                view1

                view2.sl.sublayout {
                    view3
                }
            }
        }

        let module1: Module1 = Module1()
        var module2: Module2?

        @LayoutBuilder
        var layout: some Layout {
            root.sl.sublayout {
                module1
                module2
            }
        }

        @Test
        func module2IsNil() {
            module2 = nil
            activation = layout.active()

            expectView(root, superview: window, subviews: [module1.view1, module1.view3])
            expectView(module1.view1, superview: root, subviews: [module1.view2])
            expectView(module1.view2, superview: module1.view1, subviews: [])
            expectView(module1.view3, superview: root, subviews: [])
        }

        @Test
        func module2IsSome() {
            module2 = Module2()
            activation = layout.active()

            expectView(root, superview: window, subviews: [module1.view1, module1.view3, module2!.view1, module2!.view2])
            expectView(module1.view1, superview: root, subviews: [module1.view2])
            expectView(module1.view2, superview: module1.view1, subviews: [])
            expectView(module1.view3, superview: root, subviews: [])
            expectView(module2!.view1, superview: root, subviews: [])
            expectView(module2!.view2, superview: root, subviews: [module2!.view3])
            expectView(module2!.view3, superview: module2!.view2, subviews: [])
        }
    }

    // MARK: - GuideLayout Tests

    final class GuideLayoutTests: LayoutDSLTestsBase {
        @Test
        func guideLayout() {
            let layoutGuide = SLLayoutGuide().withIdentifier("layoutGuide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    layoutGuide

                    red
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [])
            expectLayoutGuides(root, layoutGuides: [layoutGuide])
            expectOwnerView(layoutGuide, ownerView: root)
        }

        @Test
        func optionalGuideLayout() {
            var optionalLayoutGuide: SLLayoutGuide? = nil

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    optionalLayoutGuide

                    red
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [])
            expectLayoutGuides(root, layoutGuides: [])

            let layoutGuide = SLLayoutGuide().withIdentifier("layoutGuide")
            optionalLayoutGuide = layoutGuide

            activation = layout.update(fromActivation: activation!)

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [])
            expectLayoutGuides(root, layoutGuides: [layoutGuide])
            expectOwnerView(layoutGuide, ownerView: root)
        }

        @Test
        func guideLayoutWithAnchors() {
            let layoutGuide = SLLayoutGuide().withIdentifier("layoutGuide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    layoutGuide.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10)
                        Anchors.leading.trailing.equalToSuper(constant: 20)
                        Anchors.height.equalTo(constant: 100)
                    }
                }
            }

            activation = layout.active()

            expectLayoutGuides(root, layoutGuides: [layoutGuide])
            expectOwnerView(layoutGuide, ownerView: root)

            // Verify constraints are created on the owning view
            let guideConstraints = root.constraints.filter {
                $0.firstItem === layoutGuide || $0.secondItem === layoutGuide
            }
            #expect(guideConstraints.count == 4) // top, leading, trailing, height

            // Verify specific constraint values
            let topConstraint = guideConstraints.first { $0.firstAttribute == .top }
            #expect(topConstraint?.constant == 10)

            let heightConstraint = guideConstraints.first { $0.firstAttribute == .height }
            #expect(heightConstraint?.constant == 100)
        }

        @Test
        func viewConstrainedToGuide() {
            let layoutGuide = SLLayoutGuide().withIdentifier("layoutGuide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    layoutGuide.sl.anchors {
                        Anchors.top.equalToSuper(constant: 20)
                        Anchors.horizontal.equalToSuper()
                        Anchors.height.equalTo(constant: 50)
                    }

                    red.sl.anchors {
                        Anchors.top.equalTo(layoutGuide, attribute: .bottom, constant: 10)
                        Anchors.horizontal.equalTo(layoutGuide)
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectLayoutGuides(root, layoutGuides: [layoutGuide])

            // Verify view is constrained to guide
            let viewToGuideConstraints = root.constraints.filter {
                ($0.firstItem === red && $0.secondItem === layoutGuide) ||
                ($0.firstItem === layoutGuide && $0.secondItem === red)
            }
            #expect(viewToGuideConstraints.count == 3) // top, leading, trailing

            // Verify top constraint references guide's bottom
            let topConstraint = viewToGuideConstraints.first {
                $0.firstItem === red && $0.firstAttribute == .top
            }
            #expect(topConstraint?.secondAttribute == .bottom)
            #expect(topConstraint?.constant == 10)
        }

        @Test
        func guideLayoutWithIdentifier() {
            let layoutGuide = SLLayoutGuide()

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    layoutGuide.sl.identifying("myGuide").anchors {
                        Anchors.allSides.equalToSuper(constant: 10).identifier("guideAnchors")
                    }
                }
            }

            activation = layout.active()

            // Verify identifier is set
            #expect(layoutGuide.testIdentifier == "myGuide")

            // Verify can retrieve via activation
            let retrievedGuide = activation?.layoutGuideForIdentifier("myGuide")
            #expect(retrievedGuide === layoutGuide)

            // Verify anchors have identifier
            let identifiedConstraints = root.constraints.filter {
                $0.identifier == "guideAnchors"
            }
            #expect(identifiedConstraints.count == 4) // top, bottom, leading, trailing
        }

        @Test
        func guideLayoutDeactivation() {
            let layoutGuide = SLLayoutGuide().withIdentifier("layoutGuide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    layoutGuide.sl.anchors {
                        Anchors.allSides.equalToSuper()
                    }

                    red.sl.anchors {
                        Anchors.center.equalTo(layoutGuide)
                    }
                }
            }

            activation = layout.active()

            let constraintCountBefore = root.constraints.count
            #expect(constraintCountBefore > 0)
            #expect(root.layoutGuides.contains(layoutGuide))

            activation?.deactive()

            // Verify guide is removed
            #expect(!root.layoutGuides.contains(layoutGuide))

            // Verify constraints are deactivated
            let activeConstraints = root.constraints.filter { $0.isActive }
            #expect(activeConstraints.isEmpty)
        }

        @Test
        func multipleGuidesWithViews() {
            let topGuide = SLLayoutGuide().withIdentifier("topGuide")
            let bottomGuide = SLLayoutGuide().withIdentifier("bottomGuide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    topGuide.sl.anchors {
                        Anchors.top.equalToSuper()
                        Anchors.horizontal.equalToSuper()
                        Anchors.height.equalTo(constant: 40)
                    }

                    bottomGuide.sl.anchors {
                        Anchors.bottom.equalToSuper()
                        Anchors.horizontal.equalToSuper()
                        Anchors.height.equalTo(constant: 40)
                    }

                    red.sl.anchors {
                        Anchors.top.equalTo(topGuide, attribute: .bottom)
                        Anchors.bottom.equalTo(bottomGuide, attribute: .top)
                        Anchors.horizontal.equalToSuper()
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectLayoutGuides(root, layoutGuides: [topGuide, bottomGuide])

            // Verify view is sandwiched between guides
            let redTopConstraint = root.constraints.first {
                $0.firstItem === red && $0.firstAttribute == .top && $0.secondItem === topGuide
            }
            #expect(redTopConstraint?.secondAttribute == .bottom)

            let redBottomConstraint = root.constraints.first {
                $0.firstItem === red && $0.firstAttribute == .bottom && $0.secondItem === bottomGuide
            }
            #expect(redBottomConstraint?.secondAttribute == .top)
        }
    }

    // MARK: - AnyLayout Tests

    final class AnyLayoutTests: LayoutDSLTestsBase {
        @Test
        func withAnyLayout() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }.eraseToAnyLayout()
                    }
                }
            }

            activation = AnyLayout(layout).active()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [button, label, blue])
            expectView(button, superview: red, subviews: [])
            expectView(label, superview: red, subviews: [])
            expectView(blue, superview: red, subviews: [image])
            expectView(image, superview: blue, subviews: [])
        }
    }
}
