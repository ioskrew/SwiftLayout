//
//  AnchorsDescriber.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation
import UIKit

enum AnchorsDescriber {
    static func descriptionFromConstraints(_ constraints: [AnchorToken]) -> [String] {
        var seconds: [AnchorToken: Set<AnchorToken>] = [:]
        var constraintPool = Set(constraints)
        constraints.forEach { token in
            guard constraintPool.contains(token) else { return }
            constraintPool.remove(token)
            let secondAndRelationEquals = constraintPool.filter({ isEqualRelation(lt: $0, rt: token) })
            constraintPool.subtract(secondAndRelationEquals)
            seconds[token] = secondAndRelationEquals
        }
        let independents = constraintPool
        var descriptionLines: [String] = []
        seconds.sorted(by: { sort($0.key, $1.key) }).forEach { (token, tokens) in
            var mergedTokens = [token]
            mergedTokens.append(contentsOf: tokens)
            descriptionLines.append(AnchorsLineDescriber.describeAnchorToken(mergedTokens.sorted(by: { $0.secondAttribute.rawValue < $1.secondAttribute.rawValue })))
        }
        independents.sorted(by: sort).forEach { token in
            descriptionLines.append(AnchorsLineDescriber.describeAnchorToken([token]))
        }
        return descriptionLines
    }
    
    private static func isEqualRelation(lt: AnchorToken, rt: AnchorToken) -> Bool {
        lt.firstAttributeType != .unknown
        && lt.firstAttributeType == rt.firstAttributeType
        && lt.relation == rt.relation
        && lt.constant == rt.constant
        && lt.multiplier == rt.multiplier
        && lt.firstAttributeIsSecondAttribute
        && rt.firstAttributeIsSecondAttribute
    }
    
    private static func sort(_ lhs: AnchorToken, _ rhs: AnchorToken) -> Bool {
        if lhs.firstAttribute == rhs.firstAttribute {
            if lhs.secondAttribute == rhs.secondAttribute {
                if lhs.relation == rhs.relation {
                    return lhs.constant < rhs.constant && lhs.multiplier < rhs.multiplier
                } else {
                    return lhs.relation.rawValue < rhs.relation.rawValue
                }
            } else {
                return lhs.secondAttribute.rawValue < rhs.secondAttribute.rawValue
            }
        } else {
            return lhs.firstAttribute.rawValue < rhs.firstAttribute.rawValue
        }
    }
    
    enum AnchorsLineDescriber {
        private static func describeRelationFunction(_ token: AnchorToken) -> String {
            var functionDescription: String = ""
            if token.relation == .equal {
                functionDescription.append("equalTo")
            } else if token.relation == .lessThanOrEqual {
                functionDescription.append("lessThanOrEqualTo")
            } else if token.relation == .greaterThanOrEqual {
                functionDescription.append("greaterThanOrEqualTo")
            }
           
            if token.secondTagIsSuperview && (token.firstAttributeIsSecondAttribute || token.firstAttributeType != .dimension) {
                functionDescription.append("Super(")
            } else {
                functionDescription.append("(")
            }
            
            var parameters: [String] = []
            if !(token.secondTagIsSuperview && (token.firstAttributeIsSecondAttribute || token.firstAttributeType != .dimension)), !token.secondTag.isEmpty {
                parameters.append(token.secondTag)
            }
            if !token.firstAttributeIsSecondAttribute, token.secondAttribute != .notAnAttribute {
                parameters.append("attribute: .\(token.secondAttribute)")
            }
            if token.constant != 0.0 {
                parameters.append("constant: \(token.constant)")
            }
            functionDescription.append(parameters.joined(separator: ", "))
            functionDescription.append(")")
            return functionDescription
        }
        
        private static func describeValues(_ token: AnchorToken) -> [String] {
            var descriptions: [String] = []
            if isEnableHideRelation(token), token.constant != 0.0 {
                descriptions.append("constant(\(token.constant))")
            }
            if token.multiplier != 1.0 {
                descriptions.append("multiplier(\(token.multiplier))")
            }
            return descriptions
        }
        
        static func describeAnchorToken(_ tokens: [AnchorToken]) -> String {
            var descriptions: [String] = ["Anchors"]
            descriptions.append(tokens.map(\.firstAttribute.description).joined(separator: "."))
            if !isEnableHideRelation(tokens[0]) {
                descriptions.append(describeRelationFunction(tokens[0]))
            }
            descriptions.append(contentsOf: describeValues(tokens[0]))
            return descriptions.joined(separator: ".")
        }
        
        private static func isEnableHideRelation(_ token: AnchorToken) -> Bool {
            token.relation == .equal
            && token.firstAttributeIsSecondAttribute
            && (token.firstAttributeType != .dimension ? token.secondTagIsSuperview : token.secondTag.isEmpty)
        }
    }
}
