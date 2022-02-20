import Foundation

public struct OptionalLayout<L: Layout>: Layout {
    let layout: L?
    
    public var debugDescription: String {
        "OptionalLayout<\(L.self)>"
    }
}
