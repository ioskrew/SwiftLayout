
import Foundation
import UIKit

extension LayoutTree {
    public var debugDescription: String {
        if branches.isEmpty {
            return layoutIdentifier
        } else {
            return layoutIdentifier + ": \(branches.debugDescription)"
        }
    }
}
