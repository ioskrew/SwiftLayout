@testable import SwiftLayout
import Testing
import SwiftLayoutPlatform

@MainActor
struct HierarchyNodeTests {

    // MARK: - ViewNode Tests

    @MainActor
    struct ViewNodeTests {

        @Test
        func initialization() {
            let view = SLView()
            let node = ViewNode(view)

            #expect(node.baseObject === view)
            #expect(node.baseObjectIdentifier == ObjectIdentifier(view))
        }

        @Test
        func nodeIdentifier() {
            let view = SLView().withIdentifier("testView")
            let node = ViewNode(view)

            #expect(node.nodeIdentifier == "testView")
        }

        @Test
        func nodeIdentifierWhenNil() {
            let view = SLView()
            let node = ViewNode(view)

            #expect(node.nodeIdentifier == nil)
        }

        @Test
        func updateTranslatesAutoresizingMaskIntoConstraints() {
            let view = SLView()
            view.translatesAutoresizingMaskIntoConstraints = true
            let node = ViewNode(view)

            node.updateTranslatesAutoresizingMaskIntoConstraints()

            #expect(view.translatesAutoresizingMaskIntoConstraints == false)
        }

        @Test
        func addToSuperview() {
            let superview = SLView()
            let view = SLView()
            let node = ViewNode(view)

            node.addToSuperview(superview, option: [])

            #expect(view.superview === superview)
            #expect(superview.subviews.contains(view))
        }

        @Test
        func addToSuperviewWhenNilSuperview() {
            let view = SLView()
            let node = ViewNode(view)

            // Should not crash
            node.addToSuperview(nil, option: [])

            #expect(view.superview == nil)
        }

        @Test
        func removeFromSuperview() {
            let superview = SLView()
            let view = SLView()
            superview.addSubview(view)
            let node = ViewNode(view)

            node.removeFromSuperview(superview)

            #expect(view.superview == nil)
            #expect(!superview.subviews.contains(view))
        }

        @Test
        func removeFromSuperviewIgnoresWrongSuperview() {
            let superview = SLView()
            let wrongSuperview = SLView()
            let view = SLView()
            superview.addSubview(view)
            let node = ViewNode(view)

            // Should not remove from actual superview
            node.removeFromSuperview(wrongSuperview)

            #expect(view.superview === superview)
        }

        @Test
        func weakReference() {
            var view: SLView? = SLView()
            let node = ViewNode(view!)

            #expect(node.baseObject != nil)

            view = nil

            #expect(node.baseObject == nil)
        }

        #if canImport(UIKit)
        @Test
        func addToStackView() {
            let stackView = SLStackView()
            let view = SLView()
            let node = ViewNode(view)

            node.addToSuperview(stackView, option: [])

            #expect(stackView.arrangedSubviews.contains(view))
        }

        @Test
        func addToStackViewWithIsNotArranged() {
            let stackView = SLStackView()
            let view = SLView()
            let node = ViewNode(view)

            node.addToSuperview(stackView, option: [.isNotArranged])

            #expect(!stackView.arrangedSubviews.contains(view))
            #expect(stackView.subviews.contains(view))
        }

        @Test
        func addToVisualEffectView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let view = SLView()
            let node = ViewNode(view)

            node.addToSuperview(visualEffectView, option: [])

            #expect(view.superview === visualEffectView.contentView)
            #expect(visualEffectView.contentView.subviews.contains(view))
        }

        @Test
        func removeFromVisualEffectView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let view = SLView()
            visualEffectView.contentView.addSubview(view)
            let node = ViewNode(view)

            node.removeFromSuperview(visualEffectView)

