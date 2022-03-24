public struct TupleLayout<L>: Layout {
    
    private let layout: L
    
    init(_ layout: L) {
        self.layout = layout
    }
    
    public var sublayouts: [Layout] {
        Mirror(reflecting: layout).children.compactMap { (_, value) in
            value as? Layout
        }
    }
}
