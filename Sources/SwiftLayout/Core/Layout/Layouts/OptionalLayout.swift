public struct OptionalLayout<L: Layout>: Layout {
    
    let layout: L?
    
    public var sublayouts: [Layout] {
        switch layout {
        case let .some(layout):
            return [layout]
        case .none:
            return []
        }
    }
}
