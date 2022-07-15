//
//  NSLayoutConstraint.Axis+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//

import Foundation
import UIKit

extension NSLayoutConstraint.Axis {
    var configurationName: String {
        switch self {
        case .horizontal: return ".horizontal"
        case .vertical: return ".vertical"
        @unknown default: return ".unknown"
        }
    }
}
