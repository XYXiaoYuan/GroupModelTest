//  
//  LiveCreateHotCoverReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

extension LiveCreateHotCoverReusableView: LiveCreateUpdateTitle {
    public func updateTitle(_ title: String) {
        cardView.titleView.updateTitle(title)
    }
}

class LiveCreateHotCoverReusableView: UICollectionReusableView {
    // MARK: - Properties
    /// 直播封面url
    public private(set) var studioHotLogo: String?

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Getter and Setter
    private lazy var cardView: LiveCreateCardView = {
        let v = LiveCreateCardView(frame: .zero, bottomView: bottomView)
        return v
    }()
    
    private lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    public private(set) lazy var hotCoverButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.regular(12)
        button.setTitle("点击上传".localized, for: .normal)
        button.setTitleColor(0x666666.uiColor, for: .normal)
        button.setBackgroundImage(UIImage(named: "live_hot_cover"), for: .normal)
        button.setImage(UIImage(named: "live_addcover"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
        button.imageDirection(.top, spacing: 4)
        button.addTarget(self, action: #selector(hotCoverButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hotCoverButtonClick))
        iv.addGestureRecognizer(tap)
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
}

// MARK: - Private Methods
private extension LiveCreateHotCoverReusableView {
    func setupUI() {
        [cardView].forEach { addSubview($0) }
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        [hotCoverButton, imageView].forEach { bottomView.addSubview($0) }
        hotCoverButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top)
            make.left.equalToSuperview()
            make.width.equalTo(225.auto())
            make.height.equalTo(106)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(hotCoverButton)
        }
    }
    
    @objc func hotCoverButtonClick() {
//        UploadImageTool.shared.showActionSheet { [weak self] (image) in
//            guard let `self` = self else { return }
//            self.showImageView(image)
//            ProgressHUD.show()
//            UserCenterNetworkService.shared.uploadFile(image: image) { [weak self] (state, message, data) in
//                ProgressHUD.dismiss()
//                guard let `self` = self, let url = data else { return }
//                self.studioHotLogo = url
//            }
//        }
    }
    
    func showImageView(_ image: UIImage? = nil) {
        imageView.isHidden = false
        hotCoverButton.isHidden = true
        
        if let iv = image {
            imageView.image = iv
        }
    }
}
