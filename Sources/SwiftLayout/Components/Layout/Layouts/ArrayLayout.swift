import Foundation
import UIKit

public struct ArrayLayout<L: Layout>: Layout {
    
    let layouts: [L]
    
    public var debugDescription: String {
        "ArrayLayout<\(L.self)>"
    }
    
    public var sublayouts: [Layout] {
        layouts
    }
}
