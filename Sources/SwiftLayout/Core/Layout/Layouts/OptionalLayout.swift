import Foundation
import UIKit

public struct OptionalLayout<L: Layout>: Layout {
    
    let layout: L?
    
    public var debugDescription: String {
        "OptionalLayout<\(L.self)>"
    }
    
    public var sublayouts: [Layout] {
        switch layout {
        case let .some(layout):
            return [layout]
        case .none:
            return []
        }
    }
}
