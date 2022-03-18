//
//  HeaderView.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

final class HeaderLayout {
    let headerView = UIView().identifying("headerView")
    let headerLabel = UILabel()
    let headerButton0 = UIButton()
    let headerButton1 = UIButton()
    let headerButton2 = UIButton()
    let headerButton3 = UIButton()
    
    func callAsFunction(_ superview: UIView) -> some Layout {
        headerView.anchors {
            Anchors(.top, .leading, .trailing).equalTo(superview.safeAreaLayoutGuide)
            Anchors(.height).equalTo(constant: 60.0)
        }.sublayout {
            headerLabel.config {
                $0.font = UIFont.systemFont(ofSize: 23.0, weight: .semibold)
                $0.text = "Hello SwiftLayout"
                $0.textColor = .label
            }.anchors {
                Anchors(.centerY)
                Anchors(.leading).equalTo(constant: 16.0)
            }
            
            headerButton0.config {
                $0.tintColor = .label
                $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            }.anchors {
                Anchors(.centerY)
                Anchors(.width, .height).equalTo(constant: 40.0)
            }
            
            headerButton1.config {
                $0.tintColor = .label
                $0.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
            }.anchors {
                Anchors(.centerY)
                Anchors(.leading).equalTo(headerButton0, attribute: .trailing, constant: 2.0)
                Anchors(.width, .height).equalTo(constant: 40.0)
            }
            
            headerButton2.config {
                $0.tintColor = .label
                $0.setImage(UIImage(systemName: "music.note"), for: .normal)
            }.anchors {
                Anchors(.centerY)
                Anchors(.leading).equalTo(headerButton1, attribute: .trailing, constant: 2.0)
                Anchors(.height, .width).equalTo(constant: 40.0)
            }
            
            headerButton3.config {
                $0.tintColor = .label
                $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
                $0.contentMode = .scaleAspectFit
            }.anchors {
                Anchors(.centerY)
                Anchors(.leading).equalTo(headerButton2, attribute: .trailing, constant: 2.0)
                Anchors(.height, .width).equalTo(constant: 40.0)
                Anchors(.trailing).equalTo(constant: -8.0)
            }
        }
    }
}
