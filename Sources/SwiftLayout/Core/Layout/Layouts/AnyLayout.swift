import UIKit

public struct AnyLayout: Layout {
    public init<Sublayout: Layout>(_ sublayout: Sublayout) {
        self.sublayout = sublayout
    }

    var sublayout: any Layout

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        sublayout.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        sublayout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout.layoutDidActivate()
    }
}
