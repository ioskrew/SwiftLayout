@MainActor
public protocol ModularLayout: Layout {
    associatedtype LayoutBody: Layout

    @LayoutBuilder var layout: LayoutBody { get }
}

extension ModularLayout {
    public var sublayouts: [any Layout] {
        [self.layout]
    }
}
