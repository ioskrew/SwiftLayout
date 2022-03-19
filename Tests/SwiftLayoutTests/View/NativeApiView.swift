//
//  NativeApiView.swift
//  
//
//  Created by aiden_h on 2022/03/19.
//

import UIKit

class NativeApiView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let date = Date()
        loadView()
        print("NativeApiView loadView time: \(-date.timeIntervalSinceNow)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    func loadView() {
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

        self.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerButton0.translatesAutoresizingMaskIntoConstraints = false
        headerButton1.translatesAutoresizingMaskIntoConstraints = false
        headerButton2.translatesAutoresizingMaskIntoConstraints = false
        headerButton3.translatesAutoresizingMaskIntoConstraints = false
        walletView.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderView.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderTitle.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderTitleArrow.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderCertificationButton.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderButtonSeparator.translatesAutoresizingMaskIntoConstraints = false
        walletHeaderQRCheckinButton.translatesAutoresizingMaskIntoConstraints = false
        walletNoticeView.translatesAutoresizingMaskIntoConstraints = false
        walletNoticeIcon.translatesAutoresizingMaskIntoConstraints = false
        walletNoticeTitle.translatesAutoresizingMaskIntoConstraints = false
        walletNoticeArrow.translatesAutoresizingMaskIntoConstraints = false
        walletPayView.translatesAutoresizingMaskIntoConstraints = false
        walletPayIcon.translatesAutoresizingMaskIntoConstraints = false
        walletPayTitle.translatesAutoresizingMaskIntoConstraints = false
        walletPayBalance.translatesAutoresizingMaskIntoConstraints = false
        walletPayTransferButton.translatesAutoresizingMaskIntoConstraints = false
        walletPayButtonSeparator0.translatesAutoresizingMaskIntoConstraints = false
        walletPayPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        walletPayButtonSeparator1.translatesAutoresizingMaskIntoConstraints = false
        walletPayAssetsButton.translatesAutoresizingMaskIntoConstraints = false
        walletPayPurchasesButton.translatesAutoresizingMaskIntoConstraints = false
        serviceList0View.translatesAutoresizingMaskIntoConstraints = false
        serviceItem0.translatesAutoresizingMaskIntoConstraints = false
        serviceItem0Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa668d0UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa2fb30UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem1.translatesAutoresizingMaskIntoConstraints = false
        serviceItem1Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa67f30UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa68210UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem2.translatesAutoresizingMaskIntoConstraints = false
        serviceItem2Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6a080UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa6a360UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem3.translatesAutoresizingMaskIntoConstraints = false
        serviceItem3Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6dfa0UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa4e8c0UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceList1View.translatesAutoresizingMaskIntoConstraints = false
        serviceItem4.translatesAutoresizingMaskIntoConstraints = false
        serviceItem4Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6e290UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa31380UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem5.translatesAutoresizingMaskIntoConstraints = false
        serviceItem5Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6e570UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa342e0UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem6.translatesAutoresizingMaskIntoConstraints = false
        serviceItem6Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6e850UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa517f0UIView.translatesAutoresizingMaskIntoConstraints = false
        serviceItem7.translatesAutoresizingMaskIntoConstraints = false
        serviceItem7Image.translatesAutoresizingMaskIntoConstraints = false
        tmpa6eb30UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa581e0UIView.translatesAutoresizingMaskIntoConstraints = false
        introductionView.translatesAutoresizingMaskIntoConstraints = false
        introductionImage.translatesAutoresizingMaskIntoConstraints = false
        introductionTitle.translatesAutoresizingMaskIntoConstraints = false
        introductionDescription.translatesAutoresizingMaskIntoConstraints = false
        newsView.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsTopic1.translatesAutoresizingMaskIntoConstraints = false
        newsTopic1Title.translatesAutoresizingMaskIntoConstraints = false
        newsTopic1Description.translatesAutoresizingMaskIntoConstraints = false
        tmpa71a50UIImageView.translatesAutoresizingMaskIntoConstraints = false
        newsTopic2.translatesAutoresizingMaskIntoConstraints = false
        newsTopic2Title.translatesAutoresizingMaskIntoConstraints = false
        newsTopic2Description.translatesAutoresizingMaskIntoConstraints = false
        tmpa72bb0UIImageView.translatesAutoresizingMaskIntoConstraints = false
        optionView.translatesAutoresizingMaskIntoConstraints = false
        optionRow0.translatesAutoresizingMaskIntoConstraints = false
        tmpa74120UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmpa74620UISwitch.translatesAutoresizingMaskIntoConstraints = false
        tmp805290UIView.translatesAutoresizingMaskIntoConstraints = false
        optionRow1.translatesAutoresizingMaskIntoConstraints = false
        tmp80bc70UILabel.translatesAutoresizingMaskIntoConstraints = false
        tmp808e30UISwitch.translatesAutoresizingMaskIntoConstraints = false
        tmp811f90UIView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(headerView)
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerButton0)
        headerView.addSubview(headerButton1)
        headerView.addSubview(headerButton2)
        headerView.addSubview(headerButton3)
        self.addSubview(walletView)
        walletView.addSubview(walletHeaderView)
        walletHeaderView.addSubview(walletHeaderTitle)
        walletHeaderView.addSubview(walletHeaderTitleArrow)
        walletHeaderView.addSubview(walletHeaderCertificationButton)
        walletHeaderView.addSubview(walletHeaderButtonSeparator)
        walletHeaderView.addSubview(walletHeaderQRCheckinButton)
        walletView.addSubview(walletNoticeView)
        walletNoticeView.addSubview(walletNoticeIcon)
        walletNoticeView.addSubview(walletNoticeTitle)
        walletNoticeView.addSubview(walletNoticeArrow)
        walletView.addSubview(walletPayView)
        walletPayView.addSubview(walletPayIcon)
        walletPayView.addSubview(walletPayTitle)
        walletPayView.addSubview(walletPayBalance)
        walletPayView.addSubview(walletPayTransferButton)
        walletPayView.addSubview(walletPayButtonSeparator0)
        walletPayView.addSubview(walletPayPaymentButton)
        walletPayView.addSubview(walletPayButtonSeparator1)
        walletPayView.addSubview(walletPayAssetsButton)
        walletPayView.addSubview(walletPayPurchasesButton)
        self.addSubview(serviceList0View)
        serviceList0View.addSubview(serviceItem0)
        serviceItem0.addSubview(serviceItem0Image)
        serviceItem0.addSubview(tmpa668d0UILabel)
        serviceItem0.addSubview(tmpa2fb30UIView)
        serviceList0View.addSubview(serviceItem1)
        serviceItem1.addSubview(serviceItem1Image)
        serviceItem1.addSubview(tmpa67f30UILabel)
        serviceItem1.addSubview(tmpa68210UIView)
        serviceList0View.addSubview(serviceItem2)
        serviceItem2.addSubview(serviceItem2Image)
        serviceItem2.addSubview(tmpa6a080UILabel)
        serviceItem2.addSubview(tmpa6a360UIView)
        serviceList0View.addSubview(serviceItem3)
        serviceItem3.addSubview(serviceItem3Image)
        serviceItem3.addSubview(tmpa6dfa0UILabel)
        serviceItem3.addSubview(tmpa4e8c0UIView)
        self.addSubview(serviceList1View)
        serviceList1View.addSubview(serviceItem4)
        serviceItem4.addSubview(serviceItem4Image)
        serviceItem4.addSubview(tmpa6e290UILabel)
        serviceItem4.addSubview(tmpa31380UIView)
        serviceList1View.addSubview(serviceItem5)
        serviceItem5.addSubview(serviceItem5Image)
        serviceItem5.addSubview(tmpa6e570UILabel)
        serviceItem5.addSubview(tmpa342e0UIView)
        serviceList1View.addSubview(serviceItem6)
        serviceItem6.addSubview(serviceItem6Image)
        serviceItem6.addSubview(tmpa6e850UILabel)
        serviceItem6.addSubview(tmpa517f0UIView)
        serviceList1View.addSubview(serviceItem7)
        serviceItem7.addSubview(serviceItem7Image)
        serviceItem7.addSubview(tmpa6eb30UILabel)
        serviceItem7.addSubview(tmpa581e0UIView)
        self.addSubview(introductionView)
        introductionView.addSubview(introductionImage)
        introductionView.addSubview(introductionTitle)
        introductionView.addSubview(introductionDescription)
        self.addSubview(newsView)
        newsView.addSubview(newsTitle)
        newsView.addSubview(newsTopic1)
        newsTopic1.addSubview(newsTopic1Title)
        newsTopic1.addSubview(newsTopic1Description)
        newsTopic1.addSubview(tmpa71a50UIImageView)
        newsView.addSubview(newsTopic2)
        newsTopic2.addSubview(newsTopic2Title)
        newsTopic2.addSubview(newsTopic2Description)
        newsTopic2.addSubview(tmpa72bb0UIImageView)
        self.addSubview(optionView)
        optionView.addSubview(optionRow0)
        optionRow0.addSubview(tmpa74120UILabel)
        optionRow0.addSubview(tmpa74620UISwitch)
        optionRow0.addSubview(tmp805290UIView)
        optionView.addSubview(optionRow1)
        optionRow1.addSubview(tmp80bc70UILabel)
        optionRow1.addSubview(tmp808e30UISwitch)
        optionRow1.addSubview(tmp811f90UIView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60.0),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0),
            headerButton0.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerButton0.widthAnchor.constraint(equalToConstant: 40.0),
            headerButton0.heightAnchor.constraint(equalToConstant: 40.0),
            headerButton1.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerButton1.leadingAnchor.constraint(equalTo: headerButton0.trailingAnchor, constant: 2.0),
            headerButton1.widthAnchor.constraint(equalToConstant: 40.0),
            headerButton1.heightAnchor.constraint(equalToConstant: 40.0),
            headerButton2.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerButton2.leadingAnchor.constraint(equalTo: headerButton1.trailingAnchor, constant: 2.0),
            headerButton2.heightAnchor.constraint(equalToConstant: 40.0),
            headerButton2.widthAnchor.constraint(equalToConstant: 40.0),
            headerButton3.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerButton3.leadingAnchor.constraint(equalTo: headerButton2.trailingAnchor, constant: 2.0),
            headerButton3.heightAnchor.constraint(equalToConstant: 40.0),
            headerButton3.widthAnchor.constraint(equalToConstant: 40.0),
            headerButton3.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8.0),
            walletView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            walletView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            walletView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            walletView.heightAnchor.constraint(equalToConstant: 190.0),
            walletHeaderView.topAnchor.constraint(equalTo: walletView.topAnchor),
            walletHeaderView.leadingAnchor.constraint(equalTo: walletView.leadingAnchor),
            walletHeaderView.trailingAnchor.constraint(equalTo: walletView.trailingAnchor),
            walletHeaderView.heightAnchor.constraint(equalToConstant: 60.0),
            walletHeaderTitle.leadingAnchor.constraint(equalTo: walletHeaderView.leadingAnchor, constant: 16.0),
            walletHeaderTitle.centerYAnchor.constraint(equalTo: walletHeaderView.centerYAnchor),
            walletHeaderTitle.heightAnchor.constraint(equalToConstant: 40.0),
            walletHeaderTitleArrow.leadingAnchor.constraint(equalTo: walletHeaderTitle.trailingAnchor),
            walletHeaderTitleArrow.centerYAnchor.constraint(equalTo: walletHeaderTitle.centerYAnchor),
            walletHeaderTitleArrow.heightAnchor.constraint(equalToConstant: 20.0),
            walletHeaderTitleArrow.widthAnchor.constraint(equalToConstant: 20.0),
            walletHeaderCertificationButton.centerYAnchor.constraint(equalTo: walletHeaderView.centerYAnchor),
            walletHeaderCertificationButton.widthAnchor.constraint(equalToConstant: 135.0),
            walletHeaderCertificationButton.heightAnchor.constraint(equalToConstant: 31.0),
            walletHeaderButtonSeparator.leadingAnchor.constraint(equalTo: walletHeaderCertificationButton.trailingAnchor, constant: 3.0),
            walletHeaderButtonSeparator.centerYAnchor.constraint(equalTo: walletHeaderView.centerYAnchor),
            walletHeaderButtonSeparator.heightAnchor.constraint(equalToConstant: 15.0),
            walletHeaderButtonSeparator.widthAnchor.constraint(equalToConstant: 1.0),
            walletHeaderQRCheckinButton.centerYAnchor.constraint(equalTo: walletHeaderView.centerYAnchor),
            walletHeaderQRCheckinButton.leadingAnchor.constraint(equalTo: walletHeaderButtonSeparator.trailingAnchor, constant: 3.0),
            walletHeaderQRCheckinButton.trailingAnchor.constraint(equalTo: walletHeaderView.trailingAnchor, constant: -8.0),
            walletHeaderQRCheckinButton.widthAnchor.constraint(equalToConstant: 130.0),
            walletHeaderQRCheckinButton.heightAnchor.constraint(equalToConstant: 31.0),
            walletNoticeView.centerXAnchor.constraint(equalTo: walletView.centerXAnchor),
            walletNoticeView.widthAnchor.constraint(equalTo: walletView.widthAnchor, constant: -32.0),
            walletNoticeView.topAnchor.constraint(equalTo: walletHeaderView.bottomAnchor),
            walletNoticeView.heightAnchor.constraint(equalToConstant: 40.0),
            walletNoticeIcon.centerYAnchor.constraint(equalTo: walletNoticeView.centerYAnchor),
            walletNoticeIcon.leadingAnchor.constraint(equalTo: walletNoticeView.leadingAnchor, constant: 10.0),
            walletNoticeIcon.heightAnchor.constraint(equalToConstant: 20.0),
            walletNoticeIcon.widthAnchor.constraint(equalToConstant: 20.0),
            walletNoticeTitle.leadingAnchor.constraint(equalTo: walletNoticeIcon.trailingAnchor, constant: 5.0),
            walletNoticeTitle.centerYAnchor.constraint(equalTo: walletNoticeView.centerYAnchor),
            walletNoticeArrow.centerYAnchor.constraint(equalTo: walletNoticeView.centerYAnchor),
            walletNoticeArrow.widthAnchor.constraint(equalToConstant: 15.0),
            walletNoticeArrow.heightAnchor.constraint(equalToConstant: 15.0),
            walletNoticeArrow.trailingAnchor.constraint(equalTo: walletNoticeView.trailingAnchor, constant: -10.0),
            walletPayView.leadingAnchor.constraint(equalTo: walletView.leadingAnchor),
            walletPayView.trailingAnchor.constraint(equalTo: walletView.trailingAnchor),
            walletPayView.bottomAnchor.constraint(equalTo: walletView.bottomAnchor),
            walletPayView.topAnchor.constraint(equalTo: walletNoticeView.bottomAnchor, constant: 15.0),
            walletPayIcon.leadingAnchor.constraint(equalTo: walletPayView.leadingAnchor, constant: 16.0),
            walletPayIcon.centerYAnchor.constraint(equalTo: walletPayTitle.centerYAnchor),
            walletPayIcon.widthAnchor.constraint(equalToConstant: 15.0),
            walletPayIcon.heightAnchor.constraint(equalToConstant: 15.0),
            walletPayTitle.topAnchor.constraint(equalTo: walletPayView.topAnchor),
            walletPayTitle.leadingAnchor.constraint(equalTo: walletPayIcon.trailingAnchor, constant: 2.0),
            walletPayBalance.centerYAnchor.constraint(equalTo: walletPayTitle.centerYAnchor),
            walletPayBalance.trailingAnchor.constraint(equalTo: walletPayView.trailingAnchor, constant: -16.0),
            walletPayTransferButton.leadingAnchor.constraint(equalTo: walletPayView.leadingAnchor, constant: 6.0),
            walletPayTransferButton.topAnchor.constraint(equalTo: walletPayTitle.bottomAnchor, constant: 10.0),
            walletPayTransferButton.widthAnchor.constraint(equalToConstant: 75.0),
            walletPayTransferButton.heightAnchor.constraint(equalToConstant: 31.0),
            walletPayButtonSeparator0.leadingAnchor.constraint(equalTo: walletPayTransferButton.trailingAnchor),
            walletPayButtonSeparator0.centerYAnchor.constraint(equalTo: walletPayTransferButton.centerYAnchor),
            walletPayButtonSeparator0.heightAnchor.constraint(equalToConstant: 15.0),
            walletPayButtonSeparator0.widthAnchor.constraint(equalToConstant: 1.0),
            walletPayPaymentButton.centerYAnchor.constraint(equalTo: walletPayTransferButton.centerYAnchor),
            walletPayPaymentButton.leadingAnchor.constraint(equalTo: walletPayButtonSeparator0.trailingAnchor),
            walletPayPaymentButton.widthAnchor.constraint(equalToConstant: 80.0),
            walletPayPaymentButton.heightAnchor.constraint(equalToConstant: 31.0),
            walletPayButtonSeparator1.centerYAnchor.constraint(equalTo: walletPayTransferButton.centerYAnchor),
            walletPayButtonSeparator1.leadingAnchor.constraint(equalTo: walletPayPaymentButton.trailingAnchor),
            walletPayButtonSeparator1.widthAnchor.constraint(equalToConstant: 1.0),
            walletPayButtonSeparator1.heightAnchor.constraint(equalToConstant: 15.0),
            walletPayAssetsButton.leadingAnchor.constraint(equalTo: walletPayButtonSeparator1.trailingAnchor),
            walletPayAssetsButton.centerYAnchor.constraint(equalTo: walletPayPaymentButton.centerYAnchor),
            walletPayAssetsButton.widthAnchor.constraint(equalToConstant: 66.0),
            walletPayAssetsButton.heightAnchor.constraint(equalToConstant: 31.0),
            walletPayPurchasesButton.centerYAnchor.constraint(equalTo: walletPayTransferButton.centerYAnchor),
            walletPayPurchasesButton.trailingAnchor.constraint(equalTo: walletPayView.trailingAnchor, constant: -5.0),
            walletPayPurchasesButton.widthAnchor.constraint(equalToConstant: 130.0),
            walletPayPurchasesButton.heightAnchor.constraint(equalToConstant: 32.0),
            serviceList0View.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            serviceList0View.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            serviceList0View.topAnchor.constraint(equalTo: walletView.bottomAnchor, constant: 15.0),
            serviceList0View.heightAnchor.constraint(equalToConstant: 75.0),
            serviceItem0.topAnchor.constraint(equalTo: serviceList0View.topAnchor),
            serviceItem0.leadingAnchor.constraint(equalTo: serviceList0View.leadingAnchor),
            serviceItem0.bottomAnchor.constraint(equalTo: serviceList0View.bottomAnchor),
            serviceItem0.widthAnchor.constraint(equalTo: serviceList0View.widthAnchor, multiplier: 0.25),
            serviceItem0Image.topAnchor.constraint(equalTo: serviceItem0.topAnchor, constant: 10.0),
            serviceItem0Image.centerXAnchor.constraint(equalTo: serviceItem0.centerXAnchor),
            serviceItem0Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem0Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa668d0UILabel.centerXAnchor.constraint(equalTo: serviceItem0.centerXAnchor),
            tmpa668d0UILabel.topAnchor.constraint(equalTo: serviceItem0Image.bottomAnchor, constant: 4.0),
            tmpa2fb30UIView.trailingAnchor.constraint(equalTo: serviceItem0Image.trailingAnchor),
            tmpa2fb30UIView.topAnchor.constraint(equalTo: serviceItem0Image.topAnchor),
            tmpa2fb30UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa2fb30UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem1.leadingAnchor.constraint(equalTo: serviceItem0.trailingAnchor),
            serviceItem1.topAnchor.constraint(equalTo: serviceList0View.topAnchor),
            serviceItem1.bottomAnchor.constraint(equalTo: serviceList0View.bottomAnchor),
            serviceItem1.widthAnchor.constraint(equalTo: serviceList0View.widthAnchor, multiplier: 0.25),
            serviceItem1Image.topAnchor.constraint(equalTo: serviceItem1.topAnchor, constant: 10.0),
            serviceItem1Image.centerXAnchor.constraint(equalTo: serviceItem1.centerXAnchor),
            serviceItem1Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem1Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa67f30UILabel.centerXAnchor.constraint(equalTo: serviceItem1.centerXAnchor),
            tmpa67f30UILabel.topAnchor.constraint(equalTo: serviceItem1Image.bottomAnchor, constant: 4.0),
            tmpa68210UIView.trailingAnchor.constraint(equalTo: serviceItem1Image.trailingAnchor),
            tmpa68210UIView.topAnchor.constraint(equalTo: serviceItem1Image.topAnchor),
            tmpa68210UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa68210UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem2.topAnchor.constraint(equalTo: serviceList0View.topAnchor),
            serviceItem2.bottomAnchor.constraint(equalTo: serviceList0View.bottomAnchor),
            serviceItem2.leadingAnchor.constraint(equalTo: serviceItem1.trailingAnchor),
            serviceItem2.widthAnchor.constraint(equalTo: serviceList0View.widthAnchor, multiplier: 0.25),
            serviceItem2Image.topAnchor.constraint(equalTo: serviceItem2.topAnchor, constant: 10.0),
            serviceItem2Image.centerXAnchor.constraint(equalTo: serviceItem2.centerXAnchor),
            serviceItem2Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem2Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6a080UILabel.centerXAnchor.constraint(equalTo: serviceItem2.centerXAnchor),
            tmpa6a080UILabel.topAnchor.constraint(equalTo: serviceItem2Image.bottomAnchor, constant: 4.0),
            tmpa6a360UIView.trailingAnchor.constraint(equalTo: serviceItem2Image.trailingAnchor),
            tmpa6a360UIView.topAnchor.constraint(equalTo: serviceItem2Image.topAnchor),
            tmpa6a360UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa6a360UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem3.topAnchor.constraint(equalTo: serviceList0View.topAnchor),
            serviceItem3.bottomAnchor.constraint(equalTo: serviceList0View.bottomAnchor),
            serviceItem3.trailingAnchor.constraint(equalTo: serviceList0View.trailingAnchor),
            serviceItem3.leadingAnchor.constraint(equalTo: serviceItem2.trailingAnchor),
            serviceItem3Image.topAnchor.constraint(equalTo: serviceItem3.topAnchor, constant: 10.0),
            serviceItem3Image.centerXAnchor.constraint(equalTo: serviceItem3.centerXAnchor),
            serviceItem3Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem3Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6dfa0UILabel.centerXAnchor.constraint(equalTo: serviceItem3.centerXAnchor),
            tmpa6dfa0UILabel.topAnchor.constraint(equalTo: serviceItem3Image.bottomAnchor, constant: 4.0),
            tmpa4e8c0UIView.trailingAnchor.constraint(equalTo: serviceItem3Image.trailingAnchor),
            tmpa4e8c0UIView.topAnchor.constraint(equalTo: serviceItem3Image.topAnchor),
            tmpa4e8c0UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa4e8c0UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceList1View.topAnchor.constraint(equalTo: serviceList0View.bottomAnchor),
            serviceList1View.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            serviceList1View.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            serviceList1View.heightAnchor.constraint(equalToConstant: 75.0),
            serviceItem4.topAnchor.constraint(equalTo: serviceList1View.topAnchor),
            serviceItem4.leadingAnchor.constraint(equalTo: serviceList1View.leadingAnchor),
            serviceItem4.bottomAnchor.constraint(equalTo: serviceList1View.bottomAnchor),
            serviceItem4.widthAnchor.constraint(equalTo: serviceList1View.widthAnchor, multiplier: 0.25),
            serviceItem4Image.topAnchor.constraint(equalTo: serviceItem4.topAnchor, constant: 10.0),
            serviceItem4Image.centerXAnchor.constraint(equalTo: serviceItem4.centerXAnchor),
            serviceItem4Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem4Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6e290UILabel.centerXAnchor.constraint(equalTo: serviceItem4.centerXAnchor),
            tmpa6e290UILabel.topAnchor.constraint(equalTo: serviceItem4Image.bottomAnchor, constant: 4.0),
            tmpa31380UIView.trailingAnchor.constraint(equalTo: serviceItem4Image.trailingAnchor),
            tmpa31380UIView.topAnchor.constraint(equalTo: serviceItem4Image.topAnchor),
            tmpa31380UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa31380UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem5.leadingAnchor.constraint(equalTo: serviceItem4.trailingAnchor),
            serviceItem5.topAnchor.constraint(equalTo: serviceList1View.topAnchor),
            serviceItem5.bottomAnchor.constraint(equalTo: serviceList1View.bottomAnchor),
            serviceItem5.widthAnchor.constraint(equalTo: serviceList1View.widthAnchor, multiplier: 0.25),
            serviceItem5Image.topAnchor.constraint(equalTo: serviceItem5.topAnchor, constant: 10.0),
            serviceItem5Image.centerXAnchor.constraint(equalTo: serviceItem5.centerXAnchor),
            serviceItem5Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem5Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6e570UILabel.centerXAnchor.constraint(equalTo: serviceItem5.centerXAnchor),
            tmpa6e570UILabel.topAnchor.constraint(equalTo: serviceItem5Image.bottomAnchor, constant: 4.0),
            tmpa342e0UIView.trailingAnchor.constraint(equalTo: serviceItem5Image.trailingAnchor),
            tmpa342e0UIView.topAnchor.constraint(equalTo: serviceItem5Image.topAnchor),
            tmpa342e0UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa342e0UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem6.topAnchor.constraint(equalTo: serviceList1View.topAnchor),
            serviceItem6.bottomAnchor.constraint(equalTo: serviceList1View.bottomAnchor),
            serviceItem6.leadingAnchor.constraint(equalTo: serviceItem5.trailingAnchor),
            serviceItem6.widthAnchor.constraint(equalTo: serviceList1View.widthAnchor, multiplier: 0.25),
            serviceItem6Image.topAnchor.constraint(equalTo: serviceItem6.topAnchor, constant: 10.0),
            serviceItem6Image.centerXAnchor.constraint(equalTo: serviceItem6.centerXAnchor),
            serviceItem6Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem6Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6e850UILabel.centerXAnchor.constraint(equalTo: serviceItem6.centerXAnchor),
            tmpa6e850UILabel.topAnchor.constraint(equalTo: serviceItem6Image.bottomAnchor, constant: 4.0),
            tmpa517f0UIView.trailingAnchor.constraint(equalTo: serviceItem6Image.trailingAnchor),
            tmpa517f0UIView.topAnchor.constraint(equalTo: serviceItem6Image.topAnchor),
            tmpa517f0UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa517f0UIView.heightAnchor.constraint(equalToConstant: 4.0),
            serviceItem7.topAnchor.constraint(equalTo: serviceList1View.topAnchor),
            serviceItem7.bottomAnchor.constraint(equalTo: serviceList1View.bottomAnchor),
            serviceItem7.trailingAnchor.constraint(equalTo: serviceList1View.trailingAnchor),
            serviceItem7.leadingAnchor.constraint(equalTo: serviceItem6.trailingAnchor),
            serviceItem7Image.topAnchor.constraint(equalTo: serviceItem7.topAnchor, constant: 10.0),
            serviceItem7Image.centerXAnchor.constraint(equalTo: serviceItem7.centerXAnchor),
            serviceItem7Image.heightAnchor.constraint(equalToConstant: 40.0),
            serviceItem7Image.widthAnchor.constraint(equalToConstant: 40.0),
            tmpa6eb30UILabel.centerXAnchor.constraint(equalTo: serviceItem7.centerXAnchor),
            tmpa6eb30UILabel.topAnchor.constraint(equalTo: serviceItem7Image.bottomAnchor, constant: 4.0),
            tmpa581e0UIView.trailingAnchor.constraint(equalTo: serviceItem7Image.trailingAnchor),
            tmpa581e0UIView.topAnchor.constraint(equalTo: serviceItem7Image.topAnchor),
            tmpa581e0UIView.widthAnchor.constraint(equalToConstant: 4.0),
            tmpa581e0UIView.heightAnchor.constraint(equalToConstant: 4.0),
            introductionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            introductionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            introductionView.topAnchor.constraint(equalTo: serviceList1View.bottomAnchor, constant: 8.0),
            introductionView.heightAnchor.constraint(equalToConstant: 80.0),
            introductionImage.leadingAnchor.constraint(equalTo: introductionView.leadingAnchor, constant: 10.0),
            introductionImage.centerYAnchor.constraint(equalTo: introductionView.centerYAnchor),
            introductionImage.heightAnchor.constraint(equalToConstant: 70.0),
            introductionImage.widthAnchor.constraint(equalToConstant: 70.0),
            introductionTitle.topAnchor.constraint(equalTo: introductionView.topAnchor, constant: 8.0),
            introductionTitle.leadingAnchor.constraint(equalTo: introductionImage.trailingAnchor, constant: 10.0),
            introductionTitle.heightAnchor.constraint(equalToConstant: 24.0),
            introductionDescription.topAnchor.constraint(equalTo: introductionTitle.bottomAnchor, constant: 5.0),
            introductionDescription.leadingAnchor.constraint(equalTo: introductionImage.trailingAnchor, constant: 10.0),
            introductionDescription.bottomAnchor.constraint(equalTo: introductionView.bottomAnchor, constant: -8.0),
            introductionDescription.trailingAnchor.constraint(equalTo: introductionView.trailingAnchor, constant: -10.0),
            newsView.topAnchor.constraint(equalTo: introductionView.bottomAnchor, constant: 8.0),
            newsView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            newsView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            newsView.heightAnchor.constraint(equalToConstant: 170.0),
            newsTitle.leadingAnchor.constraint(equalTo: newsView.leadingAnchor),
            newsTitle.topAnchor.constraint(equalTo: newsView.topAnchor),
            newsTitle.heightAnchor.constraint(equalToConstant: 24.0),
            newsTopic1.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8.0),
            newsTopic1.leadingAnchor.constraint(equalTo: newsView.leadingAnchor),
            newsTopic1.trailingAnchor.constraint(equalTo: newsView.trailingAnchor),
            newsTopic1.heightAnchor.constraint(equalTo: newsTopic2.heightAnchor),
            newsTopic1Title.topAnchor.constraint(equalTo: newsTopic1.topAnchor, constant: 8.0),
            newsTopic1Title.leadingAnchor.constraint(equalTo: newsTopic1.leadingAnchor, constant: 10.0),
            newsTopic1Title.heightAnchor.constraint(equalToConstant: 18.0),
            newsTopic1Description.leadingAnchor.constraint(equalTo: newsTopic1Title.leadingAnchor),
            newsTopic1Description.topAnchor.constraint(equalTo: newsTopic1Title.bottomAnchor, constant: 2.0),
            newsTopic1Description.bottomAnchor.constraint(equalTo: newsTopic1.bottomAnchor, constant: -8.0),
            tmpa71a50UIImageView.centerYAnchor.constraint(equalTo: newsTopic1.centerYAnchor),
            tmpa71a50UIImageView.leadingAnchor.constraint(equalTo: newsTopic1Description.trailingAnchor, constant: 10.0),
            tmpa71a50UIImageView.heightAnchor.constraint(equalToConstant: 50.0),
            tmpa71a50UIImageView.widthAnchor.constraint(equalToConstant: 50.0),
            tmpa71a50UIImageView.trailingAnchor.constraint(equalTo: newsTopic1.trailingAnchor, constant: -10.0),
            newsTopic2.topAnchor.constraint(equalTo: newsTopic1.bottomAnchor, constant: 8.0),
            newsTopic2.leadingAnchor.constraint(equalTo: newsView.leadingAnchor),
            newsTopic2.trailingAnchor.constraint(equalTo: newsView.trailingAnchor),
            newsTopic2.bottomAnchor.constraint(equalTo: newsView.bottomAnchor),
            newsTopic2Title.topAnchor.constraint(equalTo: newsTopic2.topAnchor, constant: 8.0),
            newsTopic2Title.leadingAnchor.constraint(equalTo: newsTopic2.leadingAnchor, constant: 10.0),
            newsTopic2Title.heightAnchor.constraint(equalToConstant: 18.0),
            newsTopic2Description.leadingAnchor.constraint(equalTo: newsTopic2Title.leadingAnchor),
            newsTopic2Description.topAnchor.constraint(equalTo: newsTopic2Title.bottomAnchor, constant: 2.0),
            newsTopic2Description.bottomAnchor.constraint(equalTo: newsTopic2.bottomAnchor, constant: -8.0),
            tmpa72bb0UIImageView.centerYAnchor.constraint(equalTo: newsTopic2.centerYAnchor),
            tmpa72bb0UIImageView.leadingAnchor.constraint(equalTo: newsTopic2Description.trailingAnchor, constant: 10.0),
            tmpa72bb0UIImageView.heightAnchor.constraint(equalToConstant: 50.0),
            tmpa72bb0UIImageView.widthAnchor.constraint(equalToConstant: 50.0),
            tmpa72bb0UIImageView.trailingAnchor.constraint(equalTo: newsTopic2.trailingAnchor, constant: -10.0),
            optionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            optionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            optionView.topAnchor.constraint(equalTo: newsView.bottomAnchor, constant: 8.0),
            optionRow0.topAnchor.constraint(equalTo: optionView.topAnchor),
            optionRow0.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            optionRow0.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            optionRow0.heightAnchor.constraint(equalToConstant: 50.0),
            tmpa74120UILabel.leadingAnchor.constraint(equalTo: optionRow0.leadingAnchor, constant: 16.0),
            tmpa74120UILabel.centerYAnchor.constraint(equalTo: optionRow0.centerYAnchor),
            tmpa74620UISwitch.centerYAnchor.constraint(equalTo: optionRow0.centerYAnchor),
            tmpa74620UISwitch.trailingAnchor.constraint(equalTo: optionRow0.trailingAnchor, constant: -16.0),
            tmp805290UIView.leadingAnchor.constraint(equalTo: optionRow0.leadingAnchor, constant: 16.0),
            tmp805290UIView.trailingAnchor.constraint(equalTo: optionRow0.trailingAnchor, constant: -16.0),
            tmp805290UIView.bottomAnchor.constraint(equalTo: optionRow0.bottomAnchor),
            tmp805290UIView.heightAnchor.constraint(equalToConstant: 1.0),
            optionRow1.topAnchor.constraint(equalTo: optionRow0.bottomAnchor),
            optionRow1.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            optionRow1.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            optionRow1.heightAnchor.constraint(equalToConstant: 50.0),
            tmp80bc70UILabel.leadingAnchor.constraint(equalTo: optionRow1.leadingAnchor, constant: 16.0),
            tmp80bc70UILabel.centerYAnchor.constraint(equalTo: optionRow1.centerYAnchor),
            tmp808e30UISwitch.centerYAnchor.constraint(equalTo: optionRow1.centerYAnchor),
            tmp808e30UISwitch.trailingAnchor.constraint(equalTo: optionRow1.trailingAnchor, constant: -16.0),
            tmp811f90UIView.leadingAnchor.constraint(equalTo: optionRow1.leadingAnchor, constant: 16.0),
            tmp811f90UIView.trailingAnchor.constraint(equalTo: optionRow1.trailingAnchor, constant: -16.0),
            tmp811f90UIView.bottomAnchor.constraint(equalTo: optionRow1.bottomAnchor),
            tmp811f90UIView.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }

}
