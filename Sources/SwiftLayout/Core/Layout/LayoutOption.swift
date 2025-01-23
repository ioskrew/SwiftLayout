import Foundation

public struct LayoutOption: OptionSet, Sendable {
    public var rawValue: Int

    public static let none = LayoutOption([])
    public static let isNotArranged = LayoutOption(rawValue: 1 << 0)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
