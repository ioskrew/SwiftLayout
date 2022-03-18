//
//  WalletLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import SwiftLayout
import UIKit

struct WalletLayout {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().config {
            $0.backgroundColor = .systemBrown
        }.identifying("walletView").anchors {
            Anchors(.top).equalTo("headerView", attribute: .bottom)
            Anchors(.leading, .trailing).equalTo(superview.safeAreaLayoutGuide)
            Anchors(.height).equalTo(constant: 190.0)
        }.sublayout {
            UIView().identifying("walletHeaderView").anchors {
                Anchors(.top, .leading, .trailing)
                Anchors(.height).equalTo(constant: 60.0)
            }.sublayout {
                UILabel().identifying("walletHeaderTitle").config {
                    $0.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
                    $0.text = "Wallet"
                    $0.textColor = .black
                }.anchors {
                    Anchors(.leading).equalTo(constant: 16.0)
                    Anchors(.centerY)
                    Anchors(.height).equalTo(constant: 40.0)
                }

                UIImageView().identifying("walletHeaderTitleArrow").config {
                    $0.tintColor = .separator
                    $0.image = UIImage(systemName: "chevron.right")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.leading).equalTo("walletHeaderTitle", attribute: .trailing)
                    Anchors(.centerY).equalTo("walletHeaderTitle")
                    Anchors(.height, .width).equalTo(constant: 20.0)
                }

                UIButton().identifying("walletHeaderCertificationButton").config {
                    $0.tintColor = .black
                    $0.setTitleColor(.black, for: .normal)
                    $0.setImage(UIImage(systemName: "lock.shield"), for: .normal)
                    $0.setTitle("Certification", for: .normal)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
                }.anchors {
                    Anchors(.centerY)
                    Anchors.size(CGSize(width: 135, height: 31))
                }

                UIView().config {
                    $0.alpha = 0.5
                    $0.backgroundColor = .separator
                }.identifying("walletHeaderButtonSeparator").anchors {
                    Anchors(.leading).equalTo("walletHeaderCertificationButton", attribute: .trailing, constant: 3.0)
                    Anchors(.centerY)
                    Anchors(.height).equalTo(constant: 15.0)
                    Anchors(.width).equalTo(constant: 1.0)
                }

                UIButton().identifying("walletHeaderQRCheckinButton").config {
                    $0.tintColor = .black
                    $0.setTitleColor(.black, for: .normal)
                    $0.setImage(UIImage(systemName: "qrcode"), for: .normal)
                    $0.setTitle("QR Check in", for: .normal)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("walletHeaderButtonSeparator", attribute: .trailing, constant: 3.0)
                    Anchors(.trailing).equalTo(constant: -8.0)
                    Anchors.size(CGSize(width: 130, height: 31))
                }
            }

