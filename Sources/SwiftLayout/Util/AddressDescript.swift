//
//  AddressDescriptor.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation

struct AddressDescriptor<Object>: CustomStringConvertible where Object: AnyObject {
    let description: String
    
    init(_ object: Object) {
        self.description = Unmanaged<Object>.passUnretained(object).toOpaque().debugDescription + ":\(type(of: object))"
    }
}
