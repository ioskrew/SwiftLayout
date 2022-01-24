
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
    static let printUp = Options(rawValue: 1 << 1)
}

extension Layoutable {
    func debugDescriptionWithOptions(_ options: LayoutableDebugDescriptionOptions) -> String {
        var identifier: String
        if options.contains(.printType) {
            identifier = self.layoutIdentifierWithType
        } else {
            identifier = self.layoutIdentifier
        }
        if !branches.isEmpty {
            identifier = identifier + ": [\(branches.map({ $0.debugDescriptionWithOptions(options) }).joined(separator: ", "))]"
        }
        if options.contains(.printUp), let tree = self as? LayoutTree, let upContent = tree.up.tree?.content {
            identifier = "\(upContent.layoutIdentifier) -> \(identifier)"
        }
        return identifier
    }
}
