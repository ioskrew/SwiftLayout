public struct OptionalLayout<L: Layout>: Layout {
    
    private let layout: L?
    
    init(layout: L?) {
        self.layout = layout
    }
    
    public var sublayouts: [any Layout] {
        switch layout {
        case let .some(layout):
            return [layout]
        case .none:
            return []
        }
    }
}
