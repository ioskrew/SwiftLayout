import Foundation
import UIKit

public struct OptionalLayout<L: Layout>: Layout {
    let layout: L?
    
    public var debugDescription: String {
        "OptionalLayout<\(L.self)>"
    }
}

public extension OptionalLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        switch layout {
        case let .some(layout):
            layout.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
        case .none:
            break
        }
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        switch layout {
        case let .some(layout):
            layout.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
        case .none:
            break
        }
    }
}
