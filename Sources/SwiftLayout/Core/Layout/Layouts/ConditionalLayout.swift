import UIKit

public struct ConditionalLayout<TrueLayout: Layout, FalseLayout: Layout>: Layout {
    enum Sublayout {
        case trueLayout(TrueLayout)
        case falseLayout(FalseLayout)
    }

    private var sublayout: Sublayout

    init(layout: Sublayout) {
        self.sublayout = layout
    }

    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        switch sublayout {
        case .trueLayout(let trueLayout):
            return trueLayout.layoutComponents(superview: superview, option: option)
        case .falseLayout(let falseLayout):
            return falseLayout.layoutComponents(superview: superview, option: option)
        }
    }

    public func layoutWillActivate() {
        switch sublayout {
        case .trueLayout(let trueLayout):
            trueLayout.layoutWillActivate()
        case .falseLayout(let falseLayout):
            falseLayout.layoutWillActivate()
        }
    }

    public func layoutDidActivate() {
        switch sublayout {
        case .trueLayout(let trueLayout):
            trueLayout.layoutDidActivate()
        case .falseLayout(let falseLayout):
            falseLayout.layoutDidActivate()
        }
    }
}
