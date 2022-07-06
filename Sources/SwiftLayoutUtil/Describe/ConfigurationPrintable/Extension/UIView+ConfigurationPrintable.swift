//
//  UIView+ConfigurationPrintable.swift
//  
//
//  Created by aiden_h on 2022/07/06.
//

import UIKit

extension UIView: ConfigurationPrintable {
    public var configurablePropertys: [ConfigurableProperty] {
        [
            .property(keypath: \.isHidden, defualtValue: false) { "$0.isHidden = \($0)" },
            .property(keypath: \.alpha, defualtValue: 1.0) { "$0.alpha = \($0)" },
            .property(keypath: \.accessibilityLabel, defualtValue: nil) { value in "$0.accessibilityLabel = \(value.map({"\"\($0)\""}) ?? "nil")" },
        ]
    }
}

