public struct TupleLayout: Layout {
    
    public var sublayouts: [Layout]
    
    init<L: Layout, L1: Layout>(_ l: L, _ l1: L1) {
        self.sublayouts = [l, l1]
    }
    
    init<L: Layout, L1: Layout, L2: Layout>(_ l: L, _ l1: L1, _ l2: L2) {
        self.sublayouts = [l, l1, l2]
    }
    
    init<L: Layout, L1: Layout, L2: Layout, L3: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3) {
        self.sublayouts = [l, l1, l2, l3]
    }
    
    init<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4) {
        self.sublayouts = [l, l1, l2, l3, l4]
    }
    
    init<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5) {
        self.sublayouts = [l, l1, l2, l3, l4, l5]
    }
    
    init<L: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout>(_ l: L, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6) {
        self.sublayouts = [l, l1, l2, l3, l4, l5, l6]
    }
    
}
