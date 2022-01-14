
import Foundation
import UIKit

public protocol AutolayoutComponent {
    func constraints() -> [NSLayoutConstraint]
    func active()

    func view() -> UIView?
    func prepare()
}

extension AutolayoutComponent {
    public func constraints() -> [NSLayoutConstraint] { [] }
    
    public func active() {
        NSLayoutConstraint.activate(constraints())
    }
    
    public func view() -> UIView? {
        self as? UIView
    }
    
    public func prepare() {
        view()?.translatesAutoresizingMaskIntoConstraints = false
    }
}
