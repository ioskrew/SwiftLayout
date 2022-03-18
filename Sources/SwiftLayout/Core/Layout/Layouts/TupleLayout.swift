import Foundation
import UIKit

public struct TupleLayout<L>: Layout {
    
    let layout: L
    
    init(_ layout: L) {
        self.layout = layout
    }
    
    public var debugDescription: String {
        "TupleLayout<\(L.self)>"
    }
    
    public var sublayouts: [Layout] {
        Mirror(reflecting: layout).children.compactMap { (_, value) in
            value as? Layout
        }
    }
}
