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

extension ConfigurableProperty {
    public static func property<View: UIView, Value: Equatable>(
        keypath: KeyPath<View, Value>,
        defualtReferenceView: View,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return property(
            keypath: keypath,
            defualtValue: defualtReferenceView[keyPath: keypath],
            describer: describer
        )
    }

    public static func property<View: UIView, Value: Equatable>(
        keypath: KeyPath<View, Value>,
        defualtValue: Value,
        describer: @escaping (Value) -> String
    ) -> ConfigurableProperty {
        return ConfigurableProperty(
            configurator: ConfigurablePropertyImp(
                keypath: keypath,
                defualtValue: defualtValue,
                describer: describer
            )
        )
    }

    public static func defaultConfigurablePropertys<View: UIView>(view: View) -> [ConfigurableProperty] {
        if view is UILabel {
            let defualtReferenceView = UILabel()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiLabelDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        } else if view is UIButton {
            let defualtReferenceView = UIButton()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiControlDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiButtonDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        }  else if view is UIImageView {
            let defualtReferenceView = UIImageView()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        } else if view is UIStackView {
            let defualtReferenceView = UIStackView()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiStackViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        } else if view is UIControl {
            let defualtReferenceView = UIControl()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                uiControlDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        } else {
            let defualtReferenceView = UIView()
            return [
                uiViewDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView),
                accessibilityDefaultConfigurablePropertys(defualtReferenceView: defualtReferenceView)
            ].flatMap { $0 }
        }
    }
}

