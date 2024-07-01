public struct ArrayLayout<L: Layout>: Layout {

    private let layouts: [L]

    init(layouts: [L]) {
        self.layouts = layouts
    }

    public var sublayouts: [any Layout] {
        layouts
    }
}
