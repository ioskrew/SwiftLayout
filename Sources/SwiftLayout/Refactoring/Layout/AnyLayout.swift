import Foundation
import UIKit

protocol AnyLayoutBox: Layout, LayoutTraversal {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    let layout: L
    
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: (UIView?, UIView, String?, Bool) -> Void) {
        cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        cast(layout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
    var debugDescription: String {
        "_AnyLayoutBox<\(L.self)>"
    }
}

public struct AnyLayout: Layout {
    let box: AnyLayoutBox
    
    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }
    
    public var debugDescription: String {
        "AnyLayout:\(box)"
    }
}
