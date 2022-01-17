
import Foundation
import UIKit

extension AutolayoutComponent where Self: UIView {
    
}

extension UIView: AutolayoutComponent {
    
    public func fill<C: AutolayoutComponent>(@AutolayoutBuilder content: () -> C) -> some AutolayoutComponent {
        Layout.FillUp(to: self, content: content)
    }
    
}
