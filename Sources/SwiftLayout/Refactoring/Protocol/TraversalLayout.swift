import Foundation
import UIKit

protocol TraversalLayout {
    func traverse(_ superview: UIView?, views: inout Set<ViewRelation>)
}

extension ViewLayout: TraversalLayout {
    func traverse(_ superview: UIView?, views: inout Set<ViewRelation>) {
        views.insert(.init(superview: superview, subview: view))
        for la
    }
}
extension OneLayout: TraversalLayout {}
extension TwoLayout: TraversalLayout {}
extension ThreeLayout: TraversalLayout {}
extension FourLayout: TraversalLayout {}
extension FiveLayout: TraversalLayout {}
extension SixLayout: TraversalLayout {}
extension SevenLayout: TraversalLayout {}
extension OptionalLayout: TraversalLayout {}
extension ArrayLayout: TraversalLayout {}
extension ConditionalLayout: TraversalLayout {}
extension AnyLayout: TraversalLayout {}
extension AnchorLayout: TraversalLayout {}
