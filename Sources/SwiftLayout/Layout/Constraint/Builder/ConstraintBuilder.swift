//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

@resultBuilder
public struct ConstraintBuilder {
    
    public static func buildBlock(_ components: ConstraintBinder...) -> [ConstraintBinder] {
        components
    }
   
}
