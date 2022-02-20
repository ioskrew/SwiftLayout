import Foundation

protocol AnyLayoutBox: Layout, LayoutTraversal {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    let layout: L
    
    var traversals: [LayoutTraversal] {
        if let traversal = layout as? LayoutTraversal {
            return [traversal]
        } else {
            return []
        }
    }
    
    var debugDescription: String {
        "_AnyLayoutBox<\(L.self)>"
    }
}

public struct AnyLayout: Layout {
    let box: AnyLayoutBox
    
    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }
    
    public var debugDescription: String {
        "AnyLayout:\(box)"
    }
}
