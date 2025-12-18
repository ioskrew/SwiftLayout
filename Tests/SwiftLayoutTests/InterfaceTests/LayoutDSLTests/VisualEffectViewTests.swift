#if canImport(UIKit)
import SwiftLayout
import Testing
import SwiftLayoutPlatform
import UIKit

extension LayoutDSLTests {

    final class VisualEffectViewTests: LayoutDSLTestsBase {
        @Test
        func sublayoutShouldBeAddedToContentView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let childView = SLView().withIdentifier("child")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    visualEffectView.sl.sublayout {
                        childView
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [visualEffectView])
            // childView는 visualEffectView.contentView의 subview여야 함
            expectView(childView, superview: visualEffectView.contentView, subviews: [])
        }

        @Test
        func nestedSublayoutShouldBeAddedToContentView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let childView1 = SLView().withIdentifier("child1")
            let childView2 = SLView().withIdentifier("child2")
            let nestedView = SLView().withIdentifier("nested")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    visualEffectView.sl.sublayout {
                        childView1.sl.sublayout {
                            nestedView
                        }
                        childView2
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [visualEffectView])
            // 직접적인 자식들은 contentView에 추가됨
            expectView(visualEffectView.contentView, superview: visualEffectView, subviews: [childView1, childView2])
            expectView(childView1, superview: visualEffectView.contentView, subviews: [nestedView])
            expectView(nestedView, superview: childView1, subviews: [])
        }

        @Test
        func deactiveShouldRemoveFromContentView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let childView = SLView().withIdentifier("child")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    visualEffectView.sl.sublayout {
                        childView
                    }
                }
            }

            activation = layout.active()
            activation?.deactive()

            expectView(root, superview: window, subviews: [])
            #expect(visualEffectView.superview == nil)
            expectView(visualEffectView.contentView, superview: visualEffectView, subviews: [])
            expectView(childView, superview: nil, subviews: [])
        }

        @Test
        func updateLayoutShouldWorkWithContentView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let childView1 = SLView().withIdentifier("child1")
            let childView2 = SLView().withIdentifier("child2")
            var showFirst = true

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    visualEffectView.sl.sublayout {
                        if showFirst {
                            childView1
                        } else {
                            childView2
                        }
                    }
                }
            }

            activation = layout.active()
            expectView(childView1, superview: visualEffectView.contentView, subviews: [])
            expectView(childView2, superview: nil, subviews: [])

            showFirst = false
            activation = layout.update(fromActivation: activation!)
            expectView(childView1, superview: nil, subviews: [])
            expectView(childView2, superview: visualEffectView.contentView, subviews: [])
        }

        @Test
        func layoutGuideShouldBeAddedToContentView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let layoutGuide = SLLayoutGuide().withIdentifier("guide")

            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    visualEffectView.sl.sublayout {
                        layoutGuide
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [visualEffectView])
            expectLayoutGuides(visualEffectView.contentView, layoutGuides: [layoutGuide])
            expectOwnerView(layoutGuide, ownerView: visualEffectView.contentView)
        }
    }
}
#endif
