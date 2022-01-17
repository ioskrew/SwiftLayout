
import Foundation
import UIKit

extension Builder {
    public struct Either<First: AutolayoutComponent, Second: AutolayoutComponent>: AutolayoutComponent {
        
        let content: AutolayoutComponent
        
    }
}
