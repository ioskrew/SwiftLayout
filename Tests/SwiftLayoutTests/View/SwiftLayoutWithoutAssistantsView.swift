//
//  SwiftLayoutWithoutAssistantsView.swift
//
//
//  Created by aiden_h on 2022/03/17.
//

import UIKit
import SwiftLayout

class SwiftLayoutWithoutAssistantsView: UIView, Layoutable {
    
    var layout: some Layout {
        self.backgroundColor = .systemBackground

        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 23.0, weight: .semibold)
        headerLabel.text = "Hello SwiftLayout"
        headerLabel.textColor = .label
        let headerButton0 = UIButton()
        headerButton0.tintColor = .label
        headerButton0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        let headerButton1 = UIButton()
        headerButton1.tintColor = .label
        headerButton1.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        let headerButton2 = UIButton()
        headerButton2.tintColor = .label
        headerButton2.setImage(UIImage(systemName: "music.note"), for: .normal)
        let headerButton3 = UIButton()
        headerButton3.tintColor = .label
        headerButton3.setImage(UIImage(systemName: "gearshape"), for: .normal)
        headerButton3.contentMode = .scaleAspectFit

        let walletView = UIView()
        walletView.backgroundColor = .systemBrown
        let walletHeaderView = UIView()
        let walletHeaderTitle = UILabel()
        walletHeaderTitle.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
        walletHeaderTitle.text = "Wallet"
        walletHeaderTitle.textColor = .black
        let walletHeaderTitleArrow = UIImageView()
        walletHeaderTitleArrow.tintColor = .separator
        walletHeaderTitleArrow.image = UIImage(systemName: "chevron.right")
        walletHeaderTitleArrow.contentMode = .scaleAspectFit
        let walletHeaderCertificationButton = UIButton()
        walletHeaderCertificationButton.tintColor = .black
        walletHeaderCertificationButton.setTitleColor(.black, for: .normal)
        walletHeaderCertificationButton.setImage(UIImage(systemName: "lock.shield"), for: .normal)
        walletHeaderCertificationButton.setTitle("Certification", for: .normal)
        walletHeaderCertificationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let walletHeaderButtonSeparator = UIView()
        walletHeaderButtonSeparator.alpha = 0.5
        walletHeaderButtonSeparator.backgroundColor = .separator
        let walletHeaderQRCheckinButton = UIButton()
        walletHeaderQRCheckinButton.tintColor = .black
        walletHeaderQRCheckinButton.setTitleColor(.black, for: .normal)
        walletHeaderQRCheckinButton.setImage(UIImage(systemName: "qrcode"), for: .normal)
        walletHeaderQRCheckinButton.setTitle("QR Check in", for: .normal)
        walletHeaderQRCheckinButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let walletNoticeView = UIView()
        walletNoticeView.backgroundColor = .white
        let walletNoticeIcon = UIImageView()
        walletNoticeIcon.tintColor = .black
        walletNoticeIcon.image = UIImage(systemName: "qrcode")
        walletNoticeIcon.contentMode = .scaleAspectFit
        let walletNoticeTitle = UILabel()
        walletNoticeTitle.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        walletNoticeTitle.text = "Notice"
        walletNoticeTitle.textColor = .black
        let walletNoticeArrow = UIImageView()
        walletNoticeArrow.tintColor = .black
        walletNoticeArrow.image = UIImage(systemName: "chevron.right")
        walletNoticeArrow.contentMode = .scaleAspectFit
        let walletPayView = UIView()
        let walletPayIcon = UIImageView()
        walletPayIcon.tintColor = .black
        walletPayIcon.image = UIImage(systemName: "applelogo")
        walletPayIcon.contentMode = .scaleAspectFit
        let walletPayTitle = UILabel()
        walletPayTitle.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        walletPayTitle.text = "pay"
        walletPayTitle.textColor = .black
        let walletPayBalance = UILabel()
        walletPayBalance.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        walletPayBalance.text = "$ 235,711.13"
        walletPayBalance.textColor = .black
        let walletPayTransferButton = UIButton()
        walletPayTransferButton.tintColor = .black
        walletPayTransferButton.setTitleColor(.black, for: .normal)
        walletPayTransferButton.setTitle("transfer", for: .normal)
        walletPayTransferButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        let walletPayButtonSeparator0 = UIView()
        walletPayButtonSeparator0.backgroundColor = .separator
        let walletPayPaymentButton = UIButton()
        walletPayPaymentButton.tintColor = .black
        walletPayPaymentButton.setTitleColor(.black, for: .normal)
        walletPayPaymentButton.setTitle("payment", for: .normal)
        walletPayPaymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        let walletPayButtonSeparator1 = UIView()
        walletPayButtonSeparator1.backgroundColor = .separator
        let walletPayAssetsButton = UIButton()
        walletPayAssetsButton.tintColor = .black
        walletPayAssetsButton.setTitleColor(.black, for: .normal)
        walletPayAssetsButton.setTitle("assets", for: .normal)
        walletPayAssetsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        let walletPayPurchasesButton = UIButton()
        walletPayPurchasesButton.tintColor = .black
        walletPayPurchasesButton.setTitleColor(.black, for: .normal)
        walletPayPurchasesButton.setImage(UIImage(systemName: "cart"), for: .normal)
        walletPayPurchasesButton.setTitle(" Purchases", for: .normal)
        walletPayPurchasesButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)

        let serviceList0View = UIView()
        let serviceItem0 = UIView()
        let serviceItem0Image = UIImageView()
        serviceItem0Image.tintColor = .label
        serviceItem0Image.image = UIImage(systemName: "envelope")
        serviceItem0Image.contentMode = .scaleAspectFit
        let tmpa668d0UILabel = UILabel()
        tmpa668d0UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa668d0UILabel.text = "Mail"
        tmpa668d0UILabel.textColor = .label
        let tmpa2fb30UIView = UIView()
        tmpa2fb30UIView.backgroundColor = .systemRed
        let serviceItem1 = UIView()
        let serviceItem1Image = UIImageView()
        serviceItem1Image.tintColor = .label
        serviceItem1Image.image = UIImage(systemName: "calendar")
        serviceItem1Image.contentMode = .scaleAspectFit
        let tmpa67f30UILabel = UILabel()
        tmpa67f30UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa67f30UILabel.text = "Calendar"
        tmpa67f30UILabel.textColor = .label
        let tmpa68210UIView = UIView()
        tmpa68210UIView.backgroundColor = .systemRed
        let serviceItem2 = UIView()
        let serviceItem2Image = UIImageView()
        serviceItem2Image.tintColor = .label
        serviceItem2Image.image = UIImage(systemName: "folder")
        serviceItem2Image.contentMode = .scaleAspectFit
        let tmpa6a080UILabel = UILabel()
        tmpa6a080UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6a080UILabel.text = "Folder"
        tmpa6a080UILabel.textColor = .label
        let tmpa6a360UIView = UIView()
        tmpa6a360UIView.backgroundColor = .systemRed
        let serviceItem3 = UIView()
        let serviceItem3Image = UIImageView()
        serviceItem3Image.tintColor = .label
        serviceItem3Image.image = UIImage(systemName: "puzzlepiece")
        serviceItem3Image.contentMode = .scaleAspectFit
        let tmpa6dfa0UILabel = UILabel()
        tmpa6dfa0UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6dfa0UILabel.text = "Puzzle"
        tmpa6dfa0UILabel.textColor = .label
        let tmpa4e8c0UIView = UIView()
        tmpa4e8c0UIView.backgroundColor = .systemRed

        let serviceList1View = UIView()
        let serviceItem4 = UIView()
        let serviceItem4Image = UIImageView()
        serviceItem4Image.tintColor = .label
        serviceItem4Image.image = UIImage(systemName: "envelope")
        serviceItem4Image.contentMode = .scaleAspectFit
        let tmpa6e290UILabel = UILabel()
        tmpa6e290UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6e290UILabel.text = "Mail"
        tmpa6e290UILabel.textColor = .label
        let tmpa31380UIView = UIView()
        tmpa31380UIView.backgroundColor = .systemRed
        let serviceItem5 = UIView()
        let serviceItem5Image = UIImageView()
        serviceItem5Image.tintColor = .label
        serviceItem5Image.image = UIImage(systemName: "calendar")
        serviceItem5Image.contentMode = .scaleAspectFit
        let tmpa6e570UILabel = UILabel()
        tmpa6e570UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6e570UILabel.text = "Calendar"
        tmpa6e570UILabel.textColor = .label
        let tmpa342e0UIView = UIView()
        tmpa342e0UIView.backgroundColor = .systemRed
        let serviceItem6 = UIView()
        let serviceItem6Image = UIImageView()
        serviceItem6Image.tintColor = .label
        serviceItem6Image.image = UIImage(systemName: "folder")
        serviceItem6Image.contentMode = .scaleAspectFit
        let tmpa6e850UILabel = UILabel()
        tmpa6e850UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6e850UILabel.text = "Folder"
        tmpa6e850UILabel.textColor = .label
        let tmpa517f0UIView = UIView()
        tmpa517f0UIView.backgroundColor = .systemRed
        let serviceItem7 = UIView()
        let serviceItem7Image = UIImageView()
        serviceItem7Image.tintColor = .label
        serviceItem7Image.image = UIImage(systemName: "puzzlepiece")
        serviceItem7Image.contentMode = .scaleAspectFit
        let tmpa6eb30UILabel = UILabel()
        tmpa6eb30UILabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        tmpa6eb30UILabel.text = "Puzzle"
        tmpa6eb30UILabel.textColor = .label
        let tmpa581e0UIView = UIView()
        tmpa581e0UIView.backgroundColor = .systemRed

        let introductionView = UIView()
        introductionView.backgroundColor = .separator
        let introductionImage = UIImageView()
        introductionImage.tintColor = .init(red: 240/255, green: 80/255, blue: 58/255, alpha: 1)
        introductionImage.image = UIImage(systemName: "square.stack.3d.down.forward")
        introductionImage.contentMode = .scaleAspectFit
        let introductionTitle = UILabel()
        introductionTitle.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        introductionTitle.text = "Hello SwiftLayout"
        introductionTitle.textColor = .label
        let introductionDescription = UILabel()
        introductionDescription.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        introductionDescription.numberOfLines = 0
        introductionDescription.text = "SwiftLayout is a DSL library that composes views and creates constraints through a more swifty syntax when using UIKit/AppKit."
        introductionDescription.textColor = .label

        let newsView = UIView()
        let newsTitle = UILabel()
        newsTitle.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        newsTitle.text = "News"
        newsTitle.textColor = .label
        let newsTopic1 = UIView()
        newsTopic1.backgroundColor = .separator
        let newsTopic1Title = UILabel()
        newsTopic1Title.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
        newsTopic1Title.text = "Topic 1"
        newsTopic1Title.textColor = .label
        let newsTopic1Description = UILabel()
        newsTopic1Description.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        newsTopic1Description.numberOfLines = 0
        newsTopic1Description.text = "DSL features for addSubview and removeFromSuperview DSL features for NSLayoutConstraint, NSLayoutAnchor and activation"
        newsTopic1Description.textColor = .label
        let tmpa71a50UIImageView = UIImageView()
        tmpa71a50UIImageView.tintColor = .label
        tmpa71a50UIImageView.image = UIImage(systemName: "newspaper")
        tmpa71a50UIImageView.contentMode = .scaleAspectFit
        let newsTopic2 = UIView()
        newsTopic2.backgroundColor = .separator
        let newsTopic2Title = UILabel()
        newsTopic2Title.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
        newsTopic2Title.text = "Topic 2"
        newsTopic2Title.textColor = .label
        let newsTopic2Description = UILabel()
        newsTopic2Description.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        newsTopic2Description.numberOfLines = 0
        newsTopic2Description.text = "using conditional and loop statements like if else, swift case, for in view hierarhcy and autolayout constraints."
        newsTopic2Description.textColor = .label
        let tmpa72bb0UIImageView = UIImageView()
        tmpa72bb0UIImageView.tintColor = .label
        tmpa72bb0UIImageView.image = UIImage(systemName: "doc.text")
        tmpa72bb0UIImageView.contentMode = .scaleAspectFit

        let optionView = UIView()
        let optionRow0 = UIView()
        let tmpa74120UILabel = UILabel()
        tmpa74120UILabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        tmpa74120UILabel.text = "Option 1"
        tmpa74120UILabel.textColor = .label
        let tmpa74620UISwitch = UISwitch()
        let tmp805290UIView = UIView()
        tmp805290UIView.backgroundColor = .separator
        let optionRow1 = UIView()
        let tmp80bc70UILabel = UILabel()
        tmp80bc70UILabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        tmp80bc70UILabel.text = "Option 2"
        tmp80bc70UILabel.textColor = .label
        let tmp808e30UISwitch = UISwitch()
        let tmp811f90UIView = UIView()
        tmp811f90UIView.backgroundColor = .separator
        
        return self.config {
            $0.backgroundColor = .systemBackground
        }.sublayout {
            headerView.anchors {
                Anchors(.top, .leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.height).equalTo(constant: 60.0)
            }.sublayout {
                headerLabel.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(constant: 16.0)
                }
                
                headerButton0.anchors {
                    Anchors(.centerY)
                    Anchors(.width, .height).equalTo(constant: 40.0)
                }
                
                headerButton1.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(headerButton0, attribute: .trailing, constant: 2.0)
                    Anchors(.width, .height).equalTo(constant: 40.0)
                }
                
                headerButton2.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(headerButton1, attribute: .trailing, constant: 2.0)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                headerButton3.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(headerButton2, attribute: .trailing, constant: 2.0)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                    Anchors(.trailing).equalTo(constant: -8.0)
                }
            }
            
            walletView.anchors {
                Anchors(.top).equalTo(headerView, attribute: .bottom)
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.height).equalTo(constant: 190.0)
            }.sublayout {
                walletHeaderView.anchors {
                    Anchors(.top, .leading, .trailing)
                    Anchors(.height).equalTo(constant: 60.0)
                }.sublayout {
                    walletHeaderTitle.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.centerY)
                        Anchors(.height).equalTo(constant: 40.0)
                    }

                    walletHeaderTitleArrow.anchors {
                        Anchors(.leading).equalTo(walletHeaderTitle, attribute: .trailing)
                        Anchors(.centerY).equalTo(walletHeaderTitle)
                        Anchors(.height, .width).equalTo(constant: 20.0)
                    }

                    walletHeaderCertificationButton.anchors {
                        Anchors(.centerY)
                        Anchors.size(CGSize(width: 135, height: 31))
                    }

                    walletHeaderButtonSeparator.anchors {
                        Anchors(.leading).equalTo(walletHeaderCertificationButton, attribute: .trailing, constant: 3.0)
                        Anchors(.centerY)
                        Anchors(.height).equalTo(constant: 15.0)
                        Anchors(.width).equalTo(constant: 1.0)
                    }

                    walletHeaderQRCheckinButton.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo(walletHeaderButtonSeparator, attribute: .trailing, constant: 3.0)
                        Anchors(.trailing).equalTo(constant: -8.0)
                        Anchors.size(CGSize(width: 130, height: 31))
                    }
                }

                walletNoticeView.anchors {
                    Anchors(.centerX)
                    Anchors(.width).equalTo(walletView, constant: -32.0)
                    Anchors(.top).equalTo(walletHeaderView, attribute: .bottom)
                    Anchors(.height).equalTo(constant: 40.0)
                }.sublayout {
                    walletNoticeIcon.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo(constant: 10.0)
                        Anchors(.height, .width).equalTo(constant: 20.0)
                    }
                    
                    walletNoticeTitle.anchors {
                        Anchors(.leading).equalTo(walletNoticeIcon, attribute: .trailing, constant: 5.0)
                        Anchors(.centerY)
                    }
                    
                    walletNoticeArrow.anchors {
                        Anchors(.centerY)
                        Anchors(.width, .height).equalTo(constant: 15.0)
                        Anchors(.trailing).equalTo(constant: -10.0)
                    }
                }

                walletPayView.anchors {
                    Anchors(.leading, .trailing, .bottom)
                    Anchors(.top).equalTo(walletNoticeView, attribute: .bottom, constant: 15.0)
                }.sublayout {
                    GroupLayout {
                        walletPayIcon.anchors {
                            Anchors(.leading).equalTo(constant: 16.0)
                            Anchors(.centerY).equalTo(walletPayTitle)
                            Anchors(.width, .height).equalTo(constant: 15.0)
                        }
                        
                        walletPayTitle.anchors {
                            Anchors(.top)
                            Anchors(.leading).equalTo(walletPayIcon, attribute: .trailing, constant: 2.0)
                        }
                        
                        walletPayBalance.anchors {
                            Anchors(.centerY).equalTo(walletPayTitle)
                            Anchors(.trailing).equalTo(constant: -16.0)
                        }
                    }

                    GroupLayout {
                        walletPayTransferButton.anchors {
                            Anchors(.leading).equalTo(constant: 6.0)
                            Anchors(.top).equalTo(walletPayTitle, attribute: .bottom, constant: 10.0)
                            Anchors.size(CGSize(width: 75, height: 31))
                        }

                        walletPayButtonSeparator0.anchors {
                            Anchors(.leading).equalTo(walletPayTransferButton, attribute: .trailing)
                            Anchors(.centerY).equalTo(walletPayTransferButton)
                            Anchors(.height).equalTo(constant: 15.0)
                            Anchors(.width).equalTo(constant: 1.0)
                        }

                        walletPayPaymentButton.anchors {
                            Anchors(.centerY).equalTo(walletPayTransferButton)
                            Anchors(.leading).equalTo(walletPayButtonSeparator0, attribute: .trailing)
                            Anchors.size(CGSize(width: 80, height: 31))
                        }

                        walletPayButtonSeparator1.anchors {
                            Anchors(.centerY).equalTo(walletPayTransferButton)
                            Anchors(.leading).equalTo(walletPayPaymentButton, attribute: .trailing)
                            Anchors(.width).equalTo(constant: 1.0)
                            Anchors(.height).equalTo(constant: 15.0)
                        }

                        walletPayAssetsButton.anchors {
                            Anchors(.leading).equalTo(walletPayButtonSeparator1, attribute: .trailing)
                            Anchors(.centerY).equalTo(walletPayPaymentButton)
                            Anchors.size(CGSize(width: 66, height: 31))
                        }

                        walletPayPurchasesButton.anchors {
                            Anchors(.centerY).equalTo(walletPayTransferButton)
                            Anchors(.trailing).equalTo(constant: -5.0)
                            Anchors.size(CGSize(width: 130, height: 32))
                        }
                    }
                }
            }

            serviceList0View.anchors {
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.top).equalTo(walletView, attribute: .bottom, constant: 15.0)
                Anchors(.height).equalTo(constant: 75.0)
            }.sublayout {
                serviceItem0.anchors {
                    Anchors(.top, .leading, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem0Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa668d0UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem0Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa2fb30UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem0Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem1.anchors {
                    Anchors(.leading).equalTo(serviceItem0, attribute: .trailing)
                    Anchors(.top, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem1Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa67f30UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem1Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa68210UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem1Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem2.anchors {
                    Anchors(.top, .bottom)
                    Anchors(.leading).equalTo(serviceItem1, attribute: .trailing)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem2Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6a080UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem2Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa6a360UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem2Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem3.anchors {
                    Anchors(.top, .bottom, .trailing)
                    Anchors(.leading).equalTo(serviceItem2, attribute: .trailing)
                }.sublayout {
                    serviceItem3Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6dfa0UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem3Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa4e8c0UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem3Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
            }

            serviceList1View.anchors {
                Anchors(.top).equalTo(serviceList0View, attribute: .bottom)
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.height).equalTo(constant: 75.0)
            }.sublayout {
                serviceItem4.anchors {
                    Anchors(.top, .leading, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem4Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6e290UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem4Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa31380UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem4Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem5.anchors {
                    Anchors(.leading).equalTo(serviceItem4, attribute: .trailing)
                    Anchors(.top, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem5Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6e570UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem5Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa342e0UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem5Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem6.anchors {
                    Anchors(.top, .bottom)
                    Anchors(.leading).equalTo(serviceItem5, attribute: .trailing)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    serviceItem6Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6e850UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem6Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa517f0UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem6Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                serviceItem7.anchors {
                    Anchors(.top, .bottom, .trailing)
                    Anchors(.leading).equalTo(serviceItem6, attribute: .trailing)
                }.sublayout {
                    serviceItem7Image.anchors {
                        Anchors(.top).equalTo(constant: 10.0)
                        Anchors(.centerX)
                        Anchors(.height, .width).equalTo(constant: 40.0)
                    }
                    
                    tmpa6eb30UILabel.anchors {
                        Anchors(.centerX)
                        Anchors(.top).equalTo(serviceItem7Image, attribute: .bottom, constant: 4.0)
                    }
                    
                    tmpa581e0UIView.anchors {
                        Anchors(.trailing, .top).equalTo(serviceItem7Image)
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
            }

            introductionView.anchors {
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
                Anchors(.trailing).equalTo(self.safeAreaLayoutGuide, constant: -16.0)
                Anchors(.top).equalTo(serviceList1View, attribute: .bottom, constant: 8.0)
                Anchors(.height).equalTo(constant: 80.0)
                
            }.sublayout {
                introductionImage.anchors {
                    Anchors(.leading).equalTo(constant: 10.0)
                    Anchors(.centerY)
                    Anchors(.height, .width).equalTo(constant: 70.0)
                }
                
                introductionTitle.anchors {
                    Anchors(.top).equalTo(constant: 8.0)
                    Anchors(.leading).equalTo(introductionImage, attribute: .trailing, constant: 10.0)
                    Anchors(.height).equalTo(constant: 24.0)
                }
                
                introductionDescription.anchors {
                    Anchors(.top).equalTo(introductionTitle, attribute: .bottom, constant: 5.0)
                    Anchors(.leading).equalTo(introductionImage, attribute: .trailing, constant: 10.0)
                    Anchors(.bottom).equalTo(constant: -8.0)
                    Anchors(.trailing).equalTo(constant: -10.0)
                }
            }

            newsView.anchors {
                Anchors(.top).equalTo(introductionView, attribute: .bottom, constant: 8.0)
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
                Anchors(.trailing).equalTo(self.safeAreaLayoutGuide, constant: -16.0)
                Anchors(.height).equalTo(constant: 170.0)
            }.sublayout {
                newsTitle.anchors {
                    Anchors(.leading, .top)
                    Anchors(.height).equalTo(constant: 24.0)
                }
                
                newsTopic1.anchors {
                    Anchors(.top).equalTo(newsTitle, attribute: .bottom, constant: 8.0)
                    Anchors(.leading, .trailing)
                    Anchors(.height).equalTo(newsTopic2).setMultiplier(1.0)
                }.sublayout {
                    newsTopic1Title.anchors {
                        Anchors(.top).equalTo(constant: 8.0)
                        Anchors(.leading).equalTo(constant: 10.0)
                        Anchors(.height).equalTo(constant: 18.0)
                    }
                    
                    newsTopic1Description.anchors {
                        Anchors(.leading).equalTo(newsTopic1Title)
                        Anchors(.top).equalTo(newsTopic1Title, attribute: .bottom, constant: 2.0)
                        Anchors(.bottom).equalTo(constant: -8.0)
                    }
                    
                    tmpa71a50UIImageView.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo(newsTopic1Description, attribute: .trailing, constant: 10.0)
                        Anchors(.height, .width).equalTo(constant: 50.0)
                        Anchors(.trailing).equalTo(constant: -10.0)
                    }
                }
                
                newsTopic2.anchors {
                    Anchors(.top).equalTo(newsTopic1, attribute: .bottom, constant: 8.0)
                    Anchors(.leading, .trailing, .bottom)
                }.sublayout {
                    newsTopic2Title.anchors {
                        Anchors(.top).equalTo(constant: 8.0)
                        Anchors(.leading).equalTo(constant: 10.0)
                        Anchors(.height).equalTo(constant: 18.0)
                    }
                    
                    newsTopic2Description.anchors {
                        Anchors(.leading).equalTo(newsTopic2Title)
                        Anchors(.top).equalTo(newsTopic2Title, attribute: .bottom, constant: 2.0)
                        Anchors(.bottom).equalTo(constant: -8.0)
                    }
                    
                    tmpa72bb0UIImageView.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo(newsTopic2Description, attribute: .trailing, constant: 10.0)
                        Anchors(.height, .width).equalTo(constant: 50.0)
                        Anchors(.trailing).equalTo(constant: -10.0)
                    }
                }
            }

            optionView.anchors {
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.top).equalTo(newsView, attribute: .bottom, constant: 8.0)
            }.sublayout {
                optionRow0.anchors {
                    Anchors(.top, .leading, .trailing)
                    Anchors(.height).equalTo(constant: 50.0)
                }.sublayout {
                    tmpa74120UILabel.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.centerY)
                    }
                    tmpa74620UISwitch.anchors {
                        Anchors(.centerY)
                        Anchors(.trailing).equalTo(constant: -16.0)
                    }
                    
                    tmp805290UIView.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.trailing).equalTo(constant: -16.0)
                        Anchors(.bottom)
                        Anchors(.height).equalTo(constant: 1.0)
                    }
                }
                optionRow1.anchors {
                    Anchors(.top).equalTo(optionRow0, attribute: .bottom)
                    Anchors(.leading, .trailing)
                    Anchors(.height).equalTo(constant: 50.0)
                }.sublayout {
                    tmp80bc70UILabel.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.centerY)
                    }
                    tmp808e30UISwitch.anchors {
                        Anchors(.centerY)
                        Anchors(.trailing).equalTo(constant: -16.0)
                    }
                    
                    tmp811f90UIView.anchors {
                        Anchors(.leading).equalTo(constant: 16.0)
                        Anchors(.trailing).equalTo(constant: -16.0)
                        Anchors(.bottom)
                        Anchors(.height).equalTo(constant: 1.0)
                    }
                }
            }
        }
    }
    
    var activation: Activation?
    
}
