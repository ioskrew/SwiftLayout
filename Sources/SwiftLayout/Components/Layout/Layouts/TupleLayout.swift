import Foundation
import UIKit

public struct TupleLayout<L>: Layout {
    internal init(_ layout: L) {
        self.layout = layout
    }
    
    let layout: L
    
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
    
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        for traversal in traversals {
            traversal.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        for traversal in traversals {
            traversal.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}
