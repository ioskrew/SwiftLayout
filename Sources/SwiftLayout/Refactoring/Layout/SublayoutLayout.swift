import Foundation
import UIKit

public struct SublayoutLayout<V: UIView, Super: Layout, Sub: Layout>: Layout {
    internal init(_ superlayout: ViewLayout<V, Super>, _ sublayout: Sub) {
        self.superlayout = superlayout
        self.sublayout = sublayout
    }
    
    let superlayout: ViewLayout<V, Super>
    let sublayout: Sub
    
    public var debugDescription: String {
        "SublayoutLayout<ViewLayout<\(V.self), \(Super.self)>, Sub: \(Sub.self)>"
    }
}
