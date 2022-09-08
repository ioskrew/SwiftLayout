import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUISwitch() {
        regist(
            UISwitch.self,
            defaultReferenceView: UISwitch(),
            propertiesHandler: uiSwitchDefaultConfigurableProperties
        )
    }
    
    private func uiSwitchDefaultConfigurableProperties(defaultReferenceView uiSwitch: UISwitch) -> [ConfigurableProperty] {
        var configurableProperties: [ConfigurableProperty] = [
            .property(keypath: \.isOn, defaultReferenceView: uiSwitch, describer: { "$0.isOn = \($0)" }),
            .property(keypath: \.onTintColor, defaultReferenceView: uiSwitch, describer: { "$0.onTintColor = \($0.configuration)" }),
            .property(keypath: \.thumbTintColor, defaultReferenceView: uiSwitch, describer: { "$0.thumbTintColor = \($0.configuration)" }),
            .property(keypath: \.onImage, defaultReferenceView: uiSwitch, describer: { "$0.onImage = \($0.configuration)" }),
            .property(keypath: \.offImage, defaultReferenceView: uiSwitch, describer: { "$0.offImage = \($0.configuration)" }),
        ]
        
        if #available(iOS 14.0, *) {
            configurableProperties.append(contentsOf: [
                .property(keypath: \.preferredStyle, defaultReferenceView: uiSwitch, describer: { "$0.preferredStyle = \($0.configuration)" } ),
            ])
            if UIDevice.current.userInterfaceIdiom == .mac {
                configurableProperties.append(.property(keypath: \.preferredStyle, defaultReferenceView: uiSwitch, describer: { "$0.preferredStyle = \($0.configuration)" } ))
            }
        }

        return configurableProperties
    }
}
