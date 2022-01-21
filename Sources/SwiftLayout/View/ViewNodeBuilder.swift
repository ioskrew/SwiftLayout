import Foundation
import UIKit

@resultBuilder
public struct ViewNodeBuilder {
    
    public static func buildBlock(_ nodes: ViewNodable...) -> ViewNode {
        _ViewNode(child: .children(nodes.map(\.node)))
    }
    
    public static func buildArray(_ nodes: [ViewNodable]) -> ViewNode {
        _ViewNode(child: .children(nodes.map(\.node)))
    }
    
}
