import UIKit

public struct ArrayLayout<Sublayout: Layout>: Layout {
    var sublayouts: [Sublayout]

    init(sublayouts: [Sublayout]) {
        self.sublayouts = sublayouts
    }

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        return sublayouts.flatMap { $0.layoutComponents(superview: superview, option: option) }
    }

    public func layoutWillActivate() {
        sublayouts.forEach { $0.layoutWillActivate() }
    }

    public func layoutDidActivate() {
        sublayouts.forEach { $0.layoutDidActivate() }
    }
}
