import Foundation
import UIKit

protocol LayoutTraversal {
    var viewInformations: [ViewInformation] { get }
    var viewConstraints: [NSLayoutConstraint] { get }
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint]
}

extension LayoutTraversal {
    var viewInformations: [ViewInformation] { [] }
    var viewConstraints: [NSLayoutConstraint] { [] }
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] { [] }
}

extension LayoutTraversal {
//    func traversal(superLayout: LayoutImp? = nil, handler: (_ superLayout: LayoutImp?, _ currentLayout: LayoutImp) -> Void) {
//        handler(superLayout, self)
//        layouts.forEach { $0.traversal(superLayout: self, handler: handler) }
//    }
//
//    var viewInformations: [ViewInformation] {
//        var result: [ViewInformation] = []
//
//        traversal { superLayout, currentLayout in
//            result.append(
//                ViewInformation(
//                    superview: superLayout?.view,
//                    view: currentLayout.view,
//                    identifier: currentLayout.identifier,
//                    animationDisabled: currentLayout.animationDisabled
//                )
//            )
//        }
//
//        return result
//    }
//
//    func viewConstraints(_ identifiers: ViewInformationSet? = nil) -> [NSLayoutConstraint] {
//        var result: [NSLayoutConstraint] = []
//
//        traversal { superLayout, currentLayout in
//            result.append(contentsOf: currentLayout.anchors.flatMap {
//                $0.constraints(item: currentLayout.view, toItem: superLayout?.view, identifiers: identifiers)
//            })
//        }
//
//        return result
//    }

}

extension ViewLayout: LayoutTraversal {}
extension TupleLayout: LayoutTraversal {}
extension OptionalLayout: LayoutTraversal {}
extension ArrayLayout: LayoutTraversal {}
extension ConditionalLayout: LayoutTraversal {}
extension AnyLayout: LayoutTraversal {}
extension AnchorLayout: LayoutTraversal {}
