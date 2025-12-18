import SwiftLayoutPlatform

@MainActor
public struct LayoutComponent {
    var superview: SLView?
    var node: any HierarchyNodable
    var anchors: Anchors
    var option: LayoutOption

    var keyValueTuple: (String, any HierarchyNodable)? {
        guard let identifier = node.nodeIdentifier else {
            return nil
        }

        return (identifier, node)
    }
}
