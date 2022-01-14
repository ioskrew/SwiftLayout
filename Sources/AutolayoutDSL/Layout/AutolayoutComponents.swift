
import Foundation
import UIKit

public struct AutolayoutComponents<C>: AutolayoutComponent where C: AutolayoutComponent {
    let components: [C]
    
    public init(_ components: [C]) {
        self.components = components
    }
    
    public func view() -> UIView? {
        components.compactMap({ $0.view() }).first
    }
}
