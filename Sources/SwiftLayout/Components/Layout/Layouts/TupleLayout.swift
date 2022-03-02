import Foundation
import UIKit

public struct TupleLayout<L>: Layout {
    let layout: L
    
    init(_ layout: L) {
        self.layout = layout
    }
    
    public var debugDescription: String {
        "TupleLayout<\(L.self)>"
    }
}

public extension TupleLayout {
    var traversals: [Layout] {
        Mirror(reflecting: layout).children.compactMap { (_, value) in
            value as? Layout
        }
    }
    
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        for traversal in traversals {
            traversal.traverse(superview, traverseHandler: handler)
        }
    }
    
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        for traversal in traversals {
            traversal.traverse(superview, constraintHndler: handler)
        }
    }
}
