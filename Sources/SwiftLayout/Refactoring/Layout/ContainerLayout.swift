import Foundation

public struct OneLayout<L>: Layout {
    let l: L
}

public struct TwoLayout<L, L1>: Layout {
    let l: L
    let l1: L1
}

public struct ThreeLayout<L, L1, L2>: Layout {
    let l: L
    let l1: L1
    let l2: L2
}

public struct FourLayout<L, L1, L2, L3>: Layout {
    let l: L
    let l1: L1
    let l2: L2
    let l3: L3
}

public struct FiveLayout<L, L1, L2, L3, L4>: Layout {
    let l: L
    let l1: L1
    let l2: L2
    let l3: L3
    let l4: L4
}

public struct SixLayout<L, L1, L2, L3, L4, L5>: Layout {
    let l: L
    let l1: L1
    let l2: L2
    let l3: L3
    let l4: L4
    let l5: L5
}

public struct SevenLayout<L, L1, L2, L3, L4, L5, L6>: Layout {
    let l: L
    let l1: L1
    let l2: L2
    let l3: L3
    let l4: L4
    let l5: L5
    let l6: L6
}

public struct ArrayLayout<L: Layout>: Layout {
    let layouts: [L]
}

public struct OptionalLayout<L: Layout>: Layout {
    let layout: L?
}

public struct ConditionalLayout<True: Layout, False: Layout>: Layout {
    enum Layout {
        case trueLayout(True)
        case falseLayout(False)
    }
    let layout: Layout
}

protocol AnyLayoutBox: Layout {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    let layout: L
}

public struct AnyLayout: Layout {
    let box: AnyLayoutBox
    
    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }
}

public struct AnchorLayout<L: Layout>: Layout {
    let layout: L
    let anchors: [Constraint]
}
