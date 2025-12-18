import SwiftLayoutPlatform

// MARK: - TupleLayout2

public struct TupleLayout2<L0: Layout, L1: Layout>: Layout {
    private let l0: L0
    private let l1: L1

    init(_ l0: L0, _ l1: L1) {
        self.l0 = l0
        self.l1 = l1
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
    }
}

// MARK: - TupleLayout3

public struct TupleLayout3<L0: Layout, L1: Layout, L2: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2

    init(_ l0: L0, _ l1: L1, _ l2: L2) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
    }
}

// MARK: - TupleLayout4

public struct TupleLayout4<L0: Layout, L1: Layout, L2: Layout, L3: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
    }
}

// MARK: - TupleLayout5

public struct TupleLayout5<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
    }
}

// MARK: - TupleLayout6

public struct TupleLayout6<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4
    private let l5: L5

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option) +
        l5.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
        l5.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
        l5.layoutDidActivate()
    }
}

// MARK: - TupleLayout7

public struct TupleLayout7<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4
    private let l5: L5
    private let l6: L6

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
        self.l6 = l6
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option) +
        l5.layoutComponents(superview: superview, option: option) +
        l6.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
        l5.layoutWillActivate()
        l6.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
        l5.layoutDidActivate()
        l6.layoutDidActivate()
    }
}

// MARK: - TupleLayout8

public struct TupleLayout8<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4
    private let l5: L5
    private let l6: L6
    private let l7: L7

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
        self.l6 = l6
        self.l7 = l7
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option) +
        l5.layoutComponents(superview: superview, option: option) +
        l6.layoutComponents(superview: superview, option: option) +
        l7.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
        l5.layoutWillActivate()
        l6.layoutWillActivate()
        l7.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
        l5.layoutDidActivate()
        l6.layoutDidActivate()
        l7.layoutDidActivate()
    }
}

// MARK: - TupleLayout9

public struct TupleLayout9<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4
    private let l5: L5
    private let l6: L6
    private let l7: L7
    private let l8: L8

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
        self.l6 = l6
        self.l7 = l7
        self.l8 = l8
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option) +
        l5.layoutComponents(superview: superview, option: option) +
        l6.layoutComponents(superview: superview, option: option) +
        l7.layoutComponents(superview: superview, option: option) +
        l8.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
        l5.layoutWillActivate()
        l6.layoutWillActivate()
        l7.layoutWillActivate()
        l8.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
        l5.layoutDidActivate()
        l6.layoutDidActivate()
        l7.layoutDidActivate()
        l8.layoutDidActivate()
    }
}

// MARK: - TupleLayout10

public struct TupleLayout10<L0: Layout, L1: Layout, L2: Layout, L3: Layout, L4: Layout, L5: Layout, L6: Layout, L7: Layout, L8: Layout, L9: Layout>: Layout {
    private let l0: L0
    private let l1: L1
    private let l2: L2
    private let l3: L3
    private let l4: L4
    private let l5: L5
    private let l6: L6
    private let l7: L7
    private let l8: L8
    private let l9: L9

    init(_ l0: L0, _ l1: L1, _ l2: L2, _ l3: L3, _ l4: L4, _ l5: L5, _ l6: L6, _ l7: L7, _ l8: L8, _ l9: L9) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
        self.l4 = l4
        self.l5 = l5
        self.l6 = l6
        self.l7 = l7
        self.l8 = l8
        self.l9 = l9
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        l0.layoutComponents(superview: superview, option: option) +
        l1.layoutComponents(superview: superview, option: option) +
        l2.layoutComponents(superview: superview, option: option) +
        l3.layoutComponents(superview: superview, option: option) +
        l4.layoutComponents(superview: superview, option: option) +
        l5.layoutComponents(superview: superview, option: option) +
        l6.layoutComponents(superview: superview, option: option) +
        l7.layoutComponents(superview: superview, option: option) +
        l8.layoutComponents(superview: superview, option: option) +
        l9.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        l0.layoutWillActivate()
        l1.layoutWillActivate()
        l2.layoutWillActivate()
        l3.layoutWillActivate()
        l4.layoutWillActivate()
        l5.layoutWillActivate()
        l6.layoutWillActivate()
        l7.layoutWillActivate()
        l8.layoutWillActivate()
        l9.layoutWillActivate()
    }

    public func layoutDidActivate() {
        l0.layoutDidActivate()
        l1.layoutDidActivate()
        l2.layoutDidActivate()
        l3.layoutDidActivate()
        l4.layoutDidActivate()
        l5.layoutDidActivate()
        l6.layoutDidActivate()
        l7.layoutDidActivate()
        l8.layoutDidActivate()
        l9.layoutDidActivate()
    }
}
