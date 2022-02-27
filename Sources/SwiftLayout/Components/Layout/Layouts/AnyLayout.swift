import Foundation
import UIKit

protocol AnyLayoutBox: Layout {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    let layout: L
    
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        layout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        layout.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
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

public extension AnyLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        box.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        box.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}
