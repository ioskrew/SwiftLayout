//
//  File.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

@resultBuilder
public struct LayoutBuilder {
    public static func buildBlock<Component>(_ component: Component) -> Component where Component: Layout {
        component
    }
}
