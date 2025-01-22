import UIKit

public struct TupleLayout<each Sublayout: Layout>: Layout {
    private let sublayouts: (repeat each Sublayout)

    init(layouts: (repeat each Sublayout)) {
        self.sublayouts = layouts
    }

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        var components: [LayoutComponent] = []
        for sublayout in repeat each sublayouts {
            components.append(contentsOf: sublayout.layoutComponents(superview: superview, option: option))
        }
        return components
    }

    public func layoutWillActivate() {
        for sublayout in repeat each sublayouts {
            sublayout.layoutWillActivate()
        }
    }

    public func layoutDidActivate() {
        for sublayout in repeat each sublayouts {
            sublayout.layoutDidActivate()
        }
    }
}
