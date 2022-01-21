import Foundation
import UIKit

@resultBuilder
public struct LayoutBuilder {
    
    public static func buildBlock(_ branches: LayoutTree...) -> LayoutTree {
        buildArray(branches)
    }
    
    public static func buildArray(_ branches: [LayoutTree]) -> LayoutTree {
       _LayoutFork(branches)
    }
    
}
