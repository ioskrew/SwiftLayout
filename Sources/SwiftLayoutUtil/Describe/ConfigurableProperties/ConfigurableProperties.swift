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

    public func regist<V: UIView>(
        _ view: V.Type,
        defaultReferenceView: @autoclosure @escaping () -> V,
        propertiesHandler: @escaping (_ defaultReferenceView: V) -> [ConfigurableProperty]
    ) {
        let name = String(describing: view)
        handlers[name] = ConfigPropertiesHandler(
            defaultReferenceView: defaultReferenceView,
            propertiesHandler: propertiesHandler
        )
    }

    func configurableProperties<View: UIView>(view: View) -> [ConfigurableProperty] {
        return properties(view: view, excludePreparedProperties: false)
    }

    func configurablePropertiesExcludeSelf<View: UIView>(view: View) -> [ConfigurableProperty] {
        return properties(view: view, excludePreparedProperties: true)
    }
    
    private func properties<V: UIView>(view: V, excludePreparedProperties: Bool = false) -> [ConfigurableProperty] {
        let viewName = view.subjectTypeName
        let handlers: [ConfigPropertiesHandlable] = viewInheritances(view).compactMap {
            if $0 == viewName, excludePreparedProperties {
                return nil
            }

            return self.handlers[$0]
        }

        guard let referenceView = handlers.first?.preparedDefaultReferenceView() else {
            return []
        }

        return handlers.flatMap {
            $0.properties(defaultReferenceView: referenceView)
        }
    }
    
    private func viewInheritances<V>(_ view: V) -> [String] where V: UIView {
        var mirror: Mirror? = Mirror(reflecting: view)
        var names: [String] = []
        while let viewMirror = mirror {
            names.append(viewMirror.subjectTypeName)
            if viewMirror.subjectTypeName == "UIView" {
                break
            }
            mirror = viewMirror.superclassMirror
        }
        return names
    }
}

protocol ConfigPropertiesHandlable {
    func properties<RV: UIView>(defaultReferenceView: RV?) -> [ConfigurableProperty]
    func preparedDefaultReferenceView<RV: UIView>() -> RV?
}

struct ConfigPropertiesHandler<V: UIView>: ConfigPropertiesHandlable {
    private let defaultReferendeView: () -> V
    private let propertiesHandler: (V) -> [ConfigurableProperty]
    
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
    var subjectTypeName: String {
        Mirror(reflecting: self).subjectTypeName
    }
}
