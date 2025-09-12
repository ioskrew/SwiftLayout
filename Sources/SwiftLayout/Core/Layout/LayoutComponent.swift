import UIKit

@MainActor
public struct LayoutComponent {
    var superview: UIView?
    var node: any HierarchyNode
    var anchors: Anchors
    var option: LayoutOption

    var keyValueTuple: (String, any HierarchyNode)? {
        guard let identifier = node.nodeIdentifier else {
            return nil
        }

        return (identifier, node)
    }
}
