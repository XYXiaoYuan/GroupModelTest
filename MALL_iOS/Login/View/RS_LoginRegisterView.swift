//
//  LoginRegisterView.swift
//  MALL_iOS
//
//  Created by huang on 2020/7/18.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import RSBaseConfig

// 改auto
public let vv_kHeightRatio:CGFloat =  UIScreen.main.bounds.height/812
typealias FF_TagsBlock = (_ vv_tag: Int) -> Void
func ff_local(_ str: String) -> String {
       return NSLocalizedString(str, comment: "")
}

extension UIButton{
    /// set UIButton image top and label bottom
    public func ff_setHorizonImgText(ff_img:String,ff_title:String,ff_space:CGFloat = 10){
        setTitle(ff_title, for: .normal)
        setImage(UIImage(named: ff_img), for: .normal)
        
        let ff_iw = self.imageView!.width
        let ff_lw = self.titleLabel!.width
        
        self.titleLabel?.textAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -ff_iw, bottom: 0, right: ff_iw)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: ff_lw                                                                         , bottom: 0, right: -ff_lw)
   
    }
}

class LoginRegisterView: UIView {
    
    // 0登录/注册 1立即注册/查看协议 2区号选择 3发验证码
    var vv_actionBlock: FF_TagsBlock?
    
    var vv_lineLeft: UIView! //登录注册辅助指示线
    var vv_lineRight: UIView!
    
    var vv_styleBtns: [UIButton] = [] //登录注册方式切换按钮s
    let vv_margin: CGFloat = 30
    
    var vv_phoneCodeBtn: UIButton! // 区号选择
    var vv_checkCodeBtn: UIButton! // 发验证码 后面看产品 可能改
    var vv_phoneMailTF: UITextField! // 手机号输入框
    var vv_codeTF: UITextField! // 验证码
    var vv_invitationTF: UITextField? // 邀请码
    
