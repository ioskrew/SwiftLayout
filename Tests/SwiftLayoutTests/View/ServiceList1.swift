//
//  ServiceList1.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

struct ServiceList1 {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().identifying("serviceList1View").anchors {
            Anchors(.top).equalTo("serviceList0View", attribute: .bottom)
            Anchors(.leading, .trailing).equalTo(superview.safeAreaLayoutGuide)
            Anchors(.height).equalTo(constant: 75.0)
        }.sublayout {
            UIView().identifying("serviceItem4").anchors {
                Anchors(.top, .leading, .bottom)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem4Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "envelope")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Mail"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem4Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem4Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem5").anchors {
                Anchors(.leading).equalTo("serviceItem4", attribute: .trailing)
                Anchors(.top, .bottom)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem5Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "calendar")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Calendar"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem5Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem5Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem6").anchors {
                Anchors(.top, .bottom)
                Anchors(.leading).equalTo("serviceItem5", attribute: .trailing)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem6Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "folder")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Folder"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem6Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem6Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem7").anchors {
                Anchors(.top, .bottom, .trailing)
                Anchors(.leading).equalTo("serviceItem6", attribute: .trailing)
            }.sublayout {
                UIImageView().identifying("serviceItem7Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "puzzlepiece")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Puzzle"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem7Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem7Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
        }
    }
}
