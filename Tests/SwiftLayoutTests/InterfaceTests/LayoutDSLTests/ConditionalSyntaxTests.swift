import SwiftLayout
import Testing
import SwiftLayoutPlatform

extension LayoutDSLTests {

    enum ConditionalSyntaxTests {

        final class IfFlagTests: LayoutDSLTestsBase {
            var flag = true

            let trueView = SLView()
            let falseView = SLView()

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

        final class SwitchCaseTests: LayoutDSLTestsBase {
            enum Test: String, CaseIterable {
                case first
                case second
                case third
            }

            let first = SLView()
            let second = SLView()
            let third = SLView()

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

        final class OptionalTests: LayoutDSLTestsBase {
            var optional: SLView?

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
                optional = SLView()
                activation = layout.active()

                expectView(root, superview: window, subviews: [red])
                expectView(red, superview: root, subviews: [optional!])
                expectView(optional!, superview: red, subviews: [])
            }
        }

        final class ForInTests: LayoutDSLTestsBase {
            let view_0 = SLView()
            let view_1 = SLView()
            let view_2 = SLView()
            let view_3 = SLView()

            var views: [SLView] {
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
}
