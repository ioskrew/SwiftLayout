import SwiftLayoutPlatform

public struct EmptyLayout: Layout {
    init() {
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        return []
    }

    public func layoutWillActivate() {
    }

    public func layoutDidActivate() {
    }
}
