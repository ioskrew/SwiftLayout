//
//  LayoutPrinter.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import UIKit
import SwiftLayout

@MainActor
public struct LayoutPrinter: @preconcurrency CustomStringConvertible {
    let layout: Layout
    let withAnchors: Bool
    
    public init(_ layout: Layout, withAnchors: Bool = false) {
        self.layout = layout
        self.withAnchors = withAnchors
    }
    
    public var description: String {
        layoutStructureDescriptions(layout: self.layout, withAnchors: self.withAnchors).joined(separator: "\n")
    }
    
    public func print() {
        Swift.print(self.description)
    }
    
    public func copyToPasteboard() {
        UIPasteboard.general.string = self.description
    }
}

extension LayoutPrinter {
    private func layoutStructureDescriptions(layout: Layout, withAnchors: Bool = false, _ indent: String = "", _ sublayoutIndent: String = "") -> [String] {
        var result: [String] = ["\(indent)\(layout.description)"]
        
        if withAnchors {
            let anchorsIndent: String
            if layout.sublayouts.isEmpty {
                anchorsIndent = sublayoutIndent.appending("      ")
            } else {
                anchorsIndent = sublayoutIndent.appending("│     ")
            }
            let properties = layout.anchors.constraints
            properties.map {
                anchorsDescription($0)
            }.forEach {
                result.append(anchorsIndent.appending($0))
            }
        }
        
        var sublayouts = layout.sublayouts
        if sublayouts.isEmpty {
            return result
        } else {
            let last: Layout = sublayouts.removeLast()
            for sublayout in sublayouts {
                result.append(
                    contentsOf: layoutStructureDescriptions(
                        layout: sublayout,
                        withAnchors: withAnchors,
                        sublayoutIndent.appending("├─ "),
                        sublayoutIndent.appending("│  ")
                    )
                )
            }
            result.append(
                contentsOf: layoutStructureDescriptions(
                    layout: last,
                    withAnchors: withAnchors,
                    sublayoutIndent.appending("└─ "),
                    sublayoutIndent.appending("   ")
                )
            )
        }
        
        return result
    }
}

extension LayoutPrinter {
    private func anchorsDescription(_ property: AnchorsConstraintProperty) -> String {
        var elements = Array<String>()
        elements.append(".".appending(property.attribute.description))
        elements.append(property.relation.shortDescription)
        elements.append(contentsOf: anchorsToItemDescriptions(property))
        elements.append(contentsOf: anchorsValuesDescriptions(property))
        return elements.joined(separator: " ")
    }
    
    private func anchorsToItemDescriptions(_ property: AnchorsConstraintProperty) -> [String] {
        if let itemDescription = property.toItem.description {
            if let toAttribute = property.toAttribute {
                return [itemDescription.appending(".").appending(toAttribute.description)]
            } else {
                return [itemDescription.appending(".").appending(property.attribute.description)]
            }
        } else if !property.isDimension {
            if let toAttribute = property.toAttribute {
                return ["superview.".appending(toAttribute.description)]
            } else {
                return ["superview.".appending(property.attribute.description)]
            }
        }
        
        return []
    }
    
    private func anchorsValuesDescriptions(_ property: AnchorsConstraintProperty) -> [String] {
        var elements = Array<String>()
        if property.multiplier != 1.0 {
            elements.append("x ".appending(property.multiplier.description))
        }

        if property.constant < 0.0 {
            elements.append("- ".appending(abs(property.constant).description))
        } else if property.constant > 0.0 {
            elements.append("+ ".appending(property.constant.description))
        }
        return elements
    }
}
