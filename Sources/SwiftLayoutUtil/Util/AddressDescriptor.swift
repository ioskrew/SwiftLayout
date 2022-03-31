//
//  AddressDescriptor.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

struct AddressDescriptor: Hashable, CustomStringConvertible {
    let description: String
    
    init<O: AnyObject>(_ object: O) {
        self.description = Unmanaged<O>.passUnretained(object).toOpaque()
            .debugDescription
            .appending(":")
            .appending(String(describing: type(of: object)))
    }
}
