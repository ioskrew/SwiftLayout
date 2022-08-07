//
//  DefaultConfigurablePropertys.swift
//  
//
//  Created by aiden_h on 2022/08/01.
//

import Foundation
import UIKit

public final class ConfigurableProperties {
    
    public static let `default` = ConfigurableProperties()
    
    private var handlers: [String: ConfigPropertiesHandlable] = [:]
    
    public func regist() {
        registUIView()
        registUILabel()
        registUIControl()
        registUIButton()
        registUIImage()
        registUIStackView()
    }
    
    public func regist<V: UIView>(_ view: V.Type, propertiesHandler: @escaping (_ defaultReferenceView: V) -> [ConfigurableProperty]) {
        let name = String(describing: view)
        handlers[name] = ConfigPropertiesHandler(propertiesHandler: propertiesHandler)
    }
    
    public func unregist<V: UIView>(_ view: V.Type) {
        let name = String(describing: view)
        handlers[name] = nil
    }
    
    private func properties<V: UIView>(view: V, defaultReferenceView: V? = nil, excludePreparedProperties: Bool = false) -> [ConfigurableProperty] {
        let referenceView = defaultReferenceView ?? view.new()
        var properties: [ConfigurableProperty] = []
        let viewName = view.subjectTypeName
        for name in viewInheritances(view) {
            guard let prepareProperties = handlers[name]?.properties(defaultReferenceView: referenceView) else {
                continue
            }
            if name == viewName, excludePreparedProperties {
                continue
            }
            properties.append(contentsOf: prepareProperties)
        }
        properties.append(contentsOf: accessibilityDefaultConfigurablePropertys(defaultReferenceView: referenceView))
        return properties
    }
    
    private func viewInheritances<V>(_ view: V) -> [String] where V: UIView {
        var mirror: Mirror? = Mirror(reflecting: view)
        var names: [String] = []
        while mirror != nil {
            guard let viewMirror = mirror else {
                break
            }
            names.append(viewMirror.subjectTypeName)
            if viewMirror.subjectTypeName == "UIView" {
                break
            }
            mirror = viewMirror.superclassMirror
        }
        return names.reversed()
    }
    
    public func configurablePropertys<View: UIView>(view: View, defaultReferenceView: View? = nil) -> [ConfigurableProperty] {
        return properties(view: view, defaultReferenceView: defaultReferenceView)
    }
    
    func configurablePropertys<View: UIView>(view: View, defaultReferenceView: View? = nil, excludePreparedProperties: Bool = false) -> [ConfigurableProperty] {
        return properties(view: view, defaultReferenceView: defaultReferenceView, excludePreparedProperties: excludePreparedProperties)
    }
}

extension ConfigurableProperties {
    func accessibilityDefaultConfigurablePropertys(defaultReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.accessibilityHint, defaultReferenceView: view) { "$0.accessibilityHint = \($0.configuration)"},
            .property(keypath: \.accessibilityIdentifier, defaultReferenceView: view) { "$0.accessibilityIdentifier = \($0.configuration)"},
            .property(keypath: \.accessibilityLabel, defaultReferenceView: view) { "$0.accessibilityLabel = \($0.configuration)"},
            .property(keypath: \.accessibilityTraits, defaultReferenceView: view) { "$0.accessibilityTraits = \($0.configuration)"},
            .property(keypath: \.isAccessibilityElement, defaultReferenceView: view) { "$0.isAccessibilityElement = \($0)"},
        ]
    }
}

protocol ConfigPropertiesHandlable {
    func properties<V: UIView>(defaultReferenceView: V) -> [ConfigurableProperty]
}

struct ConfigPropertiesHandler<V: UIView>: ConfigPropertiesHandlable {
    private let propertiesHandler: (V) -> [ConfigurableProperty]
    
    init(propertiesHandler: @escaping (V) -> [ConfigurableProperty]) {
        self.propertiesHandler = propertiesHandler
    }
    
    func properties<RV: UIView>(defaultReferenceView: RV) -> [ConfigurableProperty] {
        guard let view: V = defaultReferenceView as? V else {
            return []
        }
        return self.propertiesHandler(view)
    }
}

private extension Mirror {
    var subjectTypeName: String {
        String(describing: subjectType)
    }
}

private extension UIView {
    func new() -> Self {
        Self.init()
    }
    
    var subjectTypeName: String {
        Mirror(reflecting: self).subjectTypeName
    }
}
