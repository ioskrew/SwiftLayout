//
//  LayoutElement.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public extension SwiftLayout {
    
   struct Element: Hashable, CustomDebugStringConvertible {
       let item: Item
       let attribute: NSLayoutConstraint.Attribute
       
       var view: UIView? {
           item.view
       }
       
       var object: AnyObject? {
           item.item
       }
       
       func bind(_ binding: Binding) {
           guard let view = view else {
               return
           }
           let constraint = binding.bind()
           constraint.isActive = true
           view.addConstraint(constraint)
       }
       
       func bind(second element: Self, rule: Rule = .equal) {
           self.bind(rule.bind(first: self, second: element))
       }
       
       func bind(secondView: UIView) {
           self.bind(Rule.equal.bind(first: self, second: Element(item: .view(secondView), attribute: attribute)))
       }
       
       public var debugDescription: String {
           "\(item.debugDescription).\(attribute.debugDescription)"
       }
       
       enum Item: Hashable, CustomDebugStringConvertible {
           case view(UIView), guide(UILayoutGuide), none
           
           init(_ item: AnyObject?) {
               if let item = item {
                   if let view = item as? UIView {
                       self = .view(view)
                   } else if let guide = item as? UILayoutGuide {
                       self = .guide(guide)
                   } else {
                       fatalError()
                   }
               } else {
                   self = .none
               }
           }
           
           var item: AnyObject? {
               switch self {
               case .view(let uIView):
                   return uIView
               case .guide(let uILayoutGuide):
                   return uILayoutGuide
               case .none:
                   return nil
               }
           }
           
           var view: UIView? {
               switch self {
               case .view(let uIView):
                   return uIView
               case .guide(let uILayoutGuide):
                   return uILayoutGuide.owningView
               case .none:
                   return nil
               }
           }
           
           var debugDescription: String {
               switch self {
               case .view(let uIView):
                   return "view(\(uIView.layoutIdentifier))"
               case .guide(let uILayoutGuide):
                   return "guide(\(uILayoutGuide.owningView?.layoutIdentifier ?? "nil"))"
               case .none:
                   return "none"
               }
           }
       }
   }
    
}
