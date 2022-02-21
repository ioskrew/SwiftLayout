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
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        layout.traverse(superview, continueAfterViewLayout: false, traverseHandler: { superview, subview, identifier, animationDisabled in
            handler(superview, subview, anchors, viewInfoSet)
            layout.traverse(subview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        })
    }
}