    var vv_isLogin: Bool = true
    var vv_haveReadProtocol: Bool = false
    
//    var vv_ = <#value#>
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(isLogin: Bool = true, frame: CGRect) {
        self.init(frame: frame)
        self.vv_isLogin = isLogin
        ff_addSubViews()
        vv_styleBtns.first?.sendActions(for: .touchUpInside)
        hideKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ff_addSubViews() {
        ff_setBackgroundImage(ff_image: "login_back")
        
        let vv_iv = UIImageView(image: UIImage(named: "login_log"))
        addSubview(vv_iv)
        vv_iv.snp.makeConstraints {
            $0.top.equalTo(156*vv_kHeightRatio)
            $0.centerX.equalToSuperview()
        }
        
        ff_addLoginStyleBtns()
        ff_addTextFileds()
        ff_addLoginRegisterBtns()
    }
    // 手机邮箱登录
    func ff_addLoginStyleBtns() {
        let vv_btnPhone = ff_creatChangeLoginStyleButton(ff_local( vv_isLogin ? "login_phoneIn" : "login_phoneRegister"))
        addSubview(vv_btnPhone)
        vv_btnPhone.snp.makeConstraints {
            $0.top.equalTo(320*vv_kHeightRatio)
            $0.left.equalTo(vv_margin)
            $0.width.equalTo(screenWidth/2-vv_margin)
            $0.height.equalTo(17*2+22)
        }
        vv_btnPhone.tag = 0
        let lineL = UIView()
        addSubview(lineL)
        lineL.snp.makeConstraints {
            $0.bottom.left.right.equalTo(vv_btnPhone)
            $0.height.equalTo(1)
        }
        vv_lineLeft = lineL
        
        let vv_btnMail = ff_creatChangeLoginStyleButton(ff_local(vv_isLogin ? "login_mailIn" : "login_mailRegister"))
        addSubview(vv_btnMail)
        vv_btnMail.snp.makeConstraints {
            $0.top.height.width.equalTo(vv_btnPhone)
            $0.right.equalTo(-vv_margin)
        }
        vv_btnMail.tag = 1
        let lineR = UIView()
        addSubview(lineR)
        lineR.snp.makeConstraints {
            $0.bottom.left.right.equalTo(vv_btnMail)
            $0.height.equalTo(1)
        }
        vv_lineRight = lineR
    }
    
    // 输入框
    func ff_addTextFileds() {
        // 邮箱手机号
        vv_phoneMailTF = ff_textFiledPart(top: 20, imageN: "login_mail", ph: "login_phonePlace", tfRMargin: vv_isLogin ? -94-1-12 : -13)
        // 区号
        let vv_codeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 94+1+12, height: 48))
        vv_codeBtn.ff_setHorizonImgText(ff_img: "login_areaCodeTriangle", ff_title: "+86", ff_space: -10)
        vv_codeBtn.titleLabel?.font = UIFont.init(name: "DINAlternate-Bold", size: 18)
        vv_phoneMailTF.superview!.addSubview(vv_codeBtn)
        vv_codeBtn.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.right.equalTo(48)
            $0.width.equalTo(94+1+12)
        }
        vv_codeBtn.addTarget(self, action: #selector(ff_selectPhoneCode), for: .touchUpInside)
        vv_phoneCodeBtn = vv_codeBtn
        
        
        // 验证码
        vv_codeTF = ff_textFiledPart(top: 77, imageN: "login_code", ph: "login_codeNotice", tfRMargin: -94-1-12)
        // 发验证码
        vv_checkCodeBtn = UIButton.ff_btn(ff_title: ff_local("login_codeGet"))
        vv_checkCodeBtn.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 16, ff_style: "Semibold")
        vv_checkCodeBtn.setTitleColor(.white, for: .normal)
        vv_codeTF.superview!.addSubview(vv_checkCodeBtn)
        vv_checkCodeBtn.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(94+12)
        }
        vv_checkCodeBtn.addTarget(self, action: #selector(ff_getCheckCode), for: .touchUpInside)
        // 线
        let line = UIView()
        line.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        vv_codeTF.superview!.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.right.equalTo(-94-12-1)
            $0.bottom.equalTo(-11)
            $0.width.equalTo(1)
        }
        
        // 邀请码
        if !vv_isLogin {
            vv_invitationTF = ff_textFiledPart(top: 133, imageN: "login_invit", ph: "login_codeInvitation", tfRMargin: -13)
        }
    }
    // 登录 注册
    func ff_addLoginRegisterBtns() {
        let vv_login = UIButton.ff_btn(ff_title: ff_local(vv_isLogin ? "login_signIn" : "login_register"))
        addSubview(vv_login)
        vv_login.snp.makeConstraints {
            $0.left.equalTo(vv_lineLeft)
            $0.right.equalTo(vv_lineRight)
            $0.top.equalTo(vv_isLogin ? vv_codeTF.snp.bottom : vv_invitationTF!.snp.bottom).offset(vv_isLogin ? 65 : 29)
            $0.height.equalTo(48)
        }
        vv_login.layer.cornerRadius = 8
        vv_login.backgroundColor = vvc_btnMainBackBlue.uiColor
        vv_login.addTarget(self, action: #selector(ff_loginAction), for: .touchUpInside)
        vv_login.setTitleColor(.white, for: .normal)
        vv_login.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 16, ff_style: "Medium")
        
        if vv_isLogin {
            let vv_reigister = UIButton.ff_btn(ff_title: ff_local("login_gotoRegister"))
            addSubview(vv_reigister)
            vv_reigister.snp.makeConstraints {
                $0.centerX.equalTo(vv_login)
                $0.top.equalTo(vv_login.snp.bottom).offset(10)
                $0.height.equalTo(41)
            }
            vv_reigister.addTarget(self, action: #selector(ff_gotoRegister), for: .touchUpInside)
            vv_reigister.setTitleColor(.white, for: .normal)
            vv_reigister.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 15)
        } else {
            let vv_protocol = UIButton.ff_btn(ff_title: ff_local("login_knownProtocols"))
            addSubview(vv_protocol)
            vv_protocol.snp.makeConstraints {
                $0.centerX.equalTo(vv_login)
                $0.top.equalTo(vv_login.snp.bottom).offset(7)
                $0.height.equalTo(40)
            }
            vv_protocol.addTarget(self, action: #selector(ff_isReadProtocol(sender:)), for: .touchUpInside)
            vv_protocol.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            vv_protocol.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 14)
            vv_protocol.setImage(UIImage(named: "login_protocol_nol"), for: .normal)
            vv_protocol.setImage(UIImage(named: "login_protocol_sel"), for: .selected)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(aaa))
      tap.cancelsTouchesInView = false
      self.addGestureRecognizer(tap)
    }
    
    @objc func aaa(){
        endEditing(true)
    }
}
// MARK: - actions
extension LoginRegisterView {
    // 切换邮箱手机号
    @objc func loginStyleChangedAction(_ sender: UIButton) {
        for item in vv_styleBtns {
            item.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            item.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 16)
        }
        sender.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        sender.titleLabel?.font = UIFont.ff_PFSCFont(ff_size: 17, ff_style: "Semibold")
        
