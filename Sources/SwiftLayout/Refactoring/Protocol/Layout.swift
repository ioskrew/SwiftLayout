import Foundation
import UIKit

public protocol Layout {}

public protocol Deactivable {}

struct Deactivation<L: Layout>: Deactivable {
    let layout: L
}

extension Layout where Self: UIView {
    public func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, L> {
        ViewLayout(self, sublayout: build())
    }
}

extension UIView: Layout {}
