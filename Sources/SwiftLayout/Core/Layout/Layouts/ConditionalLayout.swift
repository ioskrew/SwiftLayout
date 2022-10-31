public struct ConditionalLayout<True: Layout, False: Layout>: Layout {
    
    enum _ConditionalLayout {
        case trueLayout(True)
        case falseLayout(False)
    }
    
    private let layout: _ConditionalLayout
    
    init(layout: _ConditionalLayout) {
        self.layout = layout
    }
    
    public var sublayouts: [any Layout] {
        switch layout {
        case .trueLayout(let layout):
            return [layout]
        case .falseLayout(let layout):
            return [layout]
        }
    }
}
