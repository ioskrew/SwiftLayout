import SwiftLayout
import Testing
import UIKit

@MainActor
struct LayoutDSLTest { // swiftlint:disable:this type_body_length

    @MainActor
    class LayoutDSLTestsBase {
        let window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150)).sl.identifying("window")

        let root = UIView().sl.identifying("root")
        let child = UIView().sl.identifying("child")
        let button = UIButton().sl.identifying("button")
        let label = UILabel().sl.identifying("label")
        let red = UIView().sl.identifying("red")
        let blue = UIView().sl.identifying("blue")
        let green = UIView().sl.identifying("green")
        let image = UIImageView().sl.identifying("image")

        var activation: Activation?

        init() {
            root.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(root)
        }
    }

    final class ActivationTests: LayoutDSLTestsBase {
        @Test
        func active() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [button, label, blue])
            expectView(button, superview: red, subviews: [])
            expectView(label, superview: red, subviews: [])
            expectView(blue, superview: red, subviews: [image])
            expectView(image, superview: blue, subviews: [])
        }

        @Test
        func deactive() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            activation = layout.active()

            activation?.deactive()

            expectView(root, superview: window, subviews: [])
            expectView(red, superview: nil, subviews: [])
            expectView(button, superview: nil, subviews: [])
            expectView(label, superview: nil, subviews: [])
            expectView(blue, superview: nil, subviews: [])
            expectView(image, superview: nil, subviews: [])
        }

        @Test
        func finalActive() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
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
        func updateLayout() {
            var flag = true
            let parentView = CallCountView()
            let childView_0 = CallCountView()
            let childView_1 = CallCountView()

            @LayoutBuilder
            var layout: some Layout {
                parentView.sl.sublayout {
                    if flag {
                        childView_0
                    } else {
                        childView_1
                    }
                }
            }

            // active
            activation = layout.active(forceLayout: true)

            expectView(parentView, superview: nil, subviews: [childView_0])
            expectView(childView_0, superview: parentView, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 1)
            #expect(parentView.addSubviewCallCount(childView_1) == 0)
            #expect(childView_0.removeFromSuperviewCallCount == 0)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // update without change
            activation = layout.update(fromActivation: activation!, forceLayout: true)

            expectView(parentView, superview: nil, subviews: [childView_0])
            expectView(childView_0, superview: parentView, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 0)
            #expect(childView_0.removeFromSuperviewCallCount == 0)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // "update with change
            flag.toggle()
            activation = layout.update(fromActivation: activation!, forceLayout: true)

            expectView(parentView, superview: nil, subviews: [childView_1])
            expectView(childView_0, superview: nil, subviews: [])
            expectView(childView_1, superview: parentView, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 1)
            #expect(childView_0.removeFromSuperviewCallCount == 1)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // deactive
            activation?.deactive()
            activation = nil

            expectView(parentView, superview: nil, subviews: [])
            expectView(childView_0, superview: nil, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 1)
            #expect(childView_0.removeFromSuperviewCallCount == 1)
            #expect(childView_1.removeFromSuperviewCallCount == 1)
        }
    }

    struct ConditionalSyntaxTests {
        final class IfFlag: LayoutDSLTestsBase {
            var flag = true

            let trueView = UIView()
            let falseView = UIView()

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                    }

                    if flag {
                        trueView
                    } else {
                        falseView
                    }
                }
            }

            @Test
            func ifTrue() {
                flag = true
                activation = layout.active()

                expectView(root, superview: window, subviews: [red, trueView])
                expectView(red, superview: root, subviews: [button])
                expectView(trueView, superview: root, subviews: [])
                expectView(falseView, superview: nil, subviews: [])
            }

            @Test
            func ifFalse() {
                flag = false
                activation = layout.active()

                expectView(root, superview: window, subviews: [red, falseView])
                expectView(red, superview: root, subviews: [button])
                expectView(trueView, superview: nil, subviews: [])
                expectView(falseView, superview: root, subviews: [])
            }

        }

        final class SwitchCase: LayoutDSLTestsBase {
            enum Test: String, CaseIterable {
                case first
                case second
                case third
            }

            let first = UIView()
            let second = UIView()
            let third = UIView()

            @LayoutBuilder
            func layout(_ test: Test) -> some Layout {
                root.sl.sublayout {
                    child.sl.sublayout {
                        switch test {
                        case .first:
                            first
                        case .second:
                            second
                        case .third:
                            third
                        }
                    }
                }
            }

            @Test
            func caseFirst() {
                activation = layout(.first).active()

                expectView(root, superview: window, subviews: [child])
                expectView(child, superview: root, subviews: [first])
                expectView(first, superview: child, subviews: [])
                expectView(second, superview: nil, subviews: [])
                expectView(third, superview: nil, subviews: [])
            }

            @Test
            func caseSecond() {
                activation = layout(.second).active()

                expectView(root, superview: window, subviews: [child])
                expectView(child, superview: root, subviews: [second])
                expectView(first, superview: nil, subviews: [])
                expectView(second, superview: child, subviews: [])
                expectView(third, superview: nil, subviews: [])
            }

            @Test
            func caseThird() {
                activation = layout(.third).active()

                expectView(root, superview: window, subviews: [child])
                expectView(child, superview: root, subviews: [third])
                expectView(first, superview: nil, subviews: [])
                expectView(second, superview: nil, subviews: [])
                expectView(third, superview: child, subviews: [])
            }
        }

        final class Optional: LayoutDSLTestsBase {
            var optional: UIView?

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        optional
                    }
                }
            }

            @Test
            func viewIsNil() {
                optional = nil
                activation = layout.active()

                expectView(root, superview: window, subviews: [red])
                expectView(red, superview: root, subviews: [])
            }

            @Test
            func viewIsSome() {
                optional = UIView()
                activation = layout.active()

                expectView(root, superview: window, subviews: [red])
                expectView(red, superview: root, subviews: [optional!])
                expectView(optional!, superview: red, subviews: [])
            }
        }

        final class ForIn: LayoutDSLTestsBase {
            let view_0 = UIView()
            let view_1 = UIView()
            let view_2 = UIView()
            let view_3 = UIView()

            var views: [UIView] {
                [view_0, view_1, view_2, view_3]
            }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    for view in views {
                        view
                    }
                }
            }

            @Test
            func forIn() {
                activation = layout.active()

                expectView(root, superview: window, subviews: views)
                expectView(view_0, superview: root, subviews: [])
                expectView(view_1, superview: root, subviews: [])
                expectView(view_2, superview: root, subviews: [])
                expectView(view_3, superview: root, subviews: [])
            }
        }
    }

    final class ComplexUsage: LayoutDSLTestsBase {
        @Test
        func onActivate() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    child.sl.sublayout {
                        label.sl.onActivate {
                            $0.text = "test onActivate"
                            $0.textColor = .green
                        }
                    }.onActivate {
                        $0.backgroundColor = .yellow
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [child])
            expectView(child, superview: root, subviews: [label])
            expectView(label, superview: child, subviews: [])
            #expect(child.backgroundColor == UIColor.yellow)
            #expect(label.text == "test onActivate")
            #expect(label.textColor == UIColor.green)
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

    final class GroupLayoutTest: LayoutDSLTestsBase {
        @Test
        func groupLayout() {
            let group1_1 = UIView()
            let group1_2 = UIView()
            let group1_3 = UIView()
            let group2_1 = UIView()
            let group2_2 = UIView()

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
            let stackView = UIStackView()
            let notArrangedview1 = UIView()
            let notArrangedview2 = UIView()
            let arrangedView1 = UIView()
            let arrangedView2 = UIView()
            let arrangedView3 = UIView()

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

    final class ModularLayoutTests: LayoutDSLTestsBase {
        @MainActor
        struct Module1: ModularLayout {
            let view1 = UIView()
            let view2 = UIView()
            let view3 = UIView()

            @LayoutBuilder var layout: some Layout {
                view1.sl.sublayout {
                    view2
                }

                view3
            }
        }

        @MainActor
        struct Module2: ModularLayout {
            let view1 = UIView()
            let view2 = UIView()
            let view3 = UIView()

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

    final class GuideLayoutTest: LayoutDSLTestsBase {
        @Test
        func guideLayout() {
            let layoutGuide = UILayoutGuide().sl.identifying("layoutGuide")

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
            var optionalLayoutGuide: UILayoutGuide? = nil
            
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
            
            let layoutGuide = UILayoutGuide().sl.identifying("layoutGuide")
            optionalLayoutGuide = layoutGuide
            
            activation = layout.update(fromActivation: activation!)
            
            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [])
            expectLayoutGuides(root, layoutGuides: [layoutGuide])
            expectOwnerView(layoutGuide, ownerView: root)
        }
    }

    final class AnyLayoutTest: LayoutDSLTestsBase {
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

    // TODO: - Not support performance
//    final class TupleLayoutTests: LayoutDSLTestsBase {
//        @Test
//        func tupleLayout10() {
//            let rootView = UIView()
//            measure {
//                let layout = layouts(rootView)
//                layout.finalActive()
//            }
//        }
//    
//        @LayoutBuilder
//        func layouts(_ rootView: UIView) -> some Layout {
//            rootView.sl.identifying("root").sl.sublayout {
//                label(1)
//                label(2)
//                label(3)
//                label(4)
//                label(5)
//                label(6)
//                label(7)
//                label(8)
//                label(9)
//                label(10)
//            }
//        }
//    
//        private func label(_ index: Int) -> UILabel {
//            let label = UILabel()
//            let text = "view." + index.description
//            label.text = text
//            label.accessibilityIdentifier = text
//            return label
//        }
//    }
}
