import UIKit

@MainActor
public struct LayoutComponent {
    var superview: UIView?
    var view: UIView
    var anchors: Anchors
    var option: LayoutOption

    var keyValueTuple: (String, UIView)? {
        guard let identifier = view.accessibilityIdentifier else {
            return nil
        }

        return (identifier, view)
    }
}
