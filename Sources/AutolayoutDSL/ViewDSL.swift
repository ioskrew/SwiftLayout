import Foundation
import UIKit

@resultBuilder
public struct ViewBuilder {
    
    public static func buildBlock(_ views: UIView...) -> ViewBuilding {
        Self.Components(views: views)
    }
    
    public static func buildArray(_ views: [UIView]) -> ViewBuilding {
        Self.Components(views: views)
    }
    
    public static func buildEither(first view: UIView) -> ViewBuilding {
        Self.Either(views: [view])
    }
    
    public static func buildEither(second view: UIView) -> ViewBuilding {
        Self.Either(views: [view])
    }
    
}

public extension UIView {
    
    @discardableResult
    func callAsFunction(@ViewBuilder _ content: () -> ViewBuilding) -> UIView {
        let building = content()
        building.views.forEach(self.addSubview)
        return self
    }
    
    var dsl: ViewDSL {
        .init(view: self)
    }
}

public struct ViewDSL: CustomDebugStringConvertible {
    let view: UIView
    
    var address: String {
        Unmanaged.passUnretained(view).toOpaque().debugDescription
    }
    
    var identity: String {
        view.accessibilityIdentifier ?? address
    }
    
    public var debugDescription: String {
        if view.subviews.isEmpty {
            return identity
        } else {
            return "\(identity): [\(view.subviews.map(\.dsl.debugDescription).joined(separator: ", "))]"
        }
    }
}
