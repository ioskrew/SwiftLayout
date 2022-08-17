import UIKit

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

extension LayoutBuilder {
    
    public static func buildBlock<L>(_ layout: L) -> L {
        layout
    }
    
    public static func buildBlock<L: Layout, L1: Layout>(_ l: L, _ l1: L1) -> TupleLayout {
        TupleLayout(l, l1)
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout>(_ l: L, _ l1: L1, _ l2: L2) -> TupleLayout {
        TupleLayout(l, l1, l2)
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3) -> TupleLayout {
        TupleLayout(l, l1, l2, l3)
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4) -> TupleLayout {
        TupleLayout(l, l1, l2, l3, l4)
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5) -> TupleLayout {
        TupleLayout(l, l1, l2, l3, l4, l5)
    }

    public static func buildBlock<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6) -> TupleLayout {
        TupleLayout(l, l1, l2, l3, l4, l5, l6)
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
