
import Foundation
import UIKit

extension LayoutTree {
    
    public var debugDescription: String {
        var identifier = self.layoutIdentifier
        if !branches.isEmpty {
            identifier = identifier + " { \(branches.map(\.debugDescription).joined(separator: ", ")) } "
        }
        return identifier.trimmingCharacters(in: .whitespaces)
    }
    
}

struct LayoutableDebugDescriptionOptions: OptionSet {
    typealias RawValue = Int
    var rawValue: Int
    typealias Options = LayoutableDebugDescriptionOptions
    static let printType = Options(rawValue: 1)
    static let printUp = Options(rawValue: 1 << 1)
}
