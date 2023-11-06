//
//  DescribingUnit.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation

struct ViewDescriber {
    enum Constant {
        static var indents: String = "    "
    }

    let viewToken: ViewToken
    let constraintTokens: [AnchorToken]
    let subdescribes: [ViewDescriber]
    
    func descriptions(indents: String = "") -> [String] {
        let configDescriptions = viewToken.configuration.map(Constant.indents.appending).sorted()
        let anchorsDescriptions = AnchorsDescriber.descriptionFromConstraints(constraintTokens).map(Constant.indents.appending)
        let sublayoutDescriptions = subdescribes.flatMap { $0.descriptions(indents: Constant.indents) }

        var descriptions: [String] = [viewToken.viewTag]

        let isAfterConfig: Bool
        if configDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            last.append(".sl.onActivate {")
            descriptions.append(last)
            descriptions.append(contentsOf: configDescriptions)
            descriptions.append("}")
            isAfterConfig = true
        } else {
            isAfterConfig = false
        }

        let startFromFirstElement = descriptions.count == 1
        let isAfterAnchors: Bool
        if anchorsDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            if isAfterConfig {
                last.append(".sl.anchors {")
            } else {
                if startFromFirstElement {
                    last.append(".sl.anchors {")
                } else {
                    last.append(".anchors {")
                }
            }
            descriptions.append(last)
            descriptions.append(contentsOf: anchorsDescriptions)
            descriptions.append("}")
            isAfterAnchors = true
        } else {
            isAfterAnchors = false
        }

        if sublayoutDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            if isAfterAnchors {
                last.append(".sublayout {")
            } else {
                last.append(".sl.sublayout {")
            }
            descriptions.append(last)
            descriptions.append(contentsOf: sublayoutDescriptions)
            descriptions.append("}")
        }

        return descriptions.map(indents.appending)
    }
}
