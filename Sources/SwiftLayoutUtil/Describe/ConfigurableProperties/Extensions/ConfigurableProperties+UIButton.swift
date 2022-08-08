import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUIButton() {
        regist(
            UIButton.self,
            defaultReferenceView: UIButton(),
            propertiesHandler: uiButtonDefaultConfigurableProperties
        )
    }
    
    private func uiButtonDefaultConfigurableProperties(defaultReferenceView button: UIButton) -> [ConfigurableProperty] {
        var configurableProperties: [ConfigurableProperty] = [
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
            configurableProperties.append(contentsOf: [
                .property(keypath: \.isPointerInteractionEnabled, defaultReferenceView: button) { "$0.isPointerInteractionEnabled = \($0)" },
            ])
        }

        if #available(iOS 14.0, *) {
            configurableProperties.append(contentsOf: [
                .property(keypath: \.showsMenuAsPrimaryAction, defaultReferenceView: button) { "$0.showsMenuAsPrimaryAction = \($0)" },
                .property(keypath: \.role, defaultReferenceView: button) { "$0.role = \($0.configuration)" },
            ])
        }

        if #available(iOS 15.0, *) {
            configurableProperties.append(contentsOf: [
                .property(keypath: \.changesSelectionAsPrimaryAction, defaultReferenceView: button) { "$0.changesSelectionAsPrimaryAction = \($0)" },
                .property(keypath: \.isHeld, defaultReferenceView: button) { "$0.isHeld = \($0)" },
                .property(keypath: \.isHovered, defaultReferenceView: button) { "$0.isHovered = \($0)" },
            ])
        }

        return configurableProperties
    }
}
