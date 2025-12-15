import SwiftLayoutPlatform

@MainActor
@resultBuilder
public struct LayoutBuilder {

    public static func buildExpression<L: Layout>(_ layout: L) -> L {
        layout
    }

    public static func buildExpression<L: Layout>(_ layout: L?) -> OptionalLayout<L> {
        OptionalLayout(sublayout: layout)
    }

    public static func buildExpression<V: SLView>(_ view: V) -> ViewLayout<V, EmptyLayout> {
        ViewLayout(view, sublayout: EmptyLayout())
    }

    public static func buildExpression<V: SLView>(_ view: V?) -> OptionalLayout<ViewLayout<V, EmptyLayout>> {
        var viewLayout: ViewLayout<V, EmptyLayout>?
        if let view {
            viewLayout = ViewLayout(view, sublayout: EmptyLayout())
        }

        return OptionalLayout(sublayout: viewLayout)
    }

    public static func buildExpression<LayoutGuide: SLLayoutGuide>(_ layoutGuide: LayoutGuide) -> GuideLayout<LayoutGuide> {
        GuideLayout(layoutGuide)
    }

    public static func buildExpression<LayoutGuide: SLLayoutGuide>(_ layoutGuide: LayoutGuide?) -> OptionalLayout<GuideLayout<LayoutGuide>> {
        var guideLayout: GuideLayout<LayoutGuide>?
        if let layoutGuide {
            guideLayout = GuideLayout(layoutGuide)
        }

        return OptionalLayout(sublayout: guideLayout)
    }
}

extension LayoutBuilder {

    public static func buildBlock<L>(_ layout: L) -> L {
        layout
    }

    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
    public static func buildBlock<each L: Layout>(_ layouts: repeat each L) -> TupleLayout<repeat each L> {
        TupleLayout(layouts: (repeat each layouts))
    }

    public static func buildArray<L: Layout>(_ components: [L]) -> ArrayLayout<L> {
        ArrayLayout(sublayouts: components)
    }

    public static func buildOptional<L: Layout>(_ component: L?) -> OptionalLayout<L> {
        OptionalLayout(sublayout: component)
    }

    public static func buildIf<L: Layout>(_ component: L?) -> OptionalLayout<L> {
        OptionalLayout(sublayout: component)
    }

    public static func buildEither<True: Layout, False: Layout>(first component: True) -> ConditionalLayout<True, False> {
        ConditionalLayout<True, False>(layout: .trueLayout(component))
    }

    public static func buildEither<True: Layout, False: Layout>(second component: False) -> ConditionalLayout<True, False> {
        ConditionalLayout<True, False>(layout: .falseLayout(component))
    }

    public static func buildLimitedAvailability<L: Layout>(_ component: L) -> AnyLayout {
        AnyLayout(component)
    }
}

// MARK: - buildBlock (Legacy: iOS 16 / macOS 12-13)

extension LayoutBuilder {

    public static func buildBlock<L0: Layout, L1: Layout>(
        _ l0: L0, _ l1: L1
    ) -> TupleLayout2<L0, L1> {
        TupleLayout2(l0, l1)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2
    ) -> TupleLayout3<L0, L1, L2> {
        TupleLayout3(l0, l1, l2)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3
    ) -> TupleLayout4<L0, L1, L2, L3> {
        TupleLayout4(l0, l1, l2, l3)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4
    ) -> TupleLayout5<L0, L1, L2, L3, L4> {
        TupleLayout5(l0, l1, l2, l3, l4)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5
    ) -> TupleLayout6<L0, L1, L2, L3, L4, L5> {
        TupleLayout6(l0, l1, l2, l3, l4, l5)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6
    ) -> TupleLayout7<L0, L1, L2, L3, L4, L5, L6> {
        TupleLayout7(l0, l1, l2, l3, l4, l5, l6)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7
    ) -> TupleLayout8<L0, L1, L2, L3, L4, L5, L6, L7> {
        TupleLayout8(l0, l1, l2, l3, l4, l5, l6, l7)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8
    ) -> TupleLayout9<L0, L1, L2, L3, L4, L5, L6, L7, L8> {
        TupleLayout9(l0, l1, l2, l3, l4, l5, l6, l7, l8)
    }

    public static func buildBlock<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout, L9: Layout>(
        _ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8, _ l9: L9
    ) -> TupleLayout10<L0, L1, L2, L3, L4, L5, L6, L7, L8, L9> {
        TupleLayout10(l0, l1, l2, l3, l4, l5, l6, l7, l8, l9)
    }
}
