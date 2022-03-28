//
//  DescribingUnit.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation

struct ViewDescriber {
    let viewToken: ViewToken
    let constraintTokens: [AnchorToken]
    let subdescribes: [ViewDescriber]
    
    func descriptions(indents: String = "") -> [String] {
        var descriptions: [String] = []
        if constraintTokens.isEmpty {
            if subdescribes.isEmpty {
                descriptions.append(viewToken.viewTag)
            } else {
                descriptions.append(viewToken.viewTag.appending(" {"))
                descriptions.append(contentsOf: subdescribes.flatMap({ $0.descriptions(indents: indents.appending("\t")) }))
                descriptions.append("}")
            }
        } else {
            descriptions.append(viewToken.viewTag.appending(".anchors {"))
            descriptions.append(contentsOf: AnchorsDescriber.descriptionFromConstraints(constraintTokens).map("\t".appending))
            if !subdescribes.isEmpty {
                descriptions.append("}.sublayout {")
                descriptions.append(contentsOf: subdescribes.flatMap({ $0.descriptions(indents: indents.appending("\t")) }))
            }
            descriptions.append("}")
        }
        return descriptions.map(indents.appending)
    }
    
}
