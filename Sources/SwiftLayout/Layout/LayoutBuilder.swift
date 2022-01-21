import Foundation
import UIKit

@resultBuilder
public struct LayoutBuilder {
    
    public static func buildBlock(_ branches: Layoutable...) -> Layoutable {
        buildArray(branches)
    }
    
    public static func buildArray(_ branches: [Layoutable]) -> Layoutable {
        LayoutTree(branches: branches)
    }
    
}
