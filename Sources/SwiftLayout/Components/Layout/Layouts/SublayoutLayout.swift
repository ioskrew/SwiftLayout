import Foundation
import UIKit

public struct SublayoutLayout<Super: Layout, Sub: Layout>: Layout {
    let superlayout: Super
    let sublayout: Sub
    
    init(_ superlayout: Super, _ sublayout: Sub) {
        self.superlayout = superlayout
        self.sublayout = sublayout
    }
    
    public var debugDescription: String {
        "SublayoutLayout<\(Super.self), Sub: \(Sub.self)>"
    }
}

public extension SublayoutLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        superlayout.traverse(superview, traverseHandler: handler)
        
        if let information = superlayout.firstViewInformation(superview) {
            sublayout.traverse(information.view, traverseHandler: handler)
        }
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        superlayout.traverse(superview, constraintHndler: handler)
        
        if let information = superlayout.firstViewInformation(superview) {
            sublayout.traverse(information.view, constraintHndler: handler)
        }
    }
}
