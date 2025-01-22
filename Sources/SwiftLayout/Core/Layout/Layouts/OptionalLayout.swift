import UIKit

public struct OptionalLayout<Sublayout: Layout>: Layout {
    var sublayout: Sublayout?

    init(sublayout: Sublayout?) {
        self.sublayout = sublayout
    }

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        return sublayout?.layoutComponents(superview: superview, option: option) ?? []
    }

    public func layoutWillActivate() {
        sublayout?.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout?.layoutDidActivate()
    }
}
