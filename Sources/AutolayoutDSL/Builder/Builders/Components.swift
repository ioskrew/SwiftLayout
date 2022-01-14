
import Foundation
import UIKit

extension Builder {
    public struct Components: AutolayoutComponent {
        let components: [AutolayoutComponent]
        
        public init(_ components: [AutolayoutComponent]) {
            self.components = components
        }
        
        public func views() -> [UIView] {
            components.flatMap({ $0.views() })
        }
    }
}
