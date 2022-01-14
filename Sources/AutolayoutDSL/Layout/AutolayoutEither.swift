
import Foundation

public struct AutolayoutEither<First: AutolayoutComponent, Second: AutolayoutComponent>: AutolayoutComponent {
    
    let content: AutolayoutComponent
    
}
