protocol AnyLayoutBox: Layout {}
struct _AnyLayoutBox<L: Layout>: AnyLayoutBox {
    
    let layout: L
    
    var debugDescription: String {
        "_AnyLayoutBox<\(L.self)>"
    }
    
    var sublayouts: [Layout] {
        [layout]
    }
}

public struct AnyLayout: Layout {
    
    let box: AnyLayoutBox
    
    init<L: Layout>(_ layout: L) {
        self.box = _AnyLayoutBox(layout: layout)
    }
    
    public var debugDescription: String {
        "AnyLayout:\(box)"
    }
    
    public var sublayouts: [Layout] {
        box.sublayouts
    }
}
