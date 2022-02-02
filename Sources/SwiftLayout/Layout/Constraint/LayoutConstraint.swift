//
//  ConstraintLayout.swift
//  
//
//  Created by maylee on 2022/02/02.
//

import Foundation
import UIKit

public struct LayoutConstraint<Layoutable>: Constraint where Layoutable: Layout {
    
    let layout: Layoutable
    
}
