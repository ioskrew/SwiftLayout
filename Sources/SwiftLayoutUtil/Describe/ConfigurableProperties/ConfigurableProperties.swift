//
//  DefaultConfigurableProperties.swift
//  
//
//  Created by aiden_h on 2022/08/01.
//

import Foundation
import UIKit

public final class ConfigurableProperties {
    
    public static let `default` = ConfigurableProperties()
    
    private var handlers: [String: ConfigPropertiesHandlable] = [:]
    
    private init() {
        regist()
    }
    
    private func regist() {
        registUIView()
        registUILabel()
        registUIControl()
        registUIButton()
        registUIImage()
        registUIStackView()
    }
    
    func regist<V: UIView>(_ view: V.Type, propertiesHandler: @escaping (_ defaultReferenceView: V) -> [ConfigurableProperty]) {
        let name = String(describing: view)
        handlers[name] = ConfigPropertiesHandler(propertiesHandler: propertiesHandler)
    }

    public func regist<V: UIView>(_ view: V.Type, defaultReferenceView: @autoclosure @escaping () -> V, propertiesHandler: @escaping (_ defaultReferenceView: V) -> [ConfigurableProperty]) {
        let name = String(describing: view)
        handlers[name] = ConfigPropertiesHandler(defaultReferenceView: defaultReferenceView,
                                                 propertiesHandler: propertiesHandler)
    }
    
    private func properties<V: UIView>(view: V, excludePreparedProperties: Bool = false) -> [ConfigurableProperty] {
        let viewName = view.subjectTypeName
        let referenceView = handlers[viewName]?.preparedDefaultReferenceView() ?? V.new()
        var properties: [ConfigurableProperty] = []
        for name in viewInheritances(view) {
            guard let prepareProperties = handlers[name]?.properties(defaultReferenceView: referenceView) else {
                continue
            }
            if name == viewName, excludePreparedProperties {
                continue
            }
            properties.append(contentsOf: prepareProperties)
        }
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
    
    func configurableProperties<View: UIView>(view: View) -> [ConfigurableProperty] {
        return properties(view: view, excludePreparedProperties: false)
    }
    
    func configurablePropertiesExcludeSelf<View: UIView>(view: View) -> [ConfigurableProperty] {
        return properties(view: view, excludePreparedProperties: true)
    }
}

protocol ConfigPropertiesHandlable {
    func properties<RV: UIView>(defaultReferenceView: RV?) -> [ConfigurableProperty]
    func preparedDefaultReferenceView<RV: UIView>() -> RV?
}

struct ConfigPropertiesHandler<V: UIView>: ConfigPropertiesHandlable {
    private let defaultReferendeView: () -> V
    private let propertiesHandler: (V) -> [ConfigurableProperty]
    
    init(propertiesHandler: @escaping (V) -> [ConfigurableProperty]) {
        self.defaultReferendeView = { V.new() }
        self.propertiesHandler = propertiesHandler
    }
    
    init(defaultReferenceView: @escaping () -> V, propertiesHandler: @escaping (V) -> [ConfigurableProperty]) {
        self.defaultReferendeView = defaultReferenceView
        self.propertiesHandler = propertiesHandler
    }
    
    func properties<RV: UIView>(defaultReferenceView: RV?) -> [ConfigurableProperty] {
        guard let view: V = defaultReferenceView as? V else {
            return []
        }
        return self.propertiesHandler(view)
    }
    
    func preparedDefaultReferenceView<RV: UIView>() -> RV? {
        defaultReferendeView() as? RV
    }
}

private extension Mirror {
    var subjectTypeName: String {
        String(describing: subjectType)
    }
}

private extension UIView {
    static func new() -> Self {
        self.init()
    }
    
    var subjectTypeName: String {
        Mirror(reflecting: self).subjectTypeName
    }
}
