import Foundation
import UIKit

public struct ViewLayout<V: UIView, L: Layout>: Layout {
    
    let view: V
    
    let sublayout: L
    
    var animationDisabled: Bool = false
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    init(_ view: V, sublayout: L) {
        self.view = view
        self.sublayout = sublayout
    }
    
    var debugDescription: String {
        ""
    }
}
