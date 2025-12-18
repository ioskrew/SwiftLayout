import SwiftLayoutPlatform

/// A protocol for creating reusable, self-contained layout modules.
///
/// `ModularLayout` allows you to define layout components that can be composed
/// and reused across your application, similar to how SwiftUI views work.
///
/// ## Overview
///
/// Use `ModularLayout` to encapsulate complex layout logic into reusable components:
///
/// ```swift
/// struct HeaderLayout: ModularLayout {
///     let titleLabel: UILabel
///     let subtitleLabel: UILabel
///
///     var layout: some Layout {
///         titleLabel.sl.anchors {
///             Anchors.top.leading.trailing.equalToSuper()
///         }
///         subtitleLabel.sl.anchors {
///             Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 8)
///             Anchors.leading.trailing.equalToSuper()
///         }
///     }
/// }
///
/// // Usage in a Layoutable view
/// class MyView: SLView, Layoutable {
///     var activation: Activation?
///     let header = HeaderLayout(titleLabel: ..., subtitleLabel: ...)
///
///     var layout: some Layout {
///         self.sl.sublayout {
///             header
///         }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Required Properties
/// - ``layout``
@MainActor
public protocol ModularLayout: Layout {
    associatedtype LayoutBody: Layout

    /// The declarative layout definition for this module.
    @LayoutBuilder var layout: LayoutBody { get }
}

extension ModularLayout {
    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        return layout.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        layout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        layout.layoutDidActivate()
    }
}
