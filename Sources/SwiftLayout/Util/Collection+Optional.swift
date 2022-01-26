
import Foundation

protocol OptionalImpl {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalImpl {
    var wrapped: Wrapped? {
        self
    }
}

extension Collection where Element: OptionalImpl {
    var flatten: [Element.Wrapped] { compactMap(\.wrapped) }
}
