
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
        
        func constraints() -> [NSLayoutConstraint] {
            content.prepare()
            
            to.addViews(content)
            
            return [
                to.bindLeadingToLeading(content),
                to.bindTrailingToTrailing(content),
                to.bindTopToTop(content),
                to.bindBottomToBottom(content),
            ].flatMap({ $0 })
        }
        
    }
}
