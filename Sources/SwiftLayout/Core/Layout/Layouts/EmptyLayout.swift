import UIKit

public struct EmptyLayout: Layout {
    init() {
    }

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        return []
    }

    public func layoutWillActivate() {
    }

    public func layoutDidActivate() {
    }
}
