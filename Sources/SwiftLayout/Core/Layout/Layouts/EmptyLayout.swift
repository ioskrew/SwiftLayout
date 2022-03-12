import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct EmptyLayout: Layout {
    
    public var debugDescription: String {
        "EmptyLayout"
    }
    
    public var sublayouts: [Layout] {
        []
    }
}
