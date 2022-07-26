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
        let anchersDescriptions = AnchorsDescriber.descriptionFromConstraints(constraintTokens).map(Constant.indents.appending)
        let sublayoutDescriptions = subdescribes.flatMap { $0.descriptions(indents: Constant.indents) }

        var descriptions: [String] = [viewToken.viewTag]

        if configDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            last.append(".config {")
            descriptions.append(last)
            descriptions.append(contentsOf: configDescriptions)
            descriptions.append("}")
        }

        if anchersDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            last.append(".anchors {")
            descriptions.append(last)
            descriptions.append(contentsOf: anchersDescriptions)
            descriptions.append("}")
        }

        if sublayoutDescriptions.isEmpty == false {
            var last = descriptions.removeLast()
            last.append(".sublayout {")
            descriptions.append(last)
            descriptions.append(contentsOf: sublayoutDescriptions)
            descriptions.append("}")
        }

        return descriptions.map(indents.appending)
    }
}
