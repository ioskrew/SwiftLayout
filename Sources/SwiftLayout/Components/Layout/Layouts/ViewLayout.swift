import Foundation
import UIKit

public struct ViewLayout<V: UIView, SubLayout: Layout>: Layout {
    
    let view: V
    
    var sublayout: SubLayout
    
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    init(_ view: V, sublayout: SubLayout) {
        self.view = view
        self.sublayout = sublayout
    }
    
    public var debugDescription: String {
        view.tagDescription + ": [\(sublayout.debugDescription)]"
    }
}

public extension ViewLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        let continuation = handler(.init(superview: superview, view: view))
        guard continuation else { return }
        sublayout.traverse(view, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        sublayout.traverse(view, constraintHndler: handler)
    }
}
