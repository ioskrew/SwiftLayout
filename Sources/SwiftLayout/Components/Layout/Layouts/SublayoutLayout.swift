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
        superlayout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        
        if let information = superlayout.firstViewInformation(superview) {
            sublayout.traverse(information.view, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        superlayout.traverse(superview, constraintHndler: handler)
        
        if let information = superlayout.firstViewInformation(superview) {
            sublayout.traverse(information.view, constraintHndler: handler)
        }
    }
}
