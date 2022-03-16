//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation

struct AddressDescriptor<Object>: CustomStringConvertible where Object: AnyObject {
    let address: String
    let type: String
    
    var description: String { "\(address):\(type)" }
    
    init(_ object: Object) {
        self.address = Unmanaged<Object>.passUnretained(object).toOpaque().debugDescription
        self.type = "\(Swift.type(of: object))"
    }
}
