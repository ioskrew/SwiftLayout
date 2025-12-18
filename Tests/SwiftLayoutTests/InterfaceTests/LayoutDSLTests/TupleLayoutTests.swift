import SwiftLayout
import Testing
import SwiftLayoutPlatform

extension LayoutDSLTests {

    // MARK: - TupleLayout Tests (Legacy: TupleLayout2 ~ TupleLayout10)

    final class TupleLayoutTests: LayoutDSLTestsBase {

        @Test
        func tupleLayout2() {
            let views = (1...2).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout3() {
            let views = (1...3).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout4() {
            let views = (1...4).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout5() {
            let views = (1...5).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout6() {
            let views = (1...6).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout7() {
            let views = (1...7).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout8() {
            let views = (1...8).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout9() {
            let views = (1...9).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout10() {
            let views = (1...10).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                    views[9]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }
    }

    // MARK: - Parameter Pack TupleLayout Tests (iOS 17+ / macOS 14+)

    final class ParameterPackTupleLayoutTests: LayoutDSLTestsBase {

        @Test
        func tupleLayout11() {
            guard #available(iOS 17, macOS 14, tvOS 17, visionOS 1, *) else { return }

            let views = (1...11).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                    views[9]
                    views[10]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout12() {
            guard #available(iOS 17, macOS 14, tvOS 17, visionOS 1, *) else { return }

            let views = (1...12).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                    views[9]
                    views[10]
                    views[11]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout15() {
            guard #available(iOS 17, macOS 14, tvOS 17, visionOS 1, *) else { return }

            let views = (1...15).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                    views[9]
                    views[10]
                    views[11]
                    views[12]
                    views[13]
                    views[14]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayout20() {
            guard #available(iOS 17, macOS 14, tvOS 17, visionOS 1, *) else { return }

            let views = (1...20).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0]
                    views[1]
                    views[2]
                    views[3]
                    views[4]
                    views[5]
                    views[6]
                    views[7]
                    views[8]
                    views[9]
                    views[10]
                    views[11]
                    views[12]
                    views[13]
                    views[14]
                    views[15]
                    views[16]
                    views[17]
                    views[18]
                    views[19]
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
        }

        @Test
        func tupleLayoutWithAnchors() {
            guard #available(iOS 17, macOS 14, tvOS 17, visionOS 1, *) else { return }

            let views = (1...12).map { SLView().withIdentifier("v\($0)") }

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    views[0].sl.anchors { Anchors.top.leading.equalToSuper() }
                    views[1].sl.anchors { Anchors.top.equalToSuper() }
                    views[2].sl.anchors { Anchors.top.trailing.equalToSuper() }
                    views[3].sl.anchors { Anchors.leading.equalToSuper() }
                    views[4].sl.anchors { Anchors.center.equalToSuper() }
                    views[5].sl.anchors { Anchors.trailing.equalToSuper() }
                    views[6].sl.anchors { Anchors.bottom.leading.equalToSuper() }
                    views[7].sl.anchors { Anchors.bottom.equalToSuper() }
                    views[8].sl.anchors { Anchors.bottom.trailing.equalToSuper() }
                    views[9].sl.anchors { Anchors.width.equalTo(constant: 50) }
                    views[10].sl.anchors { Anchors.height.equalTo(constant: 50) }
                    views[11].sl.anchors { Anchors.size.equalTo(width: 100, height: 100) }
                }
            }

            activation = layout.active()
            expectView(root, superview: window, subviews: views)
            #expect(!root.constraints.isEmpty)
        }
    }
}
