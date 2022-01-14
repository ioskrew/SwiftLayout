
import Foundation
import UIKit

public struct AutolayoutEither<First: AutolayoutComponent, Second: AutolayoutComponent>: AutolayoutComponent {
    
    let content: AutolayoutComponent
    
    public func view() -> UIView? {
        content.view()
    }
}
