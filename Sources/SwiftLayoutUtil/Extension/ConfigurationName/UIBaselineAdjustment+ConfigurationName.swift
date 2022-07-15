//
//  UIBaselineAdjustment+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/08.
//

import UIKit

extension UIBaselineAdjustment {
    var configurationName: String {
        switch self {
        case .alignBaselines: return ".alignBaselines"
        case .alignCenters: return ".alignCenters"
        case .none: return ".none"
        @unknown default: return ".unknown"
        }
    }
}
