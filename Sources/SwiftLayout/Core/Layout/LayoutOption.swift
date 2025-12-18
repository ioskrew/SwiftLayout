import Foundation

/// Options that affect how views are added to the hierarchy.
///
/// Use these options with ``GroupLayout`` to control view addition behavior.
///
/// ## Stack View Integration
///
/// When adding views to a `UIStackView` / `NSStackView`, views are normally added as
/// arranged subviews. Use ``isNotArranged`` to add a view as a regular subview instead:
///
/// ```swift
/// stackView.sl.sublayout {
///     arrangedView1  // Added as arranged subview
///     arrangedView2  // Added as arranged subview
///
///     GroupLayout(option: .isNotArranged) {
///         backgroundView.sl.anchors {
///             Anchors.allSides.equalToSuper()
///         }
///     }
/// }
/// ```
public struct LayoutOption: OptionSet, Sendable {
    public var rawValue: Int

    /// No special options applied.
    public static let none = LayoutOption([])

    /// Adds the view as a regular subview instead of an arranged subview in stack views.
    ///
    /// Use this option when you want to add overlay views or backgrounds to a stack view
    /// that should not participate in the stack's arrangement.
    public static let isNotArranged = LayoutOption(rawValue: 1 << 0)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
