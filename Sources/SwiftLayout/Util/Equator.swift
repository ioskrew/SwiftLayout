//
//  Equator.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation

protocol NoHashableImpl {
    func isEqual(with object: NoHashableImpl) -> Bool
    func combineToHasher(_ hasher: inout Hasher)
}

protocol NoHashableEquatable: NoHashableImpl {
    var equator: Equator<Self> { get }
}

extension NoHashableEquatable {
    var equator: Equator<Self> {
        Equator(self)
    }
}

struct Equator<NoHashable: NoHashableImpl>: Hashable {
    
    internal init(_ noHashable: NoHashable) {
        self.noHashable = noHashable
    }
    
    static func == (lhs: Equator<NoHashable>, rhs: Equator<NoHashable>) -> Bool {
        lhs.noHashable.isEqual(with: rhs.noHashable)
    }
 
    let noHashable: NoHashable
    
    func hash(into hasher: inout Hasher) {
        noHashable.combineToHasher(&hasher)
    }
}

extension Equator: CustomDebugStringConvertible where NoHashable: CustomDebugStringConvertible {
    var debugDescription: String { noHashable.debugDescription }
}
