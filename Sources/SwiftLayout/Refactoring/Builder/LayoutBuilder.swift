import Foundation

@resultBuilder
public struct LayoutBuilder {
    public static func buildBlock<L>(_ l: L) -> OneLayout<L> {
        OneLayout<L>(l: l)
    }
    
    public static func buildBlock<L, L1>(_ l: L, _ l1: L1) -> TwoLayout<L, L1> {
        TwoLayout<L, L1>(l: l, l1: l1)
    }
    
    public static func buildBlock<L, L1, L2>(_ l: L, _ l1: L1, _ l2: L2) -> ThreeLayout<L, L1, L2> {
        ThreeLayout<L, L1, L2>(l: l, l1: l1, l2: l2)
    }
    
    public static func buildBlock<L, L1, L2, L3>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3) -> FourLayout<L, L1, L2, L3> {
        FourLayout<L, L1, L2, L3>(l: l, l1: l1, l2: l2, l3: l3)
    }
    
    public static func buildBlock<L, L1, L2, L3, L4>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4) -> FiveLayout<L, L1, L2, L3, L4> {
        FiveLayout<L, L1, L2, L3, L4>(l: l, l1: l1, l2: l2, l3: l3, l4: l4)
    }
    
    public static func buildBlock<L, L1, L2, L3, L4, L5>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5) -> SixLayout<L, L1, L2, L3, L4, L5> {
        SixLayout<L, L1, L2, L3, L4, L5>(l: l, l1: l1, l2: l2, l3: l3, l4: l4, l5: l5)
    }
    
    public static func buildBlock<L, L1, L2, L3, L4, L5, L6>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6) -> SevenLayout<L, L1, L2, L3, L4, L5, L6> {
        SevenLayout<L, L1, L2, L3, L4, L5, L6>(l: l, l1: l1, l2: l2, l3: l3, l4: l4, l5: l5, l6: l6)
    }
    
    public static func buildArray<L: Layout>(_ components: [L]) -> ArrayLayout<L> {
        ArrayLayout<L>(layouts: components)
    }
    
    public static func buildOptional<L: Layout>(_ component: L?) -> OptionalLayout<L> {
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
