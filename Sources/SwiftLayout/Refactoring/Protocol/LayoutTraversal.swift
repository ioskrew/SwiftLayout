import Foundation
import UIKit

typealias ViewTraverseHandler = (_ superview: UIView?, _ subview: UIView) -> Void
typealias ConstraintTraversehandler = (_ constraints: [NSLayoutConstraint]) -> Void

protocol LayoutTraversal {
    var traversals: [LayoutTraversal] { get }
    func traverse(_ superview: UIView?, viewTraverseHandler handler: ViewTraverseHandler)
    func traverse(constraintTraverseHandler handler: ConstraintTraversehandler)
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
    
    fileprivate func cast<L: Layout>(_ layout: L, _ handler: (LayoutTraversal) -> Void) -> Void {
        guard let traversal = layout as? LayoutTraversal else { return }
        handler(traversal)
    }
}

extension LayoutTraversal where Self: UIView {
    func traverse(_ superview: UIView?, viewTraverseHandler handler: ViewTraverseHandler) {
        handler(superview, self)
    }
    func traverse(constraintTraverseHandler handler: ConstraintTraversehandler) {}
}

extension AnchorLayout: LayoutTraversal {
    
    func traverse(_ superview: UIView?, viewTraverseHandler handler: (UIView?, UIView) -> Void) {
        cast(layout) { traversal in
            traversal.traverse(superview, viewTraverseHandler: handler)
        }
    }
    
    func traverse(constraintTraverseHandler handler: ([NSLayoutConstraint]) -> Void) {
        handler(anchors.constraints(item: <#T##NSObject#>, toItem: <#T##NSObject?#>, identifiers: <#T##ViewInformationSet?#>))
    }
    
}

extension ArrayLayout: LayoutTraversal {
    var traversals: [LayoutTraversal] {
        self.layouts.compactMap({ $0 as? LayoutTraversal })
    }
}

extension ConditionalLayout: LayoutTraversal {
    var traversals: [LayoutTraversal] {
        var traversals: [LayoutTraversal] = []
        switch layout {
        case let .trueLayout(layout):
            traversals.appendLayout(layout)
        case let .falseLayout(layout):
            traversals.appendLayout(layout)
        }
        return traversals
    }
}

extension OptionalLayout: LayoutTraversal {
    var traversals: [LayoutTraversal] {
        guard let traversal = self.layout as? LayoutTraversal else { return [] }
        return [traversal]
    }
}

extension SublayoutLayout: LayoutTraversal {
    var traversals: [LayoutTraversal] {
        var traversals: [LayoutTraversal] = []
        traversals.appendLayout(superlayout)
        traversals.appendLayout(sublayout)
        return traversals
    }
}

extension TupleLayout: LayoutTraversal {}

extension ViewLayout: LayoutTraversal {
    var traversals: [LayoutTraversal] {
        var traversals: [LayoutTraversal] = []
        traversals.appendLayout(view)
        traversals.appendLayout(sublayout)
        return traversals
    }
}

extension UIView: LayoutTraversal {}
