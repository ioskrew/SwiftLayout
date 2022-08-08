//
//  CustomConfigurableProperties.swift
//  
//
//  Created by aiden_h on 2022/07/05.
//

import UIKit

public protocol CustomConfigurableProperties: AnyObject {
    var configurableProperties: [ConfigurableProperty] { get }
}
