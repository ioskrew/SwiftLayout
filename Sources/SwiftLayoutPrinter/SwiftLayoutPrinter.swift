//
//  SwiftLayoutPrinter.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import Foundation
import SwiftLayout
import UIKit

public struct SwiftLayoutPrinter: CustomStringConvertible {
    
    public struct PrintOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// print system constraints
        public static let withSystemConstraints: PrintOptions = .init(rawValue: 1)
        /// print view only have accessibility identifier
        public static let onlyIdentifier: PrintOptions = .init(rawValue: 1 << 1)
        /// print with view config
        public static let withViewConfig: PrintOptions = .init(rawValue: 1 << 2)
    }
    
    public init(_ view: SLView, tags: [SLView: String] = [:]) {
        self.view = view
        self.tags = [:] // Dictionary(uniqueKeysWithValues: tags.map({ ($0.key.tagDescription, $0.value) }))
    }
    
    weak var view: SLView?
    let tags: [String: String]
    
    public var description: String {
        print()
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    /// - Parameters:
    ///  - updater: ``IdentifierUpdater``
    ///  - systemConstraintsHidden: automatically assigned constraints from system hidden, default value is `true`
    ///  - printOnlyIdentifier: print view only having accessibility identifier
    /// - Returns: String of SwiftLayout syntax
    @available(*, deprecated, message: "use PrintOptions")
    public func print(_ updater: IdentifierUpdater? = nil,
                      systemConstraintsHidden: Bool = true,
                      printOnlyIdentifier: Bool = false) -> String {
        var options: PrintOptions = []
        if !systemConstraintsHidden {
            options.insert(.withSystemConstraints)
        }
        if printOnlyIdentifier {
            options.insert(.onlyIdentifier)
        }
        return print(updater, options: options)
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    /// - Parameters:
    ///  - updater: ``IdentifierUpdater``
    ///  - options: ``PrintOptions``
    /// - Returns: String of SwiftLayout syntax
    public func print(_ updater: IdentifierUpdater? = nil, options: PrintOptions = []) -> String {
        return ""
//        guard let view = view else {
//            return ""
//        }
//
//        if let updater = updater {
//            updater.update(view, fixedTags: Set(tags.keys))
//        }
//
//        guard let viewToken = ViewToken.Parser.from(view, tags: tags, options: options) else { return "" }
//        let constraints = ConstraintToken.Parser.from(view, tags: tags, options: options)
//        return Describer(viewToken, constraints).description
    }
    
}

// MARK: - Describer
//private struct Describer: CustomStringConvertible {
//
//    private let views: [ViewToken]
//    private let constraints: [ConstraintToken]
//    private let identifier: ViewToken.Identifier
//    private let properties: [String]
//
//    init(_ token: ViewToken, _ constraints: [ConstraintToken]) {
//        self.views = token.views
//        self.constraints = constraints
//        self.identifier = token.identifier
//        self.properties = token.properties
//    }
//
//    var description: String {
//        if views.isEmpty {
//            return fromConstraints(constraintsOfIdentifier, identifier: identifier).joined(separator: "\n")
//        } else {
//            return fromViews(constraintsOfIdentifier, views: views, identifier: identifier).joined(separator: "\n")
//        }
//    }
//
//    private var constraintsOfIdentifier: [ConstraintToken]? {
//        let constraints = constraints.filter({ $0.firstTag == identifier.tag })
//        if constraints.isEmpty { return nil }
//        return constraints
//    }
//
//    private func fromConstraints(_ constraints: [ConstraintToken]?, identifier: ViewToken.Identifier) -> [String] {
//        guard  let constraintTokens = constraints else { return [identifier.identifier] }
//        var identifiers: [String] = []
//        if properties.isEmpty {
//            identifiers = [identifier.identifier + ".anchors {"]
//        } else {
//            identifiers = [identifier.identifier + ".config {"]
//            identifiers.append(contentsOf: properties.map { "\t\($0)" })
//            identifiers.append("}.anchors {")
//        }
//        identifiers.append(ConstraintToken.Group(constraintTokens).description)
//        identifiers.append("}")
//        return identifiers
//    }
//
//    private func fromViews(_ constraints: [ConstraintToken]?, views: [ViewToken], identifier: ViewToken.Identifier) -> [String] {
//        var identifiers: [String] = []
//        if constraints == nil {
//            identifiers = [identifier.identifier + " {"]
//        } else if let selfConstraints = constraints {
//            identifiers = [identifier.identifier + ".anchors {"]
//            identifiers.append(ConstraintToken.Group(selfConstraints).description)
//            identifiers.append("}.sublayout {")
//        } else {
//            identifiers = [identifier.identifier + " {"]
//        }
//        identifiers.append(contentsOf: views.map({ view in
//            let description = Describer(view, self.constraints).description
//            return description.split(separator: "\n").map({ "\t" + $0 }).joined(separator: "\n")
//        }))
//        identifiers.append("}")
//        return identifiers
//    }
//}
//
//// MARK: - ViewToken
//private struct ViewToken {
//
//    enum Identifier {
//        case id(String)
//        case object(address: String, type: String)
//
//        var tag: String {
//            switch self {
//            case .id(let string):
//                return string
//            case .object(let address, let type):
//                return "\(address):\(type)"
//            }
//        }
//        var identifier: String {
//            switch self {
//            case .id(let string):
//                return string
//            case .object(let address, let type):
//                return "\(type)().identifying(\"\(address):\(type)\")"
//            }
//        }
//    }
//
//    let identifier: Identifier
//    let properties: [String]
//    let views: [ViewToken]
//
//    private init(identifier: Identifier, properties: [String], views: [ViewToken]) {
//        self.identifier = identifier
//        self.properties = properties
//        self.views = views
//    }
//
//    struct Parser {
//        static func from(_ view: SLView, tags: [String: String], options: SwiftLayoutPrinter.PrintOptions) -> ViewToken? {
//            if let identifier = tags[view.tagDescription] {
//                return ViewToken(identifier: .id(identifier),
//                                 properties: options.contains(.withViewConfig) ? propertiesFrom(view) : [],
//                                 views: view.subviews.compactMap({ from($0, tags: tags, options: options) }))
//            } else {
//                if options.contains(.onlyIdentifier) {
//                    if let identifier = view.slIdentifier, !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                        return ViewToken(identifier: .id(identifier),
//                                         properties: options.contains(.withViewConfig) ? propertiesFrom(view) : [],
//                                         views: view.subviews.compactMap({ from($0, tags: tags, options: options) }))
//                    } else {
//                        return nil
//                    }
//                } else {
//                    let identifier: Identifier
//                    if let id = view.slIdentifier {
//                        identifier = .id(id)
//                    } else {
//                        let descriptor = AddressDescriptor(view)
//                        identifier = .object(address: descriptor.address, type: descriptor.type)
//                    }
//                    return ViewToken(identifier: identifier,
//                                     properties: options.contains(.withViewConfig) ? propertiesFrom(view) : [],
//                                     views: view.subviews.compactMap({ from($0, tags: tags, options: options) }))
//                }
//            }
//        }
//
//        static func propertiesFrom(_ view: SLView) -> [String] {
//            #if canImport(UIKit)
//            if let label = view as? UILabel {
//                return propertiesFromLabel(label).map { "$0.\($0)" }
//            } else {
//                return []
//            }
//            #elseif canImport(AppKit)
//            return []
//            #else
//            return []
//            #endif
//        }
//
//        static func propertiesFromLabel(_ label: UILabel) -> [String] {
//            var properties: [String: Any] = [:]
//            if let text = label.text {
//                properties["text"] = "\"\(text)\""
//            }
//            if let font = label.font {
//                properties["font"] = propertyFromFont(font)
//            }
//            if label.textAlignment != .natural {
//                properties["textAlignment"] = ".\(label.textAlignment)"
//            }
//            if label.lineBreakMode != .byTruncatingTail {
//                properties["lineBreakMode"] = ".\(label.lineBreakMode)"
//            }
//            if label.numberOfLines != 1 {
//                properties["numberOfLines"] = label.numberOfLines.description
//            }
//            return properties.map({ "\($0.0) = \($0.1)" }).sorted()
//        }
//
//        static func propertyFromFont(_ font: UIFont) -> String {
//            if font.fontName == UIFont.systemFont(ofSize: 1).fontName {
//                return "UIFont.systemFont(ofSize: \(font.pointSize))"
//            } else if font.fontName == UIFont.boldSystemFont(ofSize: 1).fontName {
//                return "UIFont.boldSystemFont(ofSize: \(font.pointSize))"
//            } else if font.fontName == UIFont.italicSystemFont(ofSize: 1).fontName {
//                return "UIFont.italicSystemFont(ofSize: \(font.pointSize))"
//            } else {
//                return "UIFont(name: \"\(font.fontName)\", size: \(font.pointSize))"
//            }
//        }
//    }
//}
//
//// MARK: - ConstraintToken
//private struct ConstraintToken: CustomStringConvertible, Hashable {
//    static func == (lhs: ConstraintToken, rhs: ConstraintToken) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//
//    private init(constraint: SLLayoutConstraint, tags: [String: String]) {
//        let tagger = Tagger(tags: tags)
//        superTag = tagger.superTagFromItem(constraint.firstItem)
//        firstTag = tagger.tagFromItem(constraint.firstItem)
//        firstAttribute = constraint.firstAttribute.description
//        firstAttributes = [firstAttribute]
//        secondTag = tagger.tagFromItem(constraint.secondItem)
//        secondIdentifier = tagger.slIdentifierFromItem(constraint.secondItem)
//        secondAttribute = constraint.secondAttribute.description
//        relation = constraint.relation.description
//        constant = constraint.constant.description
//        multiplier = constraint.multiplier.description
//    }
//
//    let superTag: String
//    let firstTag: String
//    let firstAttribute: String
//    var firstAttributes: [String]
//    let secondTag: String
//    let secondIdentifier: String?
//    let secondAttribute: String
//    let relation: String
//    let constant: String
//    let multiplier: String
//
//    var description: String {
//        var descriptions: [String] = ["Anchors(\(firstAttributes.map({ "." + $0 }).joined(separator: ", ")))"]
//        var arguments: [String] = []
//        if !secondTag.isEmpty && superTag != secondTag {
//            if secondIdentifier != nil {
//                arguments.append(secondTag)
//            } else {
//                arguments.append("\"\(secondTag)\"")
//            }
//        }
//        if firstAttribute != secondAttribute && secondAttribute != SLLayoutConstraint.Attribute.notAnAttribute.description {
//            arguments.append("attribute: .\(secondAttribute)")
//        }
//        if constant != "0.0" {
//            arguments.append("constant: \(constant)")
//        }
//        if !arguments.isEmpty || relation != "equal" {
//            descriptions.append("\(relation)To(\(arguments.joined(separator: ", ")))")
//        }
//        if multiplier != "1.0" {
//            descriptions.append("setMultiplier(\(multiplier))")
//        }
//        return descriptions.joined(separator: ".")
//    }
//
//    func appendingFirstAttribute(_ firstAttribute: String) -> Self {
//        var token = self
//        token.firstAttributes.append(firstAttribute)
//        return token
//    }
//
//    private func functionNameByRelation(_ relation: SLLayoutConstraint.Relation) -> String {
//        relation.description
//    }
//
//    struct Parser {
//        static func from(_ view: SLView, tags: [String: String], options: SwiftLayoutPrinter.PrintOptions) -> [ConstraintToken] {
//            let constraints = view.constraints
//                .filter({ Validator.isUserCreation($0, options: options) })
//            var tokens = constraints.map({ ConstraintToken(constraint: $0, tags: tags) })
//            tokens.append(contentsOf: view.subviews.flatMap({ from($0, tags:tags, options: options) }))
//            return tokens
//        }
//    }
//
//    struct Validator {
//        static func isUserCreation(_ constraint: SLLayoutConstraint, options: SwiftLayoutPrinter.PrintOptions) -> Bool {
//            let description = constraint.debugDescription
//            if options.contains(.withSystemConstraints) {
//                return true
//            } else {
//                guard description.contains("NSLayoutConstraint") else { return false }
//                #if canImport(AppKit)
//                guard let range = description.range(of: "'NSViewSafeAreaLayoutGuide-[:alpha:]*'", options: [.regularExpression], range: description.startIndex..<description.endIndex) else { return true }
//                #else
//                guard let range = description.range(of: "'UIViewSafeAreaLayoutGuide-[:alpha:]*'", options: [.regularExpression], range: description.startIndex..<description.endIndex) else { return true }
//                #endif
//                return range.isEmpty
//            }
//        }
//    }
//
//    struct Tagger {
//        let tags: [String: String]
//        func tagFromItem(_ item: AnyObject?) -> String {
//            if let view = item as? SLView {
//                return identifierFromView(view)
//            } else if let guide = item as? SLLayoutGuide, let view = guide.owningView {
//                if let propertyDescription = guide.propertyDescription {
//                    return identifierFromView(view) + ".\(propertyDescription)"
//                } else {
//                    return identifierFromView(view) + ":\(guide.identifier)"
//                }
//            } else {
//                return ""
//            }
//        }
//
//        func identifierFromView(_ view: SLView) -> String {
//            if let tag = tags[view.tagDescription] {
//                return tag
//            } else {
//                return view.tagDescription
//            }
//        }
//
//        func slIdentifierFromItem(_ item: AnyObject?) -> String? {
//            if let view = item as? SLView {
//                return view.slIdentifier
//            } else if let guide = item as? SLLayoutGuide, let view = guide.owningView {
//                return view.slIdentifier
//            } else {
//                return nil
//            }
//        }
//
//        func superTagFromItem(_ item: AnyObject?) -> String {
//            if let view = (item as? SLView)?.superview {
//                return tagFromItem(view)
//            } else if let view = (item as? SLLayoutGuide)?.owningView?.superview {
//                return tagFromItem(view)
//            } else {
//                return tagFromItem(item)
//            }
//        }
//
//    }
//
//    struct Group: CustomStringConvertible {
//
//        let tokens: [ConstraintToken]
//
//        init(_ tokens: [ConstraintToken]) {
//            self.tokens = tokens
//        }
//
//        var description: String {
//            var mergedTokens: [ConstraintToken] = []
//            for token in tokens {
//                if mergedTokens.isEmpty {
//                    mergedTokens.append(token)
//                } else {
//                    if let prevToken = mergedTokens.first(where: token.intersect) {
//                        let newToken = prevToken.appendingFirstAttribute(token.firstAttribute)
//                        guard let index = mergedTokens.firstIndex(of: prevToken) else { continue }
//                        mergedTokens.remove(at: index)
//                        mergedTokens.insert(contentsOf: [newToken], at: index)
//                    } else {
//                        mergedTokens.append(token)
//                    }
//                }
//            }
//
//            return mergedTokens.map({ "\t" + $0.description }).joined(separator: "\n")
//        }
//    }
//
//    func intersect(_ token: ConstraintToken) -> Bool {
//        return self.firstTag == token.firstTag
//        && self.secondTag == token.secondTag
//        && self.constant == token.constant
//        && self.multiplier == token.multiplier
//        && self.relation == token.relation
//    }
//}

extension NSTextAlignment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .center:       return "center"
        case .justified:    return "justified"
        case .left:         return "left"
        case .natural:      return "natural"
        case .right:        return "right"
        default:            return "unknown"
        }
    }
}

extension NSLineBreakMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .byTruncatingHead:     return "byTruncatingHead"
        case .byCharWrapping:       return "byCharWrapping"
        case .byClipping:           return "byClipping"
        case .byTruncatingMiddle:   return "byTruncatingMiddle"
        case .byTruncatingTail:     return "byTruncatingTail"
        case .byWordWrapping:       return "byWordWrapping"
        @unknown default:           return "unknown"
        }
    }
}
