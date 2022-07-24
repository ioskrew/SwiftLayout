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

extension ConfigurableProperty {
    public static func defaultConfigurablePropertys<View: UIView>(view: View) -> [ConfigurableProperty] {
        if view is UILabel {
            let defaultReferenceView = UILabel()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiLabelDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        } else if view is UIButton {
            let defaultReferenceView = UIButton()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiControlDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiButtonDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        }  else if view is UIImageView {
            let defaultReferenceView = UIImageView()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiImageViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        } else if view is UIStackView {
            let defaultReferenceView = UIStackView()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiStackViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        } else if view is UIControl {
            let defaultReferenceView = UIControl()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                uiControlDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        } else {
            let defaultReferenceView = UIView()
            return [
                uiViewDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView),
                accessibilityDefaultConfigurablePropertys(defaultReferenceView: defaultReferenceView)
            ].flatMap { $0 }
        }
    }
}

extension ConfigurableProperty {
    private static func accessibilityDefaultConfigurablePropertys(defaultReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.isAccessibilityElement, defaultReferenceView: view) { "$0.isAccessibilityElement = \($0)"},
            .property(keypath: \.accessibilityLabel, defaultReferenceView: view) { "$0.accessibilityLabel = \($0.configuration)"},
            .property(keypath: \.accessibilityHint, defaultReferenceView: view) { "$0.accessibilityHint = \($0.configuration)"},
            .property(keypath: \.accessibilityIdentifier, defaultReferenceView: view) { "$0.accessibilityIdentifier = \($0.configuration)"},
            .property(keypath: \.accessibilityTraits, defaultReferenceView: view) { "$0.accessibilityTraits = \($0.configuration)"},
        ]
    }

    private static func uiViewDefaultConfigurablePropertys(defaultReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.contentMode, defaultReferenceView: view) { "$0.contentMode = \($0.configuration)"},
            .property(keypath: \.semanticContentAttribute, defaultReferenceView: view) { "$0.semanticContentAttribute = \($0.configuration)"},
            .property(keypath: \.tag, defaultReferenceView: view) { "$0.tag = \($0)" },
            .property(keypath: \.isUserInteractionEnabled, defaultReferenceView: view) { "$0.isUserInteractionEnabled = \($0)"},
            .property(keypath: \.isMultipleTouchEnabled, defaultReferenceView: view) { "$0.isMultipleTouchEnabled = \($0)"},
            .property(keypath: \.alpha, defaultReferenceView: view) { "$0.alpha = \($0)" },
            .property(keypath: \.backgroundColor, defaultReferenceView: view) { "$0.backgroundColor = \($0.configuration)" },
            .property(keypath: \.tintColor, defaultReferenceView: view) { "$0.tintColor = \($0.configuration)" },
            .property(keypath: \.isOpaque, defaultReferenceView: view) { "$0.isOpaque = \($0)" },
            .property(keypath: \.isHidden, defaultReferenceView: view) { "$0.isHidden = \($0)" },
            .property(keypath: \.clearsContextBeforeDrawing, defaultReferenceView: view) { "$0.clearsContextBeforeDrawing = \($0)" },
            .property(keypath: \.clipsToBounds, defaultReferenceView: view) { "$0.clipsToBounds = \($0)" },
            .property(keypath: \.autoresizesSubviews, defaultReferenceView: view) { "$0.autoresizesSubviews = \($0)" },
        ]
    }

    private static func uiControlDefaultConfigurablePropertys(defaultReferenceView view: UIControl) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = [
            .property(keypath: \.contentHorizontalAlignment, defaultReferenceView: view) { "$0.contentHorizontalAlignment = \($0.configuration)"},
            .property(keypath: \.contentVerticalAlignment, defaultReferenceView: view) { "$0.contentVerticalAlignment = \($0.configuration)"},
            .property(keypath: \.isSelected, defaultReferenceView: view) { "$0.isSelected = \($0)" },
            .property(keypath: \.isEnabled, defaultReferenceView: view) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: view) { "$0.isHighlighted = \($0)" },
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

    private static func uiLabelDefaultConfigurablePropertys(defaultReferenceView label: UILabel) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.text, defaultReferenceView: label) { "$0.text = \($0.configuration)"},
            .property(keypath: \.textColor, defaultReferenceView: label) { "$0.textColor = \($0.configuration)" },
            .property(keypath: \.font, defaultReferenceView: label) { "$0.font = \($0.configuration)" },
            .property(keypath: \.adjustsFontForContentSizeCategory, defaultReferenceView: label) { "$0.adjustsFontForContentSizeCategory = \($0)" },
            .property(keypath: \.textAlignment, defaultReferenceView: label) { "$0.textAlignment = \($0.configuration)" },
            .property(keypath: \.numberOfLines, defaultReferenceView: label) { "$0.numberOfLines = \($0)" },
            .property(keypath: \.isEnabled, defaultReferenceView: label) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: label) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.showsExpansionTextWhenTruncated, defaultReferenceView: label) { "$0.showsExpansionTextWhenTruncated = \($0)" },
            .property(keypath: \.baselineAdjustment, defaultReferenceView: label) { "$0.baselineAdjustment = \($0.configuration)" },
            .property(keypath: \.lineBreakMode, defaultReferenceView: label) { "$0.lineBreakMode = .\($0.configuration)" },
            .property(keypath: \.adjustsFontSizeToFitWidth, defaultReferenceView: label) { "$0.adjustsFontSizeToFitWidth = \($0)" },
            .property(keypath: \.minimumScaleFactor, defaultReferenceView: label) { "$0.minimumScaleFactor = \($0)" },
            .property(keypath: \.allowsDefaultTighteningForTruncation, defaultReferenceView: label) { "$0.allowsDefaultTighteningForTruncation = \($0)" },
            .property(keypath: \.highlightedTextColor, defaultReferenceView: label) { "$0.highlightedTextColor = \($0.configuration)" },
            .property(keypath: \.shadowColor, defaultReferenceView: label) { "$0.shadowColor = \($0.configuration)" },
            .property(keypath: \.shadowOffset, defaultReferenceView: label) { "$0.shadowOffset = CGSize(width: \($0.width), height: \($0.height))" },
        ]
    }

    private static func uiButtonDefaultConfigurablePropertys(defaultReferenceView button: UIButton) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = [
            .property(getter: { $0.title(for: .normal) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .normal)" },
            .property(getter: { $0.titleColor(for: .normal) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .normal)" },
            .property(getter: { $0.titleShadowColor(for: .normal) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .normal)" },
            .property(getter: { $0.backgroundImage(for: .normal) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .normal)" },
            .property(getter: { $0.image(for: .normal) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .normal)" },

            .property(getter: { $0.title(for: .highlighted) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.titleColor(for: .highlighted) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.titleShadowColor(for: .highlighted) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.backgroundImage(for: .highlighted) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .highlighted)" },
            .property(getter: { $0.image(for: .highlighted) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .highlighted)" },

            .property(getter: { $0.title(for: .disabled) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.titleColor(for: .disabled) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.titleShadowColor(for: .disabled) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.backgroundImage(for: .disabled) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .disabled)" },
            .property(getter: { $0.image(for: .disabled) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .disabled)" },

            .property(getter: { $0.title(for: .selected) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .selected)" },
            .property(getter: { $0.titleColor(for: .selected) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .selected)" },
            .property(getter: { $0.titleShadowColor(for: .selected) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .selected)" },
            .property(getter: { $0.backgroundImage(for: .selected) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .selected)" },
            .property(getter: { $0.image(for: .selected) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .selected)" },

            .property(getter: { $0.title(for: .focused) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .focused)" },
            .property(getter: { $0.titleColor(for: .focused) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .focused)" },
            .property(getter: { $0.titleShadowColor(for: .focused) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .focused)" },
            .property(getter: { $0.backgroundImage(for: .focused) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .focused)" },
            .property(getter: { $0.image(for: .focused) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .focused)" },

            .property(getter: { $0.title(for: .application) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .application)" },
            .property(getter: { $0.titleColor(for: .application) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .application)" },
            .property(getter: { $0.titleShadowColor(for: .application) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .application)" },
            .property(getter: { $0.backgroundImage(for: .application) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .application)" },
            .property(getter: { $0.image(for: .application) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .application)" },

            .property(getter: { $0.title(for: .reserved) }, defaultReferenceView: button) { "$0.setTitle(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.titleColor(for: .reserved) }, defaultReferenceView: button) { "$0.titleColor(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.titleShadowColor(for: .reserved) }, defaultReferenceView: button) { "$0.titleShadowColor(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.backgroundImage(for: .reserved) }, defaultReferenceView: button) { "$0.backgroundImage(\($0.configuration), for: .reserved)" },
            .property(getter: { $0.image(for: .reserved) }, defaultReferenceView: button) { "$0.setImage(\($0.configuration), for: .reserved)" },

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
                .property(keypath: \.isHovered, defaultReferenceView: button) { "$0.isHovered = \($0)" },
                .property(keypath: \.isHeld, defaultReferenceView: button) { "$0.isHeld = \($0)" },
                .property(keypath: \.changesSelectionAsPrimaryAction, defaultReferenceView: button) { "$0.changesSelectionAsPrimaryAction = \($0)" },
            ])
        }

        return configurablePropertys
    }

    private static func uiImageViewDefaultConfigurablePropertys(defaultReferenceView imageView: UIImageView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.image, defaultReferenceView: imageView) { "$0.image = \($0.configuration)"},
            .property(keypath: \.highlightedImage, defaultReferenceView: imageView) { "$0.highlightedImage = \($0.configuration)"},
            .property(keypath: \.isHighlighted, defaultReferenceView: imageView) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.adjustsImageSizeForAccessibilityContentSizeCategory, defaultReferenceView: imageView) { "$0.adjustsImageSizeForAccessibilityContentSizeCategory = \($0)" },
        ]
    }

    private static func uiStackViewDefaultConfigurablePropertys(defaultReferenceView stackView: UIStackView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.axis, defaultReferenceView: stackView) { "$0.axis = \($0.configuration)"},
            .property(keypath: \.alignment, defaultReferenceView: stackView) { "$0.alignment = \($0.configuration)"},
            .property(keypath: \.distribution, defaultReferenceView: stackView) { "$0.distribution = \($0.configuration)"},
            .property(keypath: \.spacing, defaultReferenceView: stackView) { "$0.spacing = \($0)"},
            .property(keypath: \.isBaselineRelativeArrangement, defaultReferenceView: stackView) { "$0.isBaselineRelativeArrangement = \($0)"},
        ]
    }
}
