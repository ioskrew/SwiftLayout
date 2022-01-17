import Foundation
import UIKit

@resultBuilder
public struct ViewBuilder {
    
    public static func buildBlock(_ containers: ViewDSL...) -> ViewBuilding {
        Self.Components(containers)
    }
    
    public static func buildArray(_ container: [ViewDSL]) -> ViewBuilding {
        Self.Components(container)
    }
    
    public static func buildEither(first container: ViewDSL) -> ViewBuilding {
        Self.Either(container)
    }
    
    public static func buildEither(second container: ViewDSL) -> ViewBuilding {
        Self.Either(container)
    }
    
    public static func buildBlock(_ views: UIView...) -> ViewBuilding {
        Self.Components(views)
    }
    
    public static func buildArray(_ views: [UIView]) -> ViewBuilding {
        Self.Components(views)
    }
    
    public static func buildEither(first view: UIView) -> ViewBuilding {
        Self.Either(view)
    }
    
    public static func buildEither(second view: UIView) -> ViewBuilding {
        Self.Either(view)
    }
}

public protocol ViewDSL: CustomDebugStringConvertible {
    var view: UIView { get }
    
    func tag(_ tag: String) -> Self
    func tag(_ tag: String, @ViewBuilder content: () -> ViewBuilding) -> Self
    
    func callAsFunction(@ViewBuilder _ content: () -> ViewBuilding) -> ViewDSL
}
