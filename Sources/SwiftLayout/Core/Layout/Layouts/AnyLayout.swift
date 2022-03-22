private protocol AnyLayoutBox: Layout {}
private struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    
    let layout: L
    
    var sublayouts: [Layout] {
        [layout]
    }
}

public struct AnyLayout: Layout {
    
    private let box: AnyLayoutBox
    
    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }
    
    public var sublayouts: [Layout] {
        box.sublayouts
    }
}
