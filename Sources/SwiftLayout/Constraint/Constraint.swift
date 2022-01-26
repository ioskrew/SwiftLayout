//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

public extension SwiftLayout {
    
    struct Constraint: Equatable {
        
        var rule: Rule
        let element: Element
        
        var view: UIView { element.item.view! }
        var attribute: NSLayoutConstraint.Attribute { element.attribute }
        
        var relation: NSLayoutConstraint.Relation { rule.relation }
        var multiplier: CGFloat { rule.multiplier }
        var constant: CGFloat { rule.constant }
        
        var constraints: [NSLayoutConstraint] { view.constraints }
       
        @discardableResult
        func attach(to target: Constraint) -> Constraint {
            let constraint = removeDuplicate(with: self)
            constraint.view.translatesAutoresizingMaskIntoConstraints = false
            constraint.view.addConstraint(NSLayoutConstraint(item: view,
                                                             attribute: attribute,
                                                             relatedBy: relation,
                                                             toItem: target.view,
                                                             attribute: target.attribute,
                                                             multiplier: 1.0, constant: 0.0))
            return constraint
        }
        
        @discardableResult
        func attach(to view: UIView) -> Constraint {
            let constraint = removeDuplicate(with: self.view)
            constraint.view.translatesAutoresizingMaskIntoConstraints = false
            constraint.view.addConstraint(NSLayoutConstraint(item: constraint.view,
                                                             attribute: attribute,
                                                             relatedBy: relation,
                                                             toItem: view,
                                                             attribute: attribute,
                                                             multiplier: 1.0, constant: 0.0))
            return constraint
        }
        
        @discardableResult
        func attach(from view: UIView) -> Constraint {
            let constraint = removeDuplicate(with: view)
            view.addConstraint(NSLayoutConstraint(item: view,
                                                  attribute: attribute,
                                                  relatedBy: relation,
                                                  toItem: self.view,
                                                  attribute: attribute,
                                                  multiplier: 1.0, constant: 0.0))
            return constraint
        }
        
        func removeDuplicate(with target: Constraint) -> Constraint {
            let constraints = view.constraints
            for constraint in constraints {
                guard constraint.firstView == view, constraint.firstAttribute == attribute else { continue }
                guard constraint.secondView == target.view, constraint.secondAttribute == target.attribute else { continue }
                view.removeConstraint(constraint)
            }
            return self
        }
        
        func removeDuplicate(with view: UIView) -> Constraint {
            let constraints = view.constraints
            for constraint in constraints {
                guard constraint.firstView == self.view, constraint.firstAttribute == attribute else { continue }
                guard constraint.secondView == view, constraint.secondAttribute == attribute else { continue }
                view.removeConstraint(constraint)
            }
            return self
        }
    }
    
    struct Rule: Equatable {
        internal init(relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
            self.relation = relation
            self.multiplier = multiplier
            self.constant = constant
        }
        
        let relation: NSLayoutConstraint.Relation
        
        var multiplier: CGFloat = 1.0
        var constant: CGFloat = 0.0
        
        static var `default`: Self {
            .init()
        }
    }
    
    struct Element: Equatable {
        let item: Item
        let attribute: NSLayoutConstraint.Attribute
        
        var view: UIView? {
            item.view
        }
        
        var object: AnyObject? {
            item.item
        }
        
        enum Item: Equatable {
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
        }
    }
    
    struct Binding: Equatable {
        let first: SwiftLayout.Element
        let second: SwiftLayout.Element?
        let rule: SwiftLayout.Rule
        
        func bind() -> NSLayoutConstraint {
            let constraint = NSLayoutConstraint(item: first.view!,
                                                attribute: first.attribute,
                                                relatedBy: rule.relation,
                                                toItem: second?.view,
                                                attribute: second?.attribute ?? .notAnAttribute,
                                                multiplier: rule.multiplier,
                                                constant: rule.constant)
            constraint.isActive = true
            return constraint
        }
    }
    
}

extension NSLayoutConstraint {
    var firstView: UIView? { firstItem as? UIView }
    var secondView: UIView? { secondItem as? UIView }
}
