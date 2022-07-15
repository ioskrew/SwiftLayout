//
//  UIButton+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//

import UIKit

@available(iOS 14, *)
extension UIButton.Role {
    var configurationName: String {
        switch self {
        case .normal: return ".normal"
        case .primary: return ".primary"
        case .cancel: return ".cancel"
        case .destructive: return ".destructive"
        @unknown default: return ".unknown"
        }
    }
}
