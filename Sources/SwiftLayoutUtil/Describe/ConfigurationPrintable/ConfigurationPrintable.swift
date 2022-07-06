//
//  ConfigurationPrintable.swift
//  
//
//  Created by aiden_h on 2022/07/05.
//

import UIKit

public protocol ConfigurationPrintable: UIView {
    var configurablePropertys: [ConfigurableProperty] { get }
}

public extension ConfigurationPrintable {
    var configurations: [String] {
        configurablePropertys.compactMap {
            $0.configuration(view: self)
        }
    }
}
