public struct ArrayLayout<L: Layout>: Layout {
    
    let layouts: [L]
    
    public var sublayouts: [Layout] {
        layouts
    }
}
