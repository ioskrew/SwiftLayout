import Foundation
import UIKit

public struct ArrayLayout<L: Layout>: Layout {
    let layouts: [L]
    
    public var debugDescription: String {
        "ArrayLayout<\(L.self)>"
    }
}

public extension ArrayLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        for layout in layouts {
            layout.traverse(superview, traverseHandler: handler)
        }
    }
    
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        for layout in layouts {
            layout.traverse(superview, constraintHndler: handler)
        }
    }
}
