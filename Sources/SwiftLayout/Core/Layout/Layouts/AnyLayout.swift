private protocol AnyLayoutBox: Layout {}
private struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {

    let layout: L

    var sublayouts: [any Layout] {
        [layout]
    }
}

public struct AnyLayout: Layout {

    private let box: AnyLayoutBox

    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }

    public var sublayouts: [any Layout] {
        box.sublayouts
    }
}
