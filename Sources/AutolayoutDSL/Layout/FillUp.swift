
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
            guard let parent = to.view() else { return [] }
            guard let child = content.view() else { return [] }
            
            parent.addSubview(child)
            return [
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                child.topAnchor.constraint(equalTo: parent.topAnchor),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            ]
        }
        
    }
}
