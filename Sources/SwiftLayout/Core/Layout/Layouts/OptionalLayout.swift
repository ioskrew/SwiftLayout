import SwiftLayoutPlatform

public struct OptionalLayout<Sublayout: Layout>: Layout {
    private var sublayout: Sublayout?

    init(sublayout: Sublayout?) {
        self.sublayout = sublayout
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        return sublayout?.layoutComponents(superview: superview, option: option) ?? []
    }

    public func layoutWillActivate() {
        sublayout?.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout?.layoutDidActivate()
    }
}
