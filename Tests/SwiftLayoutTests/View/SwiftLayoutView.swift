//
//  SwiftLayoutView.swift
//  SwiftLayout-Performance-Test
//
//  Created by aiden_h on 2022/03/17.
//

import UIKit
import SwiftLayout

class SwiftLayoutView: UIView, Layoutable {
    
    var layout: some Layout {
        self.config {
            $0.backgroundColor = .systemBackground
        }.sublayout {
            UIView().identifying("headerView").anchors {
                Anchors(.top, .leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.height).equalTo(constant: 60.0)
            }.sublayout {
                UILabel().identifying("headerLabel").config {
                    $0.font = UIFont.systemFont(ofSize: 23.0, weight: .semibold)
                    $0.text = "Hello SwiftLayout"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo(constant: 16.0)
                }
                
                UIButton().identifying("headerButton0").config {
                    $0.tintColor = .label
                    $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.width, .height).equalTo(constant: 40.0)
                }
                
                UIButton().identifying("headerButton1").config {
                    $0.tintColor = .label
                    $0.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("headerButton0", attribute: .trailing, constant: 2.0)
                    Anchors(.width, .height).equalTo(constant: 40.0)
                }
                
                UIButton().identifying("headerButton2").config {
                    $0.tintColor = .label
                    $0.setImage(UIImage(systemName: "music.note"), for: .normal)
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("headerButton1", attribute: .trailing, constant: 2.0)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UIButton().identifying("headerButton3").config {
                    $0.tintColor = .label
                    $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("headerButton2", attribute: .trailing, constant: 2.0)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                    Anchors(.trailing).equalTo(constant: -8.0)
                }
            }
            
            UIView().config {
                $0.backgroundColor = .systemBrown
            }.identifying("walletView").anchors {
                Anchors(.top).equalTo("headerView", attribute: .bottom)
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
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

            UIView().identifying("serviceList0View").anchors {
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
                Anchors(.top).equalTo("walletView", attribute: .bottom, constant: 15.0)
                Anchors(.height).equalTo(constant: 75.0)
            }.sublayout {
                UIView().identifying("serviceItem0").anchors {
                    Anchors(.top, .leading, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    UIImageView().identifying("serviceItem0Image").config {
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
                        Anchors(.top).equalTo("serviceItem0Image", attribute: .bottom, constant: 4.0)
                    }
                    
                    UIView().config {
                        $0.backgroundColor = .systemRed
                    }.anchors {
                        Anchors(.trailing, .top).equalTo("serviceItem0Image")
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                UIView().identifying("serviceItem1").anchors {
                    Anchors(.leading).equalTo("serviceItem0", attribute: .trailing)
                    Anchors(.top, .bottom)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    UIImageView().identifying("serviceItem1Image").config {
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
                        Anchors(.top).equalTo("serviceItem1Image", attribute: .bottom, constant: 4.0)
                    }
                    
                    UIView().config {
                        $0.backgroundColor = .systemRed
                    }.anchors {
                        Anchors(.trailing, .top).equalTo("serviceItem1Image")
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                UIView().identifying("serviceItem2").anchors {
                    Anchors(.top, .bottom)
                    Anchors(.leading).equalTo("serviceItem1", attribute: .trailing)
                    Anchors(.width).setMultiplier(0.25)
                }.sublayout {
                    UIImageView().identifying("serviceItem2Image").config {
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
                        Anchors(.top).equalTo("serviceItem2Image", attribute: .bottom, constant: 4.0)
                    }
                    
                    UIView().config {
                        $0.backgroundColor = .systemRed
                    }.anchors {
                        Anchors(.trailing, .top).equalTo("serviceItem2Image")
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
                
                UIView().identifying("serviceItem3").anchors {
                    Anchors(.top, .bottom, .trailing)
                    Anchors(.leading).equalTo("serviceItem2", attribute: .trailing)
                }.sublayout {
                    UIImageView().identifying("serviceItem3Image").config {
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
                        Anchors(.top).equalTo("serviceItem3Image", attribute: .bottom, constant: 4.0)
                    }
                    
                    UIView().config {
                        $0.backgroundColor = .systemRed
                    }.anchors {
                        Anchors(.trailing, .top).equalTo("serviceItem3Image")
                        Anchors(.width, .height).equalTo(constant: 4.0)
                    }
                }
            }

            UIView().identifying("serviceList1View").anchors {
                Anchors(.top).equalTo("serviceList0View", attribute: .bottom)
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
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

            UIView().config {
                $0.backgroundColor = .separator
            }.identifying("introductionView").anchors {
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
                Anchors(.trailing).equalTo(self.safeAreaLayoutGuide, constant: -16.0)
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

            UIView().identifying("NewsView").anchors {
                Anchors(.top).equalTo("introductionView", attribute: .bottom, constant: 8.0)
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
                Anchors(.trailing).equalTo(self.safeAreaLayoutGuide, constant: -16.0)
                Anchors(.height).equalTo(constant: 170.0)
            }.sublayout {
                UILabel().identifying("NewsTitle").config {
                    $0.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                    $0.text = "News"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.leading, .top)
                    Anchors(.height).equalTo(constant: 24.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .separator
                }.identifying("NewsTopic1").anchors {
                    Anchors(.top).equalTo("NewsTitle", attribute: .bottom, constant: 8.0)
                    Anchors(.leading, .trailing)
                    Anchors(.height).equalTo("NewsTopic2").setMultiplier(1.0)
                }.sublayout {
                    UILabel().identifying("NewsTopic1Title").config {
                        $0.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
                        $0.text = "Topic 1"
                        $0.textColor = .label
                    }.anchors {
                        Anchors(.top).equalTo(constant: 8.0)
                        Anchors(.leading).equalTo(constant: 10.0)
                        Anchors(.height).equalTo(constant: 18.0)
                    }
                    
                    UILabel().identifying("NewsTopic1Description").config {
                        $0.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
                        $0.numberOfLines = 0
                        $0.text = "DSL features for addSubview and removeFromSuperview DSL features for NSLayoutConstraint, NSLayoutAnchor and activation"
                        $0.textColor = .label
                    }.anchors {
                        Anchors(.leading).equalTo("NewsTopic1Title")
                        Anchors(.top).equalTo("NewsTopic1Title", attribute: .bottom, constant: 2.0)
                        Anchors(.bottom).equalTo(constant: -8.0)
                    }
                    
                    UIImageView().config {
                        $0.tintColor = .label
                        $0.image = UIImage(systemName: "newspaper")
                        $0.contentMode = .scaleAspectFit
                    }.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo("NewsTopic1Description", attribute: .trailing, constant: 10.0)
                        Anchors(.height, .width).equalTo(constant: 50.0)
                        Anchors(.trailing).equalTo(constant: -10.0)
                    }
                }
                
                UIView().config {
                    $0.backgroundColor = .separator
                }.identifying("NewsTopic2").anchors {
                    Anchors(.top).equalTo("NewsTopic1", attribute: .bottom, constant: 8.0)
                    Anchors(.leading, .trailing, .bottom)
                }.sublayout {
                    UILabel().identifying("NewsTopic2Title").config {
                        $0.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
                        $0.text = "Topic 2"
                        $0.textColor = .label
                    }.anchors {
                        Anchors(.top).equalTo(constant: 8.0)
                        Anchors(.leading).equalTo(constant: 10.0)
                        Anchors(.height).equalTo(constant: 18.0)
                    }
                    
                    UILabel().identifying("NewsTopic2Description").config {
                        $0.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
                        $0.numberOfLines = 0
                        $0.text = "using conditional and loop statements like if else, swift case, for in view hierarhcy and autolayout constraints."
                        $0.textColor = .label
                    }.anchors {
                        Anchors(.leading).equalTo("NewsTopic2Title")
                        Anchors(.top).equalTo("NewsTopic2Title", attribute: .bottom, constant: 2.0)
                        Anchors(.bottom).equalTo(constant: -8.0)
                    }
                    
                    UIImageView().config {
                        $0.tintColor = .label
                        $0.image = UIImage(systemName: "doc.text")
                        $0.contentMode = .scaleAspectFit
                    }.anchors {
                        Anchors(.centerY)
                        Anchors(.leading).equalTo("NewsTopic2Description", attribute: .trailing, constant: 10.0)
                        Anchors(.height, .width).equalTo(constant: 50.0)
                        Anchors(.trailing).equalTo(constant: -10.0)
                    }
                }
            }

            UIView().identifying("optionView").anchors {
                Anchors(.leading, .trailing).equalTo(self.safeAreaLayoutGuide)
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
    
    var activation: Activation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let date = Date()
        self.updateLayout()
        print("SwiftLayoutView updateLayout time: \(-date.timeIntervalSinceNow)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateLayout()
    }
}