            #expect(view.superview == nil)
            #expect(!visualEffectView.contentView.subviews.contains(view))
        }

        @Test
        func removeFromVisualEffectViewIgnoresWrongSuperview() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let wrongSuperview = SLView()
            let view = SLView()
            visualEffectView.contentView.addSubview(view)
            let node = ViewNode(view)

            node.removeFromSuperview(wrongSuperview)

            #expect(view.superview === visualEffectView.contentView)
        }
        #endif
    }

    // MARK: - GuideNode Tests

    @MainActor
    struct GuideNodeTests {

        @Test
        func initialization() {
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            #expect(node.baseObject === guide)
            #expect(node.baseObjectIdentifier == ObjectIdentifier(guide))
        }

        @Test
        func nodeIdentifier() {
            let guide = SLLayoutGuide()
            #if canImport(UIKit)
            guide.identifier = "testGuide"
            #else
            guide.identifier = NSUserInterfaceItemIdentifier("testGuide")
            #endif
            let node = GuideNode(guide)

            #expect(node.nodeIdentifier == "testGuide")
        }

        @Test
        func updateTranslatesAutoresizingMaskIntoConstraintsDoesNothing() {
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            // Should not crash - guides don't have this property
            node.updateTranslatesAutoresizingMaskIntoConstraints()
        }

        @Test
        func addToSuperview() {
            let superview = SLView()
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            node.addToSuperview(superview, option: [])

            #expect(guide.owningView === superview)
            #expect(superview.layoutGuides.contains(guide))
        }

        @Test
        func addToSuperviewWhenNilSuperview() {
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            // Should not crash
            node.addToSuperview(nil, option: [])

            #expect(guide.owningView == nil)
        }

        @Test
        func removeFromSuperview() {
            let superview = SLView()
            let guide = SLLayoutGuide()
            superview.addLayoutGuide(guide)
            let node = GuideNode(guide)

            node.removeFromSuperview(superview)

            #expect(guide.owningView == nil)
            #expect(!superview.layoutGuides.contains(guide))
        }

        @Test
        func removeFromSuperviewIgnoresWrongSuperview() {
            let superview = SLView()
            let wrongSuperview = SLView()
            let guide = SLLayoutGuide()
            superview.addLayoutGuide(guide)
            let node = GuideNode(guide)

            node.removeFromSuperview(wrongSuperview)

            #expect(guide.owningView === superview)
        }

        @Test
        func weakReference() {
            var guide: SLLayoutGuide? = SLLayoutGuide()
            let node = GuideNode(guide!)

            #expect(node.baseObject != nil)

            guide = nil

            #expect(node.baseObject == nil)
        }

        @Test
        func forceLayoutDoesNothing() {
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            // Should not crash - guides don't need layout
            node.forceLayout()
        }

        @Test
        func removeSizeAndPositionAnimationDoesNothing() {
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            // Should not crash - guides don't have layer animations
            node.removeSizeAndPositionAnimation()
        }

        #if canImport(UIKit)
        @Test
        func addToVisualEffectView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let guide = SLLayoutGuide()
            let node = GuideNode(guide)

            node.addToSuperview(visualEffectView, option: [])

            #expect(guide.owningView === visualEffectView.contentView)
            #expect(visualEffectView.contentView.layoutGuides.contains(guide))
        }

        @Test
        func removeFromVisualEffectView() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let guide = SLLayoutGuide()
            visualEffectView.contentView.addLayoutGuide(guide)
            let node = GuideNode(guide)

            node.removeFromSuperview(visualEffectView)

            #expect(guide.owningView == nil)
            #expect(!visualEffectView.contentView.layoutGuides.contains(guide))
        }

        @Test
        func removeFromVisualEffectViewIgnoresWrongOwner() {
            let visualEffectView = SLVisualEffectView(effect: UIBlurEffect(style: .regular))
            let wrongSuperview = SLView()
            let guide = SLLayoutGuide()
            visualEffectView.contentView.addLayoutGuide(guide)
            let node = GuideNode(guide)

            node.removeFromSuperview(wrongSuperview)

            #expect(guide.owningView === visualEffectView.contentView)
        }
        #endif
    }

    // MARK: - HierarchyNodable Protocol Tests

    @MainActor
    struct HierarchyNodableProtocolTests {

        @Test
        func viewNodeConformsToProtocol() {
            let view = SLView()
            let node: any HierarchyNodable = ViewNode(view)

            #expect(node.baseObject === view)
        }

        @Test
        func guideNodeConformsToProtocol() {
            let guide = SLLayoutGuide()
            let node: any HierarchyNodable = GuideNode(guide)

            #expect(node.baseObject === guide)
        }

        @Test
        func baseObjectIdentifierIsStable() {
            let view = SLView()
            let node = ViewNode(view)
            let identifier1 = node.baseObjectIdentifier
            let identifier2 = node.baseObjectIdentifier

            #expect(identifier1 == identifier2)
        }
    }
}
