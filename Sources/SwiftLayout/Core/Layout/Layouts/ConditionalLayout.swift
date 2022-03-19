public struct ConditionalLayout<True: Layout, False: Layout>: Layout {
    
    enum _ConditionalLayout {
        case trueLayout(True)
        case falseLayout(False)
    }
    
    let layout: _ConditionalLayout
    
    public var sublayouts: [Layout] {
        switch layout {
        case .trueLayout(let layout):
            return [layout]
        case .falseLayout(let layout):
            return [layout]
        }
    }
}
