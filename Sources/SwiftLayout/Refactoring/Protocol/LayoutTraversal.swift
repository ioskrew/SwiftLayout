import Foundation
import UIKit

typealias TraverseHandler = (_ superview: UIView?, _ subview: UIView) -> Void

protocol LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler)
}

extension Array where Element == LayoutTraversal {
    mutating func appendLayout<L: Layout>(_ l: L) {
        guard let traversal = l as? LayoutTraversal else { return }
        append(traversal)
    }
}

extension LayoutTraversal {
    var viewInformations: [ViewInformation] { [] }
    var viewConstraints: [NSLayoutConstraint] { [] }
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] { [] }
    
    func cast<L: Layout>(_ layout: L, _ handler: (LayoutTraversal) -> Void) -> Void {
        guard let traversal = layout as? LayoutTraversal else { return }
        handler(traversal)
    }
}

extension LayoutTraversal where Self: UIView {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        handler(superview, self)
    }
}

extension AnchorLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        cast(layout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
    }
}

extension AnyLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        box.traverse(superview, traverseHandler: handler)
    }
}

extension ArrayLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        for layout in layouts {
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension ConditionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        switch layout {
        case let .trueLayout(layout):
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        case let .falseLayout(layout):
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension OptionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        layout.flatMap { layout in
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension SublayoutLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        cast(superlayout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
        cast(sublayout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
    }
}

extension TupleLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        
    }
}

extension ViewLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        handler(superview, view)
        cast(sublayout) { traversal in
            traversal.traverse(view, traverseHandler: handler)
        }
    }
}

extension UIView: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: (UIView?, UIView) -> Void) {
        handler(superview, self)
    }
}
