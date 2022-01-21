
import Foundation
import UIKit

extension LayoutTree {
    
    public var debugDescription: String {
        self.debugDescriptionWithOptions([])
    }
    
}

struct LayoutableDebugDescriptionOptions: OptionSet {
    typealias RawValue = Int
    var rawValue: Int
    typealias Options = LayoutableDebugDescriptionOptions
    static let printType = Options(rawValue: 1)
}

extension Layoutable {
    func debugDescriptionWithOptions(_ options: LayoutableDebugDescriptionOptions) -> String {
        let identifier: String
        if options.contains(.printType) {
            identifier = self.layoutIdentifierWithType
        } else {
            identifier = self.layoutIdentifier
        }
        if branches.isEmpty {
            return identifier
        } else {
            return identifier + ": [\(branches.map({ $0.debugDescriptionWithOptions(options) }).joined(separator: ", "))]"
        }
    }
}
