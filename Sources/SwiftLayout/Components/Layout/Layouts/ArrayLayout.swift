import Foundation
import UIKit

public struct ArrayLayout<L: Layout>: Layout {
    let layouts: [L]
    
    public var debugDescription: String {
        "ArrayLayout<\(L.self)>"
    }
}

public extension ArrayLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        for layout in layouts {
            layout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        for layout in layouts {
            layout.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}
