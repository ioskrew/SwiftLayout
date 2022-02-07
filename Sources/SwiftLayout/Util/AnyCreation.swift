//
//  UIView+Creation.swift
//  
//
//  Created by oozoofrog on 2022/02/07.
//

import Foundation
import UIKit

public protocol AnyCreation {
    static func defaultInit() -> Self
}

extension UIView: AnyCreation {
    public static func defaultInit() -> Self {
        Self.init(frame: .zero)
    }
}

extension AnyCreation where Self: NSObject {
    
    public static func create(_ handling: (Self) -> Void) -> Self {
        let object = defaultInit()
        handling(object)
        return object
    }
    
}
