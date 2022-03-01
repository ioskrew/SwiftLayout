import Foundation
import UIKit

public struct OptionalLayout<L: Layout>: Layout {
    let layout: L?
    
    public var debugDescription: String {
        "OptionalLayout<\(L.self)>"
    }
}

public extension OptionalLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        switch layout {
        case let .some(layout):
            layout.traverse(superview, traverseHandler: handler)
        case .none:
            break
        }
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        switch layout {
        case let .some(layout):
            layout.traverse(superview, constraintHndler: handler)
        case .none:
            break
        }
    }
}
