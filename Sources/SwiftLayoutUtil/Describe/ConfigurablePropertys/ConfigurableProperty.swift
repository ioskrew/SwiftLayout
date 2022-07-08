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
        ConfigurableProperty(
            configurator: ConfigurablePropertyImp(
                keypath: keypath,
                defualtValue: defualtReferenceView[keyPath: keypath],
                describer: describer
            )
        )
    }

    public static func defaultConfigurablePropertys<View: UIView>(view: View) -> [ConfigurableProperty] {
        var configurablePropertys: [ConfigurableProperty] = Self.uiViewDefaultConfigurablePropertys

        if view is UILabel {
            configurablePropertys.append(contentsOf: uiLabelDefaultConfigurablePropertys)
        }

        return configurablePropertys
    }
}

extension ConfigurableProperty {
    private static var uiViewDefaultConfigurablePropertys: [ConfigurableProperty] {
        let view = UIView()
        return [
            .property(keypath: \.contentMode, defualtReferenceView: view) { "$0.contentMode = .\($0.configurationName)"},
            .property(keypath: \.semanticContentAttribute, defualtReferenceView: view) { "$0.semanticContentAttribute = .\($0.configurationName)"},
            .property(keypath: \.tag, defualtReferenceView: view) { "$0.tag = \($0)" },
            .property(keypath: \.isUserInteractionEnabled, defualtReferenceView: label) { "$0.isUserInteractionEnabled = \($0)"},
            .property(keypath: \.isMultipleTouchEnabled, defualtReferenceView: view) { "$0.isMultipleTouchEnabled = \($0)"},
            .property(keypath: \.alpha, defualtReferenceView: view) { "$0.alpha = \($0)" },
            .property(keypath: \.backgroundColor, defualtReferenceView: label) { "$0.backgroundColor = \(String(describing: $0))" },
            .property(keypath: \.tintColor, defualtReferenceView: view) { "$0.tintColor = \(String(describing: $0))" },
            .property(keypath: \.isOpaque, defualtReferenceView: view) { "$0.isOpaque = \($0)" },
            .property(keypath: \.isHidden, defualtReferenceView: view) { "$0.isHidden = \($0)" },
            .property(keypath: \.clearsContextBeforeDrawing, defualtReferenceView: view) { "$0.clearsContextBeforeDrawing = \($0)" },
            .property(keypath: \.clipsToBounds, defualtReferenceView: view) { "$0.clipsToBounds = \($0)" },
            .property(keypath: \.autoresizesSubviews, defualtReferenceView: view) { "$0.autoresizesSubviews = \($0)" },
        ]
    }

    private static var uiLabelDefaultConfigurablePropertys: [ConfigurableProperty] {
        let label = UILabel()
        return [
            .property(keypath: \.text, defualtReferenceView: label) { "$0.contentMode = .\($0 ?? "nil")"},
            .property(keypath: \.textColor, defualtReferenceView: label) { "$0.textColor = \(String(describing: $0))" },
            .property(keypath: \.font, defualtReferenceView: label) { "$0.font = \(String(describing: $0))" },
            .property(keypath: \.adjustsFontForContentSizeCategory, defualtReferenceView: label) { "$0.adjustsFontForContentSizeCategory = \($0)" },
            .property(keypath: \.textAlignment, defualtReferenceView: label) { "$0.textAlignment = .\($0.configurationName)" },
            .property(keypath: \.numberOfLines, defualtReferenceView: label) { "$0.numberOfLines = \($0)" },
            .property(keypath: \.isEnabled, defualtReferenceView: label) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defualtReferenceView: label) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.showsExpansionTextWhenTruncated, defualtReferenceView: label) { "$0.showsExpansionTextWhenTruncated = \($0)" },
            .property(keypath: \.baselineAdjustment, defualtReferenceView: label) { "$0.baselineAdjustment = .\($0.configurationName)" },
            .property(keypath: \.lineBreakMode, defualtReferenceView: label) { "$0.lineBreakMode = .\($0.configurationName)" },
            .property(keypath: \.adjustsFontSizeToFitWidth, defualtReferenceView: label) { "$0.adjustsFontSizeToFitWidth = \($0)" },
            .property(keypath: \.minimumScaleFactor, defualtReferenceView: label) { "$0.minimumScaleFactor = \($0)" },
            .property(keypath: \.allowsDefaultTighteningForTruncation, defualtReferenceView: label) { "$0.allowsDefaultTighteningForTruncation = \($0)" },
            .property(keypath: \.highlightedTextColor, defualtReferenceView: label) { "$0.highlightedTextColor = \(String(describing: $0))" },
            .property(keypath: \.shadowColor, defualtReferenceView: label) { "$0.shadowColor = \(String(describing: $0))" },
            .property(keypath: \.shadowOffset, defualtReferenceView: label) { "$0.shadowOffset = CGSize(width: \($0.width), height: \($0.height))" },
        ]
    }
}
