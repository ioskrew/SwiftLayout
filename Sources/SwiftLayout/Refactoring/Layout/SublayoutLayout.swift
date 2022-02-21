import Foundation
import UIKit

public struct SublayoutLayout<Super: Layout, Sub: Layout>: Layout {
    internal init(_ superlayout: Super, _ sublayout: Sub) {
        self.superlayout = superlayout
        self.sublayout = sublayout
    }
    
    let superlayout: Super
    let sublayout: Sub
    
    public var debugDescription: String {
        "SublayoutLayout<\(Super.self), Sub: \(Sub.self)>"
    }
}
