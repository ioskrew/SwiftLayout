
import Foundation
import UIKit

public struct AutolayoutComponents<C>: AutolayoutComponent where C: AutolayoutComponent {
    let components: [C]
    
    public init(_ components: [C]) {
        self.components = components
    }
    
    public func view() -> UIView? {
        components.first(where: { $0 is UIView }) as? UIView
    }
}