        switch sender.tag {
        case 0:
            vv_lineLeft.backgroundColor = vvc_lineSubColorGreen.uiColor
            vv_lineRight.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            vv_phoneMailTF.placeholder = ff_local("login_phonePlace")
            vv_phoneCodeBtn.isHidden = false
            vv_phoneMailTF.snp.updateConstraints {
                $0.right.equalTo(-94-1-12)
            }
        case 1:
            vv_lineRight.backgroundColor = vvc_lineSubColorGreen.uiColor
            vv_lineLeft.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            vv_phoneMailTF.placeholder = ff_local("login_mailNotice")
            vv_phoneCodeBtn.isHidden = true
            vv_phoneMailTF.snp.updateConstraints {
                $0.right.equalTo(-13)
            }
        default:
            break
        }
    }
    // 0登录 1立即注册
    @objc func ff_loginAction() {
        vv_actionBlock?(0)
        
    }
    // 注册
    @objc func ff_gotoRegister() {
        vv_actionBlock?(1)
    }
    // 协议
    @objc func ff_isReadProtocol(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        vv_haveReadProtocol = sender.isSelected
        vv_actionBlock?(4)
    }
    // 区号选择
    @objc func ff_selectPhoneCode() {
        vv_actionBlock?(2)
    }
    // 发送验证码
    @objc func ff_getCheckCode() {
        vv_actionBlock?(3)
    }
}

// MARK: - creat 手机注册 输入框
extension LoginRegisterView {
    
    func ff_creatChangeLoginStyleButton(_ str: String) -> UIButton {
        let vv_b = UIButton.ff_btn(ff_title: str)
        vv_b.setTitleColor(UIColor.white, for: .selected)
        vv_b.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        addSubview(vv_b)
        vv_b.addTarget(self, action: #selector(loginStyleChangedAction(_:)), for: .touchUpInside)
        vv_styleBtns.append(vv_b)
        return vv_b
    }
    
    // top 是背景距离vv_lineLeft的底部间距 ph是placeHolder，tfRMargin输入框右边距
    func ff_textFiledPart(top: CGFloat, imageN: String, ph: String, tfRMargin: CGFloat) -> UITextField {
        let vv_back = UIView()
        vv_back.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        vv_back.layer.cornerRadius = 8
        addSubview(vv_back)
        vv_back.snp.makeConstraints {
            $0.left.equalTo(vv_lineLeft)
            $0.right.equalTo(vv_lineRight)
            $0.top.equalTo(vv_lineLeft).offset(top)
            $0.height.equalTo(48)
        }
        let vv_iv = UIImageView(image: UIImage(named: imageN))
        vv_back.addSubview(vv_iv)
        vv_iv.snp.makeConstraints {
            $0.left.equalTo(13)
            $0.centerY.equalToSuperview()
        }
        let vv_tf = ff_creatTextFiled(ph: ff_local(ph), tag: 0)
        vv_back.addSubview(vv_tf)
        vv_tf.snp.makeConstraints {
            $0.left.equalTo(48)
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(tfRMargin)
        }
        return vv_tf
    }
    
    func ff_creatTextFiled(ph: String, tag: Int) -> UITextField {
        let vv_t = UITextField()
        vv_t.font = UIFont.ff_PFSCFont(ff_size: 16)
        vv_t.placeholder = ph
        vv_t.ff_setPlaceholderColor(ff_color: UIColor.white.withAlphaComponent(0.5))
        vv_t.delegate = self
        vv_t.tag = tag
        return vv_t
    }
}

// MARK: - UITextFieldDelegate
extension LoginRegisterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
