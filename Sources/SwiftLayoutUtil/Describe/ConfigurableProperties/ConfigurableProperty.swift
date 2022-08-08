//
//  ConfigurableProperty.swift
//  
//
//  Created by aiden_h on 2022/07/06.
//

import UIKit

private protocol ConfigurablePropertyProtocol {
    func configuration(view: UIView) -> String?
}

public struct ConfigurableProperty {
    private let configurator: ConfigurablePropertyProtocol

    func configuration(view: UIView) -> String? {
        configurator.configuration(view: view)
    }

    private struct ConfigurablePropertyImp<View, Value>: ConfigurablePropertyProtocol  where View: UIView, Value: Equatable {
        let getter: (View) -> Value
        let defaultValue: Value
        let describer: (Value) -> String

        func configuration(view: UIView) -> String? {
            guard let view = view as? View else {
                return nil
            }

            let value = getter(view)

            guard value != defaultValue else {
                return nil
            }

            return describer(value)
        }
    }
}

extension ConfigurableProperty {
    public static func property<View: UIView, Value: Equatable>(
        getter: @escaping (View) -> Value,
        defaultValue: Value,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return ConfigurableProperty(
            configurator: ConfigurablePropertyImp(
                getter: getter,
                defaultValue: defaultValue,
                describer: describer
            )
        )
    }

    public static func property<View: UIView, Value: Equatable>(
        getter: @escaping (View) -> Value,
        defaultReferenceView: View,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return property(
            getter: getter,
            defaultValue: getter(defaultReferenceView),
            describer: describer
        )
    }

    public static func property<View: UIView, Value: Equatable>(
        keypath: KeyPath<View, Value>,
        defaultValue: Value,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return ConfigurableProperty(
            configurator: ConfigurablePropertyImp<View, Value>(
                getter: { view in
                    view[keyPath: keypath]
                },
                defaultValue: defaultValue,
                describer: describer
            )
        )
    }

    public static func property<View: UIView, Value: Equatable>(
        keypath: KeyPath<View, Value>,
        defaultReferenceView: View,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return property(
            keypath: keypath,
            defaultValue: defaultReferenceView[keyPath: keypath],
            describer: describer
        )
    }
}
