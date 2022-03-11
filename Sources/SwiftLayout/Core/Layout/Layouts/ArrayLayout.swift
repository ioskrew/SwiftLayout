import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct ArrayLayout<L: Layout>: Layout {
    
    let layouts: [L]
    
    public var debugDescription: String {
        "ArrayLayout<\(L.self)>"
    }
    
    public var sublayouts: [Layout] {
        layouts
    }
}
