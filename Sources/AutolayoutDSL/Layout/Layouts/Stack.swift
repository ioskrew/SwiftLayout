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
        
    }
}
