import UIKit

@MainActor
@resultBuilder
public struct LayoutBuilder {

    public static func buildExpression<L: Layout>(_ layout: L) -> L {
        layout
    }

    public static func buildExpression<L: Layout>(_ layout: L?) -> OptionalLayout<L> {
        OptionalLayout(layout: layout)
    }

    public static func buildExpression<V: UIView>(_ uiView: V) -> ViewLayout<V> {
        ViewLayout(uiView)
    }

    public static func buildExpression<V: UIView>(_ uiView: V?) -> OptionalLayout<ViewLayout<V>> {
        var viewLayout: ViewLayout<V>?
        if let view = uiView {
            viewLayout = ViewLayout(view)
        }

        return OptionalLayout(layout: viewLayout)
    }
}

// swiftlint:disable identifier_name

extension LayoutBuilder {

    public static func buildBlock<L>(_ layout: L) -> L {
        layout
    }

    public static func buildBlock<L: Layout, L1: Layout>(_ l: L, _ l1: L1) -> some Layout {
        ListLayout(l, ListLayout(l1))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout>(_ l: L, _ l1: L1, _ l2: L2) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2)))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4)))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4, ListLayout(l5))))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4, ListLayout(l5, ListLayout(l6)))))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4, ListLayout(l5, ListLayout(l6, ListLayout(l7))))))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4, ListLayout(l5, ListLayout(l6, ListLayout(l7, ListLayout(l8)))))))))
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout, L9: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8, _ l9: L9) -> some Layout {
        ListLayout(l, ListLayout(l1, ListLayout(l2, ListLayout(l3, ListLayout(l4, ListLayout(l5, ListLayout(l6, ListLayout(l7, ListLayout(l8, ListLayout(l9))))))))))
    }

    public static func buildArray<L: Layout>(_ components: [L]) -> ArrayLayout<L> {
        ArrayLayout<L>(layouts: components)
    }

    public static func buildOptional<L: Layout>(_ component: L?) -> OptionalLayout<L> {
        OptionalLayout(layout: component)
    }

    public static func buildIf<L: Layout>(_ component: L?) -> OptionalLayout<L> {
        OptionalLayout(layout: component)
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

// swiftlint:enable identifier_name
