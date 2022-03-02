import Foundation
import UIKit

public final class ViewLayout<V: UIView, SubLayout: Layout>: Layout {
    
    let view: V
    
    var sublayout: SubLayout
    
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    var animationHandler: ViewInformation.AnimationHandler?
    
    init(_ view: V, sublayout: SubLayout) {
        self.view = view
        self.sublayout = sublayout
    }
        
    @available(*, deprecated, message: "do nothing")
    public func animationDisable() -> Self {
        return self
    }
    
    public func setAnimationHandler(_ handler: @escaping (UIView) -> Void) -> Self {
        self.animationHandler = .init(view, handler: handler)
        return self
    }
    
    public var debugDescription: String {
        view.tagDescription + ": [\(sublayout.debugDescription)]"
    }
}

public extension ViewLayout {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        let continuation = handler(.init(superview: superview, view: view, animationHandler: animationHandler))
        guard continuation else { return }
        sublayout.traverse(view, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        sublayout.traverse(view, constraintHndler: handler)
    }
}
