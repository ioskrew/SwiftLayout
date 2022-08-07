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
        regist(UIView.self, propertiesHandler: uiViewDefaultConfigurablePropertys)
        regist(UILabel.self, propertiesHandler: uiLabelDefaultConfigurablePropertys)
        regist(UIControl.self, propertiesHandler: uiControlDefaultConfigurablePropertys)
        regist(UIButton.self, propertiesHandler: uiButtonDefaultConfigurablePropertys)
        regist(UIImageView.self, propertiesHandler: uiImageViewDefaultConfigurablePropertys)
        regist(UIStackView.self, propertiesHandler: uiStackViewDefaultConfigurablePropertys)
    }
    
    public func regist<V: UIView>(_ view: V.Type, propertiesHandler: @escaping (V) -> [ConfigurableProperty]) {
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

    func uiViewDefaultConfigurablePropertys(defaultReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.alpha, defaultReferenceView: view) { "$0.alpha = \($0)" },
            .property(keypath: \.autoresizesSubviews, defaultReferenceView: view) { "$0.autoresizesSubviews = \($0)" },
            .property(keypath: \.backgroundColor, defaultReferenceView: view) { "$0.backgroundColor = \($0.configuration)" },
            .property(keypath: \.clearsContextBeforeDrawing, defaultReferenceView: view) { "$0.clearsContextBeforeDrawing = \($0)" },
            .property(keypath: \.clipsToBounds, defaultReferenceView: view) { "$0.clipsToBounds = \($0)" },
            .property(keypath: \.contentMode, defaultReferenceView: view) { "$0.contentMode = \($0.configuration)"},
            .property(keypath: \.isHidden, defaultReferenceView: view) { "$0.isHidden = \($0)" },
            .property(keypath: \.isMultipleTouchEnabled, defaultReferenceView: view) { "$0.isMultipleTouchEnabled = \($0)"},
            .property(keypath: \.isOpaque, defaultReferenceView: view) { "$0.isOpaque = \($0)" },
            .property(keypath: \.isUserInteractionEnabled, defaultReferenceView: view) { "$0.isUserInteractionEnabled = \($0)"},
            .property(keypath: \.semanticContentAttribute, defaultReferenceView: view) { "$0.semanticContentAttribute = \($0.configuration)"},
            .property(keypath: \.tag, defaultReferenceView: view) { "$0.tag = \($0)" },
            .property(keypath: \.tintColor, defaultReferenceView: view) { "$0.tintColor = \($0.configuration)" },
        ]
    }
}

extension ConfigurableProperties {
    private func uiControlDefaultConfigurablePropertys(defaultReferenceView view: UIControl) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = [
            .property(keypath: \.contentHorizontalAlignment, defaultReferenceView: view) { "$0.contentHorizontalAlignment = \($0.configuration)"},
            .property(keypath: \.contentVerticalAlignment, defaultReferenceView: view) { "$0.contentVerticalAlignment = \($0.configuration)"},
            .property(keypath: \.isEnabled, defaultReferenceView: view) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: view) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.isSelected, defaultReferenceView: view) { "$0.isSelected = \($0)" },
        ]

        if #available(iOS 14.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.showsMenuAsPrimaryAction, defaultReferenceView: view) { "$0.showsMenuAsPrimaryAction = \($0)"},
            ])
        }

        if #available(iOS 15.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.toolTip, defaultReferenceView: view) {"$0.toolTip = \($0.configuration)"},
            ])
        }

        return configurablePropertys
    }
}

extension ConfigurableProperties {
    private func uiLabelDefaultConfigurablePropertys(defaultReferenceView label: UILabel) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.adjustsFontForContentSizeCategory, defaultReferenceView: label) { "$0.adjustsFontForContentSizeCategory = \($0)" },
            .property(keypath: \.adjustsFontSizeToFitWidth, defaultReferenceView: label) { "$0.adjustsFontSizeToFitWidth = \($0)" },
            .property(keypath: \.allowsDefaultTighteningForTruncation, defaultReferenceView: label) { "$0.allowsDefaultTighteningForTruncation = \($0)" },
            .property(keypath: \.baselineAdjustment, defaultReferenceView: label) { "$0.baselineAdjustment = \($0.configuration)" },
            .property(keypath: \.font, defaultReferenceView: label) { "$0.font = \($0.configuration)" },
            .property(keypath: \.highlightedTextColor, defaultReferenceView: label) { "$0.highlightedTextColor = \($0.configuration)" },
            .property(keypath: \.isEnabled, defaultReferenceView: label) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: label) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.lineBreakMode, defaultReferenceView: label) { "$0.lineBreakMode = .\($0.configuration)" },
            .property(keypath: \.minimumScaleFactor, defaultReferenceView: label) { "$0.minimumScaleFactor = \($0)" },
            .property(keypath: \.numberOfLines, defaultReferenceView: label) { "$0.numberOfLines = \($0)" },
            .property(keypath: \.shadowColor, defaultReferenceView: label) { "$0.shadowColor = \($0.configuration)" },
            .property(keypath: \.shadowOffset, defaultReferenceView: label) { "$0.shadowOffset = CGSize(width: \($0.width), height: \($0.height))" },
            .property(keypath: \.showsExpansionTextWhenTruncated, defaultReferenceView: label) { "$0.showsExpansionTextWhenTruncated = \($0)" },
            .property(keypath: \.text, defaultReferenceView: label) { "$0.text = \($0.configuration)"},
            .property(keypath: \.textAlignment, defaultReferenceView: label) { "$0.textAlignment = \($0.configuration)" },
            .property(keypath: \.textColor, defaultReferenceView: label) { "$0.textColor = \($0.configuration)" },
        ]
    }
}

