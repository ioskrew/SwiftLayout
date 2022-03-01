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
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        layout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        layout.traverse(superview, continueAfterViewLayout: false, traverseHandler: { information in
            handler(information.superview, information.view, anchors)
            layout.traverse(information.view, constraintHndler: handler)
        })
    }
}
