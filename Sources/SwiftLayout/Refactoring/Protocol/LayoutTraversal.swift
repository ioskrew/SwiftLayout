import Foundation
import UIKit

typealias TraverseHandler = (_ superview: UIView?, _ subview: UIView, _ identifier: String?, _ animationDisabled: Bool) -> Void
typealias ConstraintHandler = (_ superview: UIView?, _ subview: UIView, _ constraints: [Constraint], _ viewInfoSet: ViewInformationSet) -> Void

protocol LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler)
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler)
}

extension Array where Element == LayoutTraversal {
    mutating func appendLayout<L: Layout>(_ l: L) {
        guard let traversal = l as? LayoutTraversal else { return }
        append(traversal)
    }
}

extension LayoutTraversal {
    var viewInformations: [ViewInformation] {
        var informations: [ViewInformation] = []
        traverse(nil, continueAfterViewLayout: true) { superview, subview, identifier, animationDisabled in
            informations.append(.init(superview: superview, view: subview, identifier: identifier, animationDisabled: animationDisabled))
        }
        return informations
    }
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] {
        var layoutConstraints: [NSLayoutConstraint] = []
        traverse(nil, viewInfoSet: viewInfoSet) { superview, subview, constraints, viewInfoSet in
            layoutConstraints.append(contentsOf: constraints.constraints(item: subview, toItem: superview, viewInfoSet: viewInfoSet))
        }
        return layoutConstraints
    }
    
    func cast<L: Layout>(_ layout: L) -> LayoutTraversal? {
        layout as? LayoutTraversal
    }
}

extension AnchorsLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        guard let traversal = cast(layout) else { return }
        traversal.traverse(superview, continueAfterViewLayout: false, traverseHandler: { superview, subview, identifier, animationDisabled in
            handler(superview, subview, anchors, viewInfoSet)
            traversal.traverse(subview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        })
    }
}

extension AnyLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        box.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        box.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}

extension ArrayLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        for layout in layouts {
            cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        for layout in layouts {
            cast(layout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}

extension ConditionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        switch layout {
        case let .trueLayout(layout):
            cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        case let .falseLayout(layout):
            cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        switch layout {
        case let .trueLayout(layout):
            cast(layout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        case let .falseLayout(layout):
            cast(layout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}

extension OptionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        switch layout {
        case let .some(layout):
            cast(layout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        case .none:
            break
        }
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        switch layout {
        case let .some(layout):
            cast(layout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        case .none:
            break
        }
    }
}

extension SublayoutLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        cast(superlayout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        cast(sublayout)?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        cast(superlayout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        cast(sublayout)?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}

extension TupleLayout: LayoutTraversal {
    
    var traversals: [LayoutTraversal] {
        Mirror(reflecting: layout).children.compactMap { (_, value) in
            value as? LayoutTraversal
        }
//        if let traversals = layout as? (LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//        } else if let traversals = layout as? (LayoutTraversal, LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, stopFirst: continueAfterViewLayout, stopFirst: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, stopFirst: continueAfterViewLayout, stopFirst: continueAfterViewLayout, traverseHandler: handler)
//            traversals.2.traverse(superview, stopFirst: continueAfterViewLayout, stopFirst: continueAfterViewLayout, traverseHandler: handler)
//        } else if let traversals = layout as? (LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.2.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.3.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//        } else if let traversals = layout as? (LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.2.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.3.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.4.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//        } else if let traversals = layout as? (LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.2.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.3.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.4.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.5.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//        } else if let traversals = layout as? (LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal, LayoutTraversal) {
//            traversals.0.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.1.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.2.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.3.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.4.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.5.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//            traversals.6.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
//        }
    }
    
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        for traversal in traversals {
            traversal.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        }
    }
    
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        for traversal in traversals {
            traversal.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}

extension ViewLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(superview, view, identifier, animationDisabled)
        guard continueAfterViewLayout else { return }
        cast(sublayout)?.traverse(view, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        cast(sublayout)?.traverse(view, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}

extension UIView: LayoutTraversal {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(superview, self, self.accessibilityIdentifier, false)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {}
}
