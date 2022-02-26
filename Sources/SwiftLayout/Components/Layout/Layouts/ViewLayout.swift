import Foundation
import UIKit

public final class ViewLayout<V: UIView, SubLayout: Layout>: Layout {
    
    let view: V
    
    var sublayout: SubLayout
    
    private(set) var animationDisabled: Bool = false
    
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    init(_ view: V, sublayout: SubLayout) {
        self.view = view
        self.sublayout = sublayout
        self.animationDisabled = false
    }
        
    public func animationDisable() -> Self {
        self.animationDisabled = true
        return self
    }
    
    public var debugDescription: String {
        view.tagDescription + ": [\(sublayout.debugDescription)]"
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> some Layout {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout<V, TupleLayout<(SubLayout, L)>>(view, sublayout: TupleLayout((self.sublayout, build())))
    }
    
    public func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        sublayout(build)
    }
}

public extension ViewLayout {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(superview, view, identifier, animationDisabled)
        guard continueAfterViewLayout else { return }
        sublayout.traverse(view, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        if sublayout is EmptyLayout {
            handler(superview, view, [], viewInfoSet)
        } else {
            sublayout.traverse(view, viewInfoSet: viewInfoSet, constraintHndler: handler)
        }
    }
}
