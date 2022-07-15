//
//  UIAccessibilityTraits+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//
import UIKit

extension UIAccessibilityTraits {
    var configurationName: String {
        var names: [String] = []

        if self.contains(.button) { names.append(".button")}
        if self.contains(.link) { names.append(".link")}
        if self.contains(.image) { names.append(".image")}
        if self.contains(.searchField) { names.append(".searchField")}
        if self.contains(.keyboardKey) { names.append(".keyboardKey")}
        if self.contains(.staticText) { names.append(".staticText")}
        if self.contains(.header) { names.append(".header")}
        if self.contains(.tabBar) { names.append(".tabBar")}
        if self.contains(.summaryElement) { names.append(".summaryElement")}
        if self.contains(.selected) { names.append(".selected")}
        if self.contains(.notEnabled) { names.append(".notEnabled")}
        if self.contains(.adjustable) { names.append(".adjustable")}
        if self.contains(.allowsDirectInteraction) { names.append(".allowsDirectInteraction")}
        if self.contains(.updatesFrequently) { names.append(".updatesFrequently")}
        if self.contains(.causesPageTurn) { names.append(".causesPageTurn")}
        if self.contains(.playsSound) { names.append(".playsSound")}
        if self.contains(.startsMediaSession) { names.append(".startsMediaSession")}

        return "[\(names.joined(separator: ", "))]"
    }
}
