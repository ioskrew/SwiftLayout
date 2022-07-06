//
//  ConfigurableProperty.swift
//  
//
//  Created by aiden_h on 2022/07/06.
//

import UIKit

protocol ConfigurablePropertyProtocol {
    func configuration(view: UIView) -> String?
}

public struct ConfigurableProperty {
    private let configurator: ConfigurablePropertyProtocol

    func configuration(view: UIView) -> String? {
        configurator.configuration(view: view)
    }

    public static func property<View: UIView, Value: Equatable>(
        keypath: KeyPath<View, Value>,
        defualtValue: Value,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        ConfigurableProperty(
            configurator: ConfigurablePropertyImp(
                keypath: keypath,
                defualtValue: defualtValue,
                describer: describer
            )
        )
    }

    private struct ConfigurablePropertyImp<View, Value>: ConfigurablePropertyProtocol  where View: UIView, Value: Equatable {
        let keypath: KeyPath<View, Value>
        let defualtValue: Value
        let describer: (Value) -> String

        func configuration(view: UIView) -> String? {
            guard let view = view as? View else {
                return nil
            }

            let value = view[keyPath: keypath]

            guard value != defualtValue else {
                return nil
            }

            return describer(value)
        }
    }
}
