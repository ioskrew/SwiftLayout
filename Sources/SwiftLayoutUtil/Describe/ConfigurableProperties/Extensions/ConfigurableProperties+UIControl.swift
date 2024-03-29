import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUIControl() {
        regist(
            UIControl.self,
            defaultReferenceView: UIControl(),
            propertiesHandler: uiControlDefaultConfigurableProperties
        )
    }
    
    private func uiControlDefaultConfigurableProperties(defaultReferenceView view: UIControl) -> [ConfigurableProperty] {
        var configurableProperties: [ConfigurableProperty] = [
            .property(keypath: \.contentHorizontalAlignment, defaultReferenceView: view) { "$0.contentHorizontalAlignment = \($0.configuration)"},
            .property(keypath: \.contentVerticalAlignment, defaultReferenceView: view) { "$0.contentVerticalAlignment = \($0.configuration)"},
            .property(keypath: \.isEnabled, defaultReferenceView: view) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: view) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.isSelected, defaultReferenceView: view) { "$0.isSelected = \($0)" },
        ]

        if #available(iOS 14.0, *) {
            configurableProperties.append(contentsOf: [
                .property(keypath: \.showsMenuAsPrimaryAction, defaultReferenceView: view) { "$0.showsMenuAsPrimaryAction = \($0)"},
            ])
        }

        if #available(iOS 15.0, *) {
            configurableProperties.append(contentsOf: [
                .property(keypath: \.toolTip, defaultReferenceView: view) {"$0.toolTip = \($0.configuration)"},
            ])
        }

        return configurableProperties
    }
}
