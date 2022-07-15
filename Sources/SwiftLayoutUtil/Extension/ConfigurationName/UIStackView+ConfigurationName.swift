//
//  UIStackView+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//

import UIKit

extension UIStackView.Alignment {
    var configurationName: String {
        switch self {
        case .fill: return ".fill"
        case .leading: return ".leading"
        case .firstBaseline: return ".firstBaseline"
        case .center: return ".center"
        case .trailing: return ".trailing"
        case .lastBaseline: return ".lastBaseline"
        @unknown default: return ".unknown"
        }
    }
}

extension UIStackView.Distribution {
    var configurationName: String {
        switch self {
        case .fill: return ".fill"
        case .fillEqually: return ".fillEqually"
        case .fillProportionally: return ".fillProportionally"
        case .equalSpacing: return ".equalSpacing"
        case .equalCentering: return ".equalCentering"
        @unknown default: return ".unknown"
        }
    }
}
