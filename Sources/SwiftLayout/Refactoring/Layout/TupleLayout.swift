import Foundation

public struct TupleLayout<L>: Layout {
    internal init(_ layout: L) {
        self.layout = layout
    }
    
    let layout: L
    
    public var debugDescription: String {
        "TupleLayout<\(L.self)>"
    }
}
