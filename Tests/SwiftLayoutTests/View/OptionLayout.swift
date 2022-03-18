//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

struct OptionLayout {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().identifying("optionView").anchors {
            Anchors(.leading, .trailing).equalTo(superview.safeAreaLayoutGuide)
            Anchors(.top).equalTo("NewsView", attribute: .bottom, constant: 8.0)
        }.sublayout {
            UIView().identifying("optionRow0").anchors {
                Anchors(.top, .leading, .trailing)
                Anchors(.height).equalTo(constant: 50.0)
            }.sublayout {
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
                    $0.text = "Option 1"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.leading).equalTo(constant: 16.0)
                    Anchors(.centerY)
                }
                UISwitch().anchors {
                    Anchors(.centerY)
                    Anchors(.trailing).equalTo(constant: -16.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .separator
                }.anchors {
                    Anchors(.leading).equalTo(constant: 16.0)
                    Anchors(.trailing).equalTo(constant: -16.0)
                    Anchors(.bottom)
                    Anchors(.height).equalTo(constant: 1.0)
                }
            }
            UIView().identifying("optionRow1").anchors {
                Anchors(.top).equalTo("optionRow0", attribute: .bottom)
                Anchors(.leading, .trailing)
                Anchors(.height).equalTo(constant: 50.0)
            }.sublayout {
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
                    $0.text = "Option 2"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.leading).equalTo(constant: 16.0)
                    Anchors(.centerY)
                }
                UISwitch().anchors {
                    Anchors(.centerY)
                    Anchors(.trailing).equalTo(constant: -16.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .separator
                }.anchors {
                    Anchors(.leading).equalTo(constant: 16.0)
                    Anchors(.trailing).equalTo(constant: -16.0)
                    Anchors(.bottom)
                    Anchors(.height).equalTo(constant: 1.0)
                }
            }
        }
    }
}
