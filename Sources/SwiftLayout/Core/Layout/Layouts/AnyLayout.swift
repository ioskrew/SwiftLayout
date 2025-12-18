import SwiftLayoutPlatform

/// A type-erased wrapper for any Layout type.
///
/// Use `AnyLayout` when you need to store or return layouts of different concrete types:
///
/// ```swift
/// func makeLayout(for style: Style) -> AnyLayout {
///     switch style {
///     case .compact:
///         return compactView.sl.anchors { ... }.eraseToAnyLayout()
///     case .expanded:
///         return expandedView.sl.anchors { ... }.eraseToAnyLayout()
///     }
/// }
/// ```
///
/// You can also use the ``Layout/eraseToAnyLayout()`` method on any layout.
public struct AnyLayout: Layout {
    /// Creates a type-erased layout from the given layout.
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
