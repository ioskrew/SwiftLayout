import Foundation
import UIKit

public struct AnchorsLayout<V: UIView, L: Layout>: Layout {
    
    let layout: ViewLayout<V, L>
    let anchors: [Constraint]
    
    public var debugDescription: String {
        "AnchorsLayout<\(V.self), \(L.self)>"
    }
}
