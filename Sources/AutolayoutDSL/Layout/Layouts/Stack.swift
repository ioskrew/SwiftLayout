//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/15.
//

import Foundation
import UIKit

extension Layout {
    public struct Stack<Content>: AutolayoutComponent where Content: AutolayoutComponent {
        
        public enum Axis {
            case x, y
        }
        
        let axis: Axis
        
        let content: Content
        
        public init(axis: Axis, @AutolayoutBuilder content: () -> Content) {
            self.axis = axis
            self.content = content()
        }
        
        public func constraints() -> [NSLayoutConstraint] {
            switch axis {
            case .x:
                return constraintsXAxis()
            case .y:
                return constraintsYAxis()
            }
        }
        
        private func constraintsXAxis() -> [NSLayoutConstraint] {
            guard let components = (content as? Builder.Components)?.components else { return [] }
            guard components.count > 1 else { return [] }
            var prev: AutolayoutComponent?
            var constraints: [NSLayoutConstraint] = []
            for component in components {
                component.prepare()
                if let prev = prev {
                    constraints.append(contentsOf: prev.bindTrailingToLeading(component))
                }
                prev = component
            }
            return constraints
        }
        
        private func constraintsYAxis() -> [NSLayoutConstraint] {
            guard let components = (content as? Builder.Components)?.components else { return [] }
            guard components.count > 1 else { return [] }
            var prev: AutolayoutComponent?
            var constraints: [NSLayoutConstraint] = []
            for component in components {
                component.prepare()
                if let prev = prev {
                    constraints.append(contentsOf: prev.bindBottomToTop(component))
                }
                prev = component
            }
            return constraints
        }
        
    }
}
