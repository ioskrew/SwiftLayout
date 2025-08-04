import UIKit

@MainActor
@resultBuilder
public struct LayoutBuilder {

    public static func buildExpression<L: Layout>(_ layout: L) -> L {
        layout
    }

    public static func buildExpression<L: Layout>(_ layout: L?) -> OptionalLayout<L> {
        OptionalLayout(sublayout: layout)
    }

    public static func buildExpression<V: UIView>(_ uiView: V) -> ViewLayout<V, EmptyLayout> {
        ViewLayout(uiView, sublayout: EmptyLayout())
    }

    public static func buildExpression<V: UIView>(_ uiView: V?) -> OptionalLayout<ViewLayout<V, EmptyLayout>> {
        var viewLayout: ViewLayout<V, EmptyLayout>?
        if let uiView {
            viewLayout = ViewLayout(uiView, sublayout: EmptyLayout())
        }

        return OptionalLayout(sublayout: viewLayout)
    }

    public static func buildExpression<LayoutGuide: UILayoutGuide>(_ layoutGuide: LayoutGuide) -> GuideLayout<LayoutGuide> {
        GuideLayout(layoutGuide)
    }

    public static func buildExpression<LayoutGuide: UILayoutGuide>(_ layoutGuide: LayoutGuide?) -> OptionalLayout<GuideLayout<LayoutGuide>> {
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
