import Foundation
import UIKit

@resultBuilder
public struct AutolayoutBuilder {
    
    public static func buildBlock<C>(_ components: C...) -> Builder.Components<C> where C: AutolayoutComponent {
        return Builder.Components(components)
    }
    
    public static func buildArray<C>(_ components: [C]) -> Builder.Components<C> where C: AutolayoutComponent {
        return Builder.Components(components)
    }
    
    public static func buildEither<F, S>(first component: F) -> Builder.Either<F, S> {
        return Builder.Either<F, S>(content: component)
    }
    
    public static func buildEither<F, S>(second component: S) -> Builder.Either<F, S> {
        return Builder.Either<F, S>(content: component)
    }
    
}
