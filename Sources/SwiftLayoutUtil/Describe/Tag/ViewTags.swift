//
//  ViewTags.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation
import UIKit

struct ViewTags {
    
    static func viewTagsFromView(_ view: UIView, customTags: [AddressDescriptor: String]) -> ViewTags {
        let views = viewsFromView(view)
        let viewTags = [AddressDescriptor: String](uniqueKeysWithValues: views.map({ (AddressDescriptor($0), $0.tagDescription) }))
        return ViewTags(customTags: customTags, viewTags: viewTags)
    }
    
    private static func viewsFromView(_ view: UIView) -> [UIView] {
        var views: [UIView] = [view]
        views.append(contentsOf: view.subviews.flatMap(viewsFromView))
        return views
    }
    
    let customTags: [AddressDescriptor: String]
    private(set) var viewTags: [AddressDescriptor: String]
    
    mutating func updateView<I: UIAccessibilityIdentification>(_ view: I) {
        guard let identifier = view.accessibilityIdentifier else { return }
        self.viewTags[AddressDescriptor(view)] = identifier
    }
    
    func tag(address: AddressDescriptor, options: ViewPrinter.PrintOptions = []) -> String? {
        if let tag = customTags[address] {
            return tag
        } else if let tag = viewTags[address] {
            return tag
        } else {
            return nil
        }
    }
    
    func tag<O: AnyObject>(object: O?, options: ViewPrinter.PrintOptions = []) -> String? {
        guard let object = object else {
            return nil
        }
        return tag(address: AddressDescriptor(object), options: options)
    }
}
