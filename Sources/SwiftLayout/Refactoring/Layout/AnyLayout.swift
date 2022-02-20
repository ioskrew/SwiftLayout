import Foundation
import UIKit

protocol AnyLayoutBox: Layout, LayoutTraversal {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    let layout: L
    
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        cast(layout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
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
