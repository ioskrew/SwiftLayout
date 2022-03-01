import Foundation
import UIKit

public struct AnchorsLayout<L: Layout>: Layout {
    
    let layout: L
    let anchors: [Constraint]
    
    public var debugDescription: String {
        "AnchorsLayout<\(L.self)>"
    }
}

public extension AnchorsLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        layout.traverse(superview, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        let information = firstViewInformation(superview)
        handler(information, anchors)
        layout.traverse(superview, constraintHndler: handler)
    }
}