            UIView().config {
                $0.backgroundColor = .white
            }.identifying("walletNoticeView").anchors {
                Anchors(.centerX)
                Anchors(.width).equalTo("walletView", constant: -32.0)
                Anchors(.top).equalTo("walletHeaderView", attribute: .bottom)
                Anchors(.height).equalTo(constant: 40.0)
            }.sublayout {
                UIImageView().identifying("walletNoticeIcon").config {
                    $0.tintColor = .black
                    $0.image = UIImage(systemName: "qrcode")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(constant: 10.0)
                    Anchors(.height, .width).equalTo(constant: 20.0)
                }
                
                UILabel().identifying("walletNoticeTitle").config {
                    $0.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
                    $0.text = "Notice"
                    $0.textColor = .black
                }.anchors {
                    Anchors(.leading).equalTo("walletNoticeIcon", attribute: .trailing, constant: 5.0)
                    Anchors(.centerY)
                }
                
                UIImageView().identifying("walletNoticeArrow").config {
                    $0.tintColor = .black
                    $0.image = UIImage(systemName: "chevron.right")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.width, .height).equalTo(constant: 15.0)
                    Anchors(.trailing).equalTo(constant: -10.0)
                }
            }

            UIView().identifying("walletPayView").anchors {
                Anchors(.leading, .trailing, .bottom)
                Anchors(.top).equalTo("walletNoticeView", attribute: .bottom, constant: 15.0)
            }.sublayout {
                GroupLayout {
                    UIImageView().identifying("walletPayIcon").config {
                        $0.tintColor = .black
                        $0.image = UIImage(systemName: "applelogo")
                        $0.contentMode = .scaleAspectFit
                    }.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.centerY).equalTo("walletPayTitle")
                        Anchors(.width, .height).equalTo(constant: 15.0)
                    }
                    
                    UILabel().identifying("walletPayTitle").config {

                        $0.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
                        $0.text = "pay"
                        $0.textColor = .black
                    }.anchors {
                        Anchors(.top)
                        Anchors(.leading).equalTo("walletPayIcon", attribute: .trailing, constant: 2.0)
                    }
                    
                    UILabel().identifying("walletPayBalance").config {

                        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
                        $0.text = "$ 235,711.13"
                        $0.textColor = .black
                    }.anchors {
                        Anchors(.centerY).equalTo("walletPayTitle")
                        Anchors(.trailing).equalTo(constant: -16.0)
                    }
                }

                GroupLayout {
                    UIButton().identifying("walletPayTransferButton").config {
                        $0.tintColor = .black
                        $0.setTitleColor(.black, for: .normal)
                        $0.setTitle("transfer", for: .normal)
                        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
                    }.anchors {
                        Anchors(.leading).equalTo(constant: 6.0)
                        Anchors(.top).equalTo("walletPayTitle", attribute: .bottom, constant: 10.0)
                        Anchors.size(CGSize(width: 75, height: 31))
                    }

                    UIView().config{
                        $0.backgroundColor = .separator
                    }.identifying("walletPayButtonSeparator0").anchors {
                        Anchors(.leading).equalTo("walletPayTransferButton", attribute: .trailing)
                        Anchors(.centerY).equalTo("walletPayTransferButton")
                        Anchors(.height).equalTo(constant: 15.0)
                        Anchors(.width).equalTo(constant: 1.0)
                    }

                    UIButton().identifying("walletPayPaymentButton").config {
                        $0.tintColor = .black
                        $0.setTitleColor(.black, for: .normal)
                        $0.setTitle("payment", for: .normal)
                        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
                    }.anchors {
                        Anchors(.centerY).equalTo("walletPayTransferButton")
                        Anchors(.leading).equalTo("walletPayButtonSeparator0", attribute: .trailing)
                        Anchors.size(CGSize(width: 80, height: 31))
                    }

                    UIView().config{
                        $0.backgroundColor = .separator
                    }.identifying("walletPayButtonSeparator1").anchors {
                        Anchors(.centerY).equalTo("walletPayTransferButton")
                        Anchors(.leading).equalTo("walletPayPaymentButton", attribute: .trailing)
                        Anchors(.width).equalTo(constant: 1.0)
                        Anchors(.height).equalTo(constant: 15.0)
                    }

                    UIButton().identifying("walletPayAssetsButton").config {
                        $0.tintColor = .black
                        $0.setTitleColor(.black, for: .normal)
                        $0.setTitle("assets", for: .normal)
                        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
                    }.anchors {
                        Anchors(.leading).equalTo("walletPayButtonSeparator1", attribute: .trailing)
                        Anchors(.centerY).equalTo("walletPayPaymentButton")
                        Anchors.size(CGSize(width: 66, height: 31))
                    }

                    UIButton().identifying("walletPayPurchasesButton").config {
                        $0.tintColor = .black
                        $0.setTitleColor(.black, for: .normal)
                        $0.setImage(UIImage(systemName: "cart"), for: .normal)
                        $0.setTitle(" Purchases", for: .normal)
                        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
                    }.anchors {
                        Anchors(.centerY).equalTo("walletPayTransferButton")
                        Anchors(.trailing).equalTo(constant: -5.0)
                        Anchors.size(CGSize(width: 130, height: 32))
                    }
                }
            }
        }
    }
}
