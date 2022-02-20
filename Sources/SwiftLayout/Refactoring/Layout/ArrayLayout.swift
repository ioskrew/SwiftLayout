
import Foundation

public struct ArrayLayout<L: Layout>: Layout {
    let layouts: [L]
    
    public var debugDescription: String {
        "ArrayLayout<\(L.self)>"
    }
}
