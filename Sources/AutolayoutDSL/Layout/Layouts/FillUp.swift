
import Foundation
import UIKit

extension Layout {
    struct FillUp<To, Content>: AutolayoutComponent where To: AutolayoutComponent, Content: AutolayoutComponent {
        
        let to: To
        let content: Content
        
        init(to: To, @AutolayoutBuilder content: () -> Content) {
            self.to = to
            self.content = content()
        }
        
    }
}
