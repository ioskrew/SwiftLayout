import SwiftLayoutPlatform

public struct GroupLayout<Sublayout: Layout>: Layout {
    private let sublayout: Sublayout
    private let option: LayoutOption

    public init(option: LayoutOption = .none, @LayoutBuilder _ handler: () -> Sublayout) {
        self.option = option
        self.sublayout = handler()
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        return sublayout.layoutComponents(superview: superview, option: self.option)
    }

    public func layoutWillActivate() {
        sublayout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout.layoutDidActivate()
    }
}
