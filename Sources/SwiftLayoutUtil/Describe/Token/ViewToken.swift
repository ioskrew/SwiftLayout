//
//  ViewToken.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import UIKit

struct ViewToken {
    private init(superviewTag: String?, viewTag: String, subviews: [ViewToken], configuration: [String]) {
        self.superviewTag = superviewTag
        self.viewTag = viewTag
        self.subviews = subviews
        self.configuration = configuration
    }
    
    let superviewTag: String?
    let viewTag: String
    let subviews: [ViewToken]
    let configuration: [String]
    
    enum Parser {
        static func from(_ view: UIView, viewTags tags: ViewTags, options: ViewPrinter.PrintOptions) -> ViewToken? {
            let superviewTag = tags.tag(object: view.superview, options: options)
            let configuration = Self.configuration(view, options: options)
            if let viewTag = tags.tag(object: view, options: options) {
                return ViewToken(
                    superviewTag: superviewTag,
                    viewTag: viewTag,
                    subviews: view.subviews.compactMap {
                        Parser.from($0, viewTags: tags, options: options)
                    },
                    configuration: configuration
                )
            } else {
                return nil
            }
        }

        private static func configuration(_ view: UIView, options: ViewPrinter.PrintOptions) -> [String] {
            guard options.contains(.withViewConfig) else {
                return []
            }

            let configurableProperties: [ConfigurableProperty]
            if let printable = view as? CustomConfigurableProperties {
                configurableProperties = ConfigurableProperties.default.configurableProperties(view: view, excludePreparedProperties: true) + printable.configurableProperties
            } else {
                configurableProperties = ConfigurableProperties.default.configurableProperties(view: view)
            }

            return configurableProperties.compactMap {
                $0.configuration(view: view)
            }
        }
    }
}
