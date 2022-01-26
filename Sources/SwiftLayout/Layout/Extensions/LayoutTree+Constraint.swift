//
//  LayoutTree+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

extension LayoutTree.ContentContainer {
    
    typealias ContentContainer = LayoutTree.ContentContainer
    typealias LayoutElement = SwiftLayout.Element
    typealias LayoutRule = SwiftLayout.Rule
    
    func addSubcontent(_ container: ContentContainer) {
        
        if let superview = self.view {
            if let subview = container.view {
                superview.addSubview(subview)
            }
        }
        
        switch (self, container) {
        case (.view(let secondView), .element(let first)):
            let second = LayoutElement(item: .init(secondView), attribute: first.attribute)
            let binding = LayoutRule.equal.bind(first: first, second: second)
            first.bind(binding)
        case (.element(let second), .element(let first)):
            first.bind(second: second)
        case (.element(let second), .view(let firstView)):
            let first = LayoutElement(item: .view(firstView), attribute: second.attribute)
            first.bind(second: second)
        default:
            break
        }
    }
    
}