extension ConfigurableProperty {
    private static func accessibilityDefaultConfigurablePropertys(defualtReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.isAccessibilityElement, defualtReferenceView: view) { "$0.isAccessibilityElement = \($0)"},
            .property(keypath: \.accessibilityLabel, defualtReferenceView: view) { "$0.accessibilityLabel = \($0.configurationName)"},
            .property(keypath: \.accessibilityHint, defualtReferenceView: view) { "$0.accessibilityHint = \($0.configurationName)"},
            .property(keypath: \.accessibilityIdentifier, defualtReferenceView: view) { "$0.accessibilityIdentifier = \($0.configurationName)"},
            .property(keypath: \.accessibilityTraits, defualtReferenceView: view) { "$0.accessibilityIdentifier = \($0.configurationName)"},
        ]
    }

    private static func uiViewDefaultConfigurablePropertys(defualtReferenceView view: UIView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.contentMode, defualtReferenceView: view) { "$0.contentMode = \($0.configurationName)"},
            .property(keypath: \.semanticContentAttribute, defualtReferenceView: view) { "$0.semanticContentAttribute = \($0.configurationName)"},
            .property(keypath: \.tag, defualtReferenceView: view) { "$0.tag = \($0)" },
            .property(keypath: \.isUserInteractionEnabled, defualtReferenceView: view) { "$0.isUserInteractionEnabled = \($0)"},
            .property(keypath: \.isMultipleTouchEnabled, defualtReferenceView: view) { "$0.isMultipleTouchEnabled = \($0)"},
            .property(keypath: \.alpha, defualtReferenceView: view) { "$0.alpha = \($0)" },
            .property(keypath: \.backgroundColor, defualtReferenceView: view) { "$0.backgroundColor = \(String(describing: $0))" },
            .property(keypath: \.tintColor, defualtReferenceView: view) { "$0.tintColor = \(String(describing: $0))" },
            .property(keypath: \.isOpaque, defualtReferenceView: view) { "$0.isOpaque = \($0)" },
            .property(keypath: \.isHidden, defualtReferenceView: view) { "$0.isHidden = \($0)" },
            .property(keypath: \.clearsContextBeforeDrawing, defualtReferenceView: view) { "$0.clearsContextBeforeDrawing = \($0)" },
            .property(keypath: \.clipsToBounds, defualtReferenceView: view) { "$0.clipsToBounds = \($0)" },
            .property(keypath: \.autoresizesSubviews, defualtReferenceView: view) { "$0.autoresizesSubviews = \($0)" },
        ]
    }

    private static func uiControlDefaultConfigurablePropertys(defualtReferenceView view: UIControl) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = [
            .property(keypath: \.contentHorizontalAlignment, defualtReferenceView: view) { "$0.contentHorizontalAlignment = \($0.configurationName)"},
            .property(keypath: \.contentVerticalAlignment, defualtReferenceView: view) { "$0.contentVerticalAlignment = \($0.configurationName)"},
            .property(keypath: \.isSelected, defualtReferenceView: view) { "$0.isSelected = \($0)" },
            .property(keypath: \.isEnabled, defualtReferenceView: view) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defualtReferenceView: view) { "$0.isHighlighted = \($0)" },
        ]

        if #available(iOS 14.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.showsMenuAsPrimaryAction, defualtReferenceView: view) { "$0.showsMenuAsPrimaryAction = \($0)"},
            ])
        }

        if #available(iOS 15.0, *) {
            configurablePropertys.append(contentsOf: [
                .property(keypath: \.toolTip, defualtReferenceView: view) {"$0.toolTip = \($0.configurationName)"},
            ])
        }

        return configurablePropertys
    }

    private static func uiLabelDefaultConfigurablePropertys(defualtReferenceView label: UILabel) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.text, defualtReferenceView: label) { "$0.text = \($0.configurationName)"},
            .property(keypath: \.textColor, defualtReferenceView: label) { "$0.textColor = \(String(describing: $0))" },
            .property(keypath: \.font, defualtReferenceView: label) { "$0.font = \(String(describing: $0))" },
            .property(keypath: \.adjustsFontForContentSizeCategory, defualtReferenceView: label) { "$0.adjustsFontForContentSizeCategory = \($0)" },
            .property(keypath: \.textAlignment, defualtReferenceView: label) { "$0.textAlignment = \($0.configurationName)" },
            .property(keypath: \.numberOfLines, defualtReferenceView: label) { "$0.numberOfLines = \($0)" },
            .property(keypath: \.isEnabled, defualtReferenceView: label) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defualtReferenceView: label) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.showsExpansionTextWhenTruncated, defualtReferenceView: label) { "$0.showsExpansionTextWhenTruncated = \($0)" },
            .property(keypath: \.baselineAdjustment, defualtReferenceView: label) { "$0.baselineAdjustment = \($0.configurationName)" },
            .property(keypath: \.lineBreakMode, defualtReferenceView: label) { "$0.lineBreakMode = .\($0.configurationName)" },
            .property(keypath: \.adjustsFontSizeToFitWidth, defualtReferenceView: label) { "$0.adjustsFontSizeToFitWidth = \($0)" },
            .property(keypath: \.minimumScaleFactor, defualtReferenceView: label) { "$0.minimumScaleFactor = \($0)" },
            .property(keypath: \.allowsDefaultTighteningForTruncation, defualtReferenceView: label) { "$0.allowsDefaultTighteningForTruncation = \($0)" },
            .property(keypath: \.highlightedTextColor, defualtReferenceView: label) { "$0.highlightedTextColor = \(String(describing: $0))" },
            .property(keypath: \.shadowColor, defualtReferenceView: label) { "$0.shadowColor = \(String(describing: $0))" },
            .property(keypath: \.shadowOffset, defualtReferenceView: label) { "$0.shadowOffset = CGSize(width: \($0.width), height: \($0.height))" },
        ]
    }

    private static func uiButtonDefaultConfigurablePropertys(defualtReferenceView button: UIButton) -> [ConfigurableProperty] {
        // TODO
        return []
    }

    private static func uiImageViewDefaultConfigurablePropertys(defualtReferenceView imageView: UIImageView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.image, defualtReferenceView: imageView) { "$0.image = \(String(describing: $0))"},
            .property(keypath: \.highlightedImage, defualtReferenceView: imageView) { "$0.highlightedImage = \(String(describing: $0))"},
            .property(keypath: \.isHighlighted, defualtReferenceView: imageView) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.adjustsImageSizeForAccessibilityContentSizeCategory, defualtReferenceView: imageView) { "$0.adjustsImageSizeForAccessibilityContentSizeCategory = \($0)" },
        ]
    }

    private static func uiStackViewDefaultConfigurablePropertys(defualtReferenceView stackView: UIStackView) -> [ConfigurableProperty] {
        // TODO
        return []
    }
}
