//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/21.
//

import Foundation
import UIKit

protocol ObjectAddress: AnyObject {
    var address: String { get }
}

extension ObjectAddress {
    var address: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}

extension NSObject: ObjectAddress {}
