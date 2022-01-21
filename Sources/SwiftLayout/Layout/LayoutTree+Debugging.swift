
import Foundation
import UIKit

extension LayoutTree where Self: Encodable, Self: CustomDebugStringConvertible {
    var debugDescription: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        guard let data = try? encoder.encode(self) else { return "" }
        guard let json = String(data: data, encoding: .utf8) else { return "" }
        return json
    }
}

extension _LayoutElement: Encodable, CustomDebugStringConvertible {
    
    enum CodingKeys: String, CodingKey {
        case view
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .view)
    }
    
    var identifier: String {
        if let identifier = view.accessibilityIdentifier {
            return "\(identifier)(\(type(of: view)))"
        } else {
            return "\(view.address)(\(type(of: view)))"
        }
    }
}
