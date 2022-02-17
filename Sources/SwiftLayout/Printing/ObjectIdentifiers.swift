//
//  ObjectIdentifiers.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation
import UIKit

struct ObjectIdentifiers {
    let object: AnyObject
    let identifieds: [Identified]
    var identifiers: [String] { identifieds.map(\.identifier) }
    
    init(_ object: AnyObject) {
        self.object = object
        self.identifieds = Mirror(reflecting: object).children.compactMap(Identified.init)
    }
    
    func prepare() {
        for identified in identifieds {
            identified.prepare()
        }
    }
    
    struct Identified: Hashable {
        let identifier: String
        let view: UIView
        
        init?(_ child: (String?, Any)) {
            guard let identifier = child.0 else { return nil }
            guard let view = child.1 as? UIView else { return nil }
            self.identifier = identifier
            self.view = view
        }
        
        func prepare() {
            view.accessibilityIdentifier = identifier
        }
    }
}