extension ConfigurableProperties {
    private func uiButtonDefaultConfigurablePropertys(defaultReferenceView button: UIButton) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = [
            .property(getter: { $0.backgroundImage(for: .application) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .application)" },
            .property(getter: { $0.backgroundImage(for: .disabled) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.backgroundImage(for: .focused) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .focused)" },
            .property(getter: { $0.backgroundImage(for: .highlighted) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.backgroundImage(for: .normal) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .normal)" },
            .property(getter: { $0.backgroundImage(for: .reserved) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.backgroundImage(for: .selected) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .selected)" },
            .property(getter: { $0.image(for: .application) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .application)" },
            .property(getter: { $0.image(for: .disabled) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.image(for: .focused) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .focused)" },
            .property(getter: { $0.image(for: .highlighted) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.image(for: .normal) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .normal)" },
            .property(getter: { $0.image(for: .reserved) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.image(for: .selected) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .selected)" },
            .property(getter: { $0.title(for: .application) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .application)" },
            .property(getter: { $0.title(for: .disabled) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.title(for: .focused) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .focused)" },
            .property(getter: { $0.title(for: .highlighted) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.title(for: .normal) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .normal)" },
            .property(getter: { $0.title(for: .reserved) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.title(for: .selected) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .selected)" },
            .property(getter: { $0.titleColor(for: .application) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .application)" },
            .property(getter: { $0.titleColor(for: .disabled) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.titleColor(for: .focused) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .focused)" },
            .property(getter: { $0.titleColor(for: .highlighted) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.titleColor(for: .normal) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .normal)" },
            .property(getter: { $0.titleColor(for: .reserved) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.titleColor(for: .selected) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .selected)" },
            .property(getter: { $0.titleShadowColor(for: .application) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .application)" },
            .property(getter: { $0.titleShadowColor(for: .disabled) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.titleShadowColor(for: .focused) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .focused)" },
            .property(getter: { $0.titleShadowColor(for: .highlighted) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.titleShadowColor(for: .normal) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .normal)" },
            .property(getter: { $0.titleShadowColor(for: .reserved) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.titleShadowColor(for: .selected) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .selected)" },
            .property(keypath: \.adjustsImageSizeForAccessibilityContentSizeCategory, defaultReferenceView: button) { "$0.adjustsImageSizeForAccessibilityContentSizeCategory = \($0)" },
        ]

        if #available(iOS 13.4, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.isPointerInteractionEnabled, defaultReferenceView: button) { "$0.isPointerInteractionEnabled = \($0)" },
            ])
        }

        if #available(iOS 14.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.showsMenuAsPrimaryAction, defaultReferenceView: button) { "$0.showsMenuAsPrimaryAction = \($0)" },
                .property(keypath: \.role, defaultReferenceView: button) { "$0.role = \($0.configuration)" },
            ])
        }

        if #available(iOS 15.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.changesSelectionAsPrimaryAction, defaultReferenceView: button) { "$0.changesSelectionAsPrimaryAction = \($0)" },
                .property(keypath: \.isHeld, defaultReferenceView: button) { "$0.isHeld = \($0)" },
                .property(keypath: \.isHovered, defaultReferenceView: button) { "$0.isHovered = \($0)" },
            ])
        }

        return configurablePropertys
    }
}

extension ConfigurableProperties {
    private func uiImageViewDefaultConfigurablePropertys(defaultReferenceView imageView: UIImageView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.adjustsImageSizeForAccessibilityContentSizeCategory, defaultReferenceView: imageView) { "$0.adjustsImageSizeForAccessibilityContentSizeCategory = \($0)" },
            .property(keypath: \.highlightedImage, defaultReferenceView: imageView) { "$0.highlightedImage = \($0.configuration)"},
            .property(keypath: \.image, defaultReferenceView: imageView) { "$0.image = \($0.configuration)"},
            .property(keypath: \.isHighlighted, defaultReferenceView: imageView) { "$0.isHighlighted = \($0)" },
        ]
    }
}

extension ConfigurableProperties {
    private func uiStackViewDefaultConfigurablePropertys(defaultReferenceView stackView: UIStackView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.alignment, defaultReferenceView: stackView) { "$0.alignment = \($0.configuration)"},
            .property(keypath: \.axis, defaultReferenceView: stackView) { "$0.axis = \($0.configuration)"},
            .property(keypath: \.distribution, defaultReferenceView: stackView) { "$0.distribution = \($0.configuration)"},
            .property(keypath: \.isBaselineRelativeArrangement, defaultReferenceView: stackView) { "$0.isBaselineRelativeArrangement = \($0)"},
            .property(keypath: \.spacing, defaultReferenceView: stackView) { "$0.spacing = \($0)"},
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
