import Foundation

public struct ConditionalLayout<True: Layout, False: Layout>: Layout {
    enum Layout {
        case trueLayout(True)
        case falseLayout(False)
    }
    let layout: Layout
    
    public var debugDescription: String {
        "ConditionalLayout<True: \(True.self), False: \(False.self)>"
    }
}
