
import Foundation
import UIKit

extension AutolayoutComponent where Self: UIView {
    
    public func view() -> UIView? {
        self
    }
    
}

extension UIView: AutolayoutComponent {
    
    public func fill<C: AutolayoutComponent>(@AutolayoutBuilder content: () -> C) -> some AutolayoutComponent {
        FillUp(to: self, content: content)
    }
    
}
