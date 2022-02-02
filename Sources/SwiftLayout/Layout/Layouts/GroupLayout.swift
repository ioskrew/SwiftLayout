//
//  GroupLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public struct GroupLayout<SomeLayout>: LayoutAttachable, LayoutContainable where SomeLayout: LayoutAttachable {
    
    public let layouts: [LayoutAttachable]
    
    public init(@LayoutBuilder _ layout: () -> SomeLayout) {
        layouts = [layout()]
    }
    
    public func attachConstraint(_ constraint: Constraint) {
        layouts.forEach { layout in
            layout.attachConstraint(constraint)
        }
    }
}
