import SwiftLayoutPlatform

public struct AnyLayout: Layout {
    public init<Sublayout: Layout>(_ sublayout: Sublayout) {
        self.sublayout = sublayout
    }

    private var sublayout: any Layout

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        sublayout.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        sublayout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout.layoutDidActivate()
    }
}
