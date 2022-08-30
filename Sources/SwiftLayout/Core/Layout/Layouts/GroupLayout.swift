public struct GroupLayout<L: Layout>: Layout {
    
    private let layout: L

    public let option: LayoutOption?
    
    public init(option: LayoutOption = .none, @LayoutBuilder _ handler: () -> L) {
        self.option = option
        self.layout = handler()
    }
    
    public var sublayouts: [Layout] {
        [layout]
    }
}
