//  
//  ViewController.swift
//  GroupModelTest
//
//  Created by 袁小荣 on 2021/12/2.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

enum PageType: String, CaseIterable {
    case home = "历史记录"
    case financial = "我的理财"
    case apply = "申请直播"
}

class ViewController: BaseViewController {
    
    var list: [PageType] = PageType.allCases
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
    }

    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF9F9F9.uiColor
        navi_topView.backgroundColor = UIColor.white
        
        title = "GroupModelTest"
    }
    
    // MARK: - Getter and Setter
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.rowHeight = 44
        tableView.sectionFooterHeight = 0.00000001
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

// MARK: - Private Methods
private extension ViewController {
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navi_topView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier)!
        let pageType = list[indexPath.row]
        cell.textLabel?.text = pageType.rawValue
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageType = list[indexPath.row]
        switch pageType {
        case .home:
            let vc = HomeViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .financial:
            let vc = FinanciaViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .apply:
            let vc = LiveCreateViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
