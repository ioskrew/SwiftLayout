//
//  Layout+Description.swift
//  
//
//  Created by aiden_h on 2022/03/31.
//

import SwiftLayout

extension Layout {
    var description: String {
        let typeName = String(describing: type(of: self))
        let typeNameWithoutGeneric: String
        if let typeName = typeName.split(separator: "<").first {
            typeNameWithoutGeneric = typeName.description
        } else {
            typeNameWithoutGeneric = "Unknown"
        }

        if let view = self.view {
            return "\(typeNameWithoutGeneric) - view: \(view.tagDescription)"
        } else {
            return typeNameWithoutGeneric
        }
    }
}
