//
//  IntroductionLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

struct IntroductionLayout {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().config {
            $0.backgroundColor = .separator
        }.identifying("introductionView").anchors {
            Anchors(.leading).equalTo(superview.safeAreaLayoutGuide, constant: 16.0)
            Anchors(.trailing).equalTo(superview.safeAreaLayoutGuide, constant: -16.0)
            Anchors(.top).equalTo("serviceList1View", attribute: .bottom, constant: 8.0)
            Anchors(.height).equalTo(constant: 80.0)
            
        }.sublayout {
            UIImageView().identifying("introductionImage").config {
                $0.tintColor = .init(red: 240/255, green: 80/255, blue: 58/255, alpha: 1)
                $0.image = UIImage(systemName: "square.stack.3d.down.forward")
                $0.contentMode = .scaleAspectFit
            }.anchors {
                Anchors(.leading).equalTo(constant: 10.0)
                Anchors(.centerY)
                Anchors(.height, .width).equalTo(constant: 70.0)
            }
            
            UILabel().identifying("introductionTitle").config {
                $0.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                $0.text = "Hello SwiftLayout"
                $0.textColor = .label
            }.anchors {
                Anchors(.top).equalTo(constant: 8.0)
                Anchors(.leading).equalTo("introductionImage", attribute: .trailing, constant: 10.0)
                Anchors(.height).equalTo(constant: 24.0)
            }
            
            UILabel().identifying("introductionDescription").config {
                $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                $0.numberOfLines = 0
                $0.text = "SwiftLayout is a DSL library that composes views and creates constraints through a more swifty syntax when using UIKit/AppKit."
                $0.textColor = .label
            }.anchors {
                Anchors(.top).equalTo("introductionTitle", attribute: .bottom, constant: 5.0)
                Anchors(.leading).equalTo("introductionImage", attribute: .trailing, constant: 10.0)
                Anchors(.bottom).equalTo(constant: -8.0)
                Anchors(.trailing).equalTo(constant: -10.0)
            }
        }
    }
}
