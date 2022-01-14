import Foundation
import UIKit

@resultBuilder
public struct AutolayoutBuilder {
    
    public static func buildBlock<C>(_ components: C...) -> AutolayoutComponents<C> where C: AutolayoutComponent {
        return AutolayoutComponents(components)
    }
    
    public static func buildArray<C>(_ components: [C]) -> AutolayoutComponents<C> where C: AutolayoutComponent {
        return AutolayoutComponents(components)
    }
    
    public static func buildEither<F, S>(first component: F) -> AutolayoutEither<F, S> {
        print("First \(component)")
        return AutolayoutEither<F, S>(content: component)
    }
    
    public static func buildEither<F, S>(second component: S) -> AutolayoutEither<F, S> {
        print("Second \(component)")
        return AutolayoutEither<F, S>(content: component)
    }
    
}
