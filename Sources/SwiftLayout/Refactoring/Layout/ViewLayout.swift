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
}
