//
//  AddressDescriptor.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

public struct AddressDescriptor: Hashable, CustomStringConvertible {
    public let description: String
    
    public init<O: AnyObject>(_ object: O) {
        self.description = Unmanaged<O>.passUnretained(object).toOpaque()
            .debugDescription
            .appending(":")
            .appending(String(describing: type(of: object)))
    }
}
