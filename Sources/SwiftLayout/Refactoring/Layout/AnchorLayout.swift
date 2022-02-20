import Foundation

public struct AnchorLayout<L: Layout>: Layout {
    internal init(_ layout: L, _ anchors: [Constraint]) {
        self.layout = layout
        self.anchors = anchors
    }
    
    let layout: L
    let anchors: [Constraint]
    
    public var debugDescription: String {
        "AnchorLayout<\(L.self)>"
    }
}
