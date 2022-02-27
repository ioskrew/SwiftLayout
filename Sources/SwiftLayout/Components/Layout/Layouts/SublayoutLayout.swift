import Foundation
import UIKit

public struct SublayoutLayout<Super: Layout, Sub: Layout>: Layout {
    internal init(_ superlayout: Super, _ sublayout: Sub) {
        self.superlayout = superlayout
        self.sublayout = sublayout
    }
    
    let superlayout: Super
    let sublayout: Sub
    
    public var debugDescription: String {
        "SublayoutLayout<\(Super.self), Sub: \(Sub.self)>"
    }
}

public extension SublayoutLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        superlayout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: { information in
            handler(information)
            sublayout.traverse(information.view, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        })
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        superlayout.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: { superview, subview, constraints, viewInfoSet in
            handler(superview, subview, constraints, viewInfoSet)
            sublayout.traverse(subview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        })
    }
}
