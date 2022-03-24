public struct GroupLayout<L: Layout>: Layout {
    
    private let layout: L
    
    public init(@LayoutBuilder _ handler: () -> L) {
        self.layout = handler()
    }
    
    public var sublayouts: [Layout] {
        [layout]
    }
}
