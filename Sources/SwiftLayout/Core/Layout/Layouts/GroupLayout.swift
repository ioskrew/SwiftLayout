import SwiftLayoutPlatform

/// A layout that groups child layouts with shared layout options.
///
/// Use `GroupLayout` to apply options like `isNotArranged` to multiple views at once,
/// particularly useful with stack views:
///
/// ```swift
/// stackView.sl.sublayout {
///     // These views are added as arranged subviews
///     label1
///     label2
///
///     // This view is added as a regular subview, not arranged
///     GroupLayout(option: .isNotArranged) {
///         backgroundView.sl.anchors {
///             Anchors.allSides.equalToSuper()
///         }
///     }
/// }
/// ```
public struct GroupLayout<Sublayout: Layout>: Layout {
    private let sublayout: Sublayout
    private let option: LayoutOption

    /// Creates a group layout with the specified options.
    ///
    /// - Parameters:
    ///   - option: Layout options to apply to all sublayouts.
    ///   - handler: A builder closure that creates the sublayouts.
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
