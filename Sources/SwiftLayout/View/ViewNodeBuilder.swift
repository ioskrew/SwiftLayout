import Foundation
import UIKit

@resultBuilder
public struct ViewNodeBuilder {
    
    public static func buildBlock(_ nodes: ViewNodable...) -> ViewNode {
        ViewChildren(children: nodes.map(\.node))
    }
    
    public static func buildArray(_ nodes: [ViewNodable]) -> ViewNode {
        ViewChildren(children: nodes.map(\.node))
    }
    
    public static func buildArray(_ views: [UIView]) -> ViewNode {
        ViewChildren(children: views.map(ViewChild.init))
    }
    
}
