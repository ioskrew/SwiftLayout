//
//  LayoutProperty.swift
//  
//
//  Created by oozoofrog on 2022/03/06.
//

import Foundation
import Combine

protocol LayoutPropertyPublisherable {
    var property: AnyPublisher<Void, Never> { get }
}

protocol LayoutPropertyEquatablePublisherable {
    var property: AnyPublisher<Void, Never> { get }
}

@propertyWrapper
public final class LayoutProperty<Value> {
    
    public var wrappedValue: Value {
        get {
            subject.value
        }
        set {
            subject.send(newValue)
        }
    }
    
    private let subject: CurrentValueSubject<Value, Never>
    
    public init(wrappedValue: Value) {
        subject = .init(wrappedValue)
    }
    
}

extension LayoutProperty: LayoutPropertyPublisherable {
    var property: AnyPublisher<Void, Never> {
        subject.map({ _ in }).eraseToAnyPublisher()
    }
}

extension LayoutProperty: LayoutPropertyEquatablePublisherable where Value: Equatable {
    var property: AnyPublisher<Void, Never> {
        subject.removeDuplicates().map({ _ in }).eraseToAnyPublisher()
    }
}
